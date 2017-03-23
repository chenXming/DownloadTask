//
//  ViewController.m
//  Download_Demo
//
//  Created by 陈小明 on 2017/3/22.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import "ViewController.h"
#import "DownloadListViewController.h"
#import "WHC_HttpManager.h"
#import "WHC_DownloadObject.h"
#import "CXMProgressView.h"

// 视频下载地址
#define kWHC_DefaultDownloadUrl   (@"http://app.1000phone.com/%E5%8D%83%E9%94%8BSwift%E8%A7%86%E9%A2%91%E6%95%99%E7%A8%8B-1.Swift%E8%AF%AD%E8%A8%80%E4%BB%8B%E7%BB%8D.mp4")

@interface ViewController ()
{

    NSInteger titleCount;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下载任务页面";
    [self inidData];

    [self makeMainUI];
}
-(void)inidData{

    titleCount = 0;

    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];

}
-(void)makeMainUI{

    NSLog(@"homeDicPath == %@",NSHomeDirectory());
  
    UIButton *downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downLoadBtn setTitle:@"点击下载任务" forState:UIControlStateNormal];
    [downLoadBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [downLoadBtn setBackgroundColor:[UIColor greenColor]];
    downLoadBtn.frame = CGRectMake((self.view.frame.size.width -150)/2, 100, 150, 45);
    [downLoadBtn addTarget:self action:@selector(downloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:downLoadBtn];
    
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBtn setTitle:@"PUSH" forState:UIControlStateNormal];
    [pushBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [pushBtn setBackgroundColor:[UIColor cyanColor]];
    pushBtn.frame = CGRectMake((self.view.frame.size.width -150)/2, 200, 150, 45);
    [pushBtn addTarget:self action:@selector(pushBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pushBtn];


}
-(void)downloadBtnClick{

    NSLog(@"下载任务");

    // 获取后缀
    NSString * suffix = [[WHC_HttpManager shared] fileFormatWithUrl:kWHC_DefaultDownloadUrl];
    
    NSString *uid = @"0000001";
    
    NSString * fileName = [NSString stringWithFormat:@"%@%@%@",uid,[NSString stringWithFormat:@"视频下载测试——Swift讲解(%ld)",(long)titleCount++],suffix != nil ? suffix : @".mp4"];
    
    NSLog(@"fileName=======%@",fileName);
    
    
    __weak typeof(self) weakSelf = self;
    WHC_DownloadOperation * downloadTask = nil;
    downloadTask = [[WHC_HttpManager shared] download:kWHC_DefaultDownloadUrl
                        savePath:[WHC_DownloadObject videoDirectory]
                        saveFileName:fileName
                        response:^(WHC_BaseOperation *operation, NSError *error, BOOL isOK) {
                              if (isOK) {
                                                     
                                             WHC_DownloadOperation * downloadOperation = (WHC_DownloadOperation*)operation;
                                             WHC_DownloadObject * downloadObject = [WHC_DownloadObject readDiskCache:operation.strUrl];
                                             if (downloadObject == nil) {
                                                 [CXMProgressView showText:@"已经添加到下载队列"];
                                                 downloadObject = [WHC_DownloadObject new];
                                             }
                                             downloadObject.fileName = downloadOperation.saveFileName;
                                             downloadObject.downloadPath = downloadOperation.strUrl;
                                             downloadObject.downloadState = WHCDownloading;
                                             downloadObject.currentDownloadLenght = downloadOperation.recvDataLenght;
                                             downloadObject.totalLenght = downloadOperation.fileTotalLenght;
                                             [downloadObject writeDiskCache];
                                        }else {
                                         [weakSelf errorHandle:(WHC_DownloadOperation *)operation error:error];
                                        }
                        } process:^(WHC_BaseOperation *operation, uint64_t recvLength, uint64_t totalLength, NSString *speed) {
                                                 //  NSLog(@"recvLength = %llu totalLength = %llu speed = %@",recvLength , totalLength , speed);
                        } didFinished:^(WHC_BaseOperation *operation, NSData *data, NSError *error, BOOL isSuccess) {
                                        
                                     if (isSuccess) {
                                         
                                         NSLog(@"下载成功视频");
                                         //  下载成功后保存装载
                                         [weakSelf saveDownloadStateOperation:(WHC_DownloadOperation *)operation];
                                     }else {
                                         [weakSelf errorHandle:(WHC_DownloadOperation *)operation error:error];
                                         if (error != nil &&error.code == WHCCancelDownloadError) {
                                             [weakSelf saveDownloadStateOperation:(WHC_DownloadOperation *)operation];
                                         }
                                     }
                        }];
    
    if (downloadTask.requestStatus == WHCHttpRequestNone) {
        
        if (![[WHC_HttpManager shared] waitingDownload]) {
            return;
        }
        WHC_DownloadObject * downloadObject = [WHC_DownloadObject readDiskCache:downloadTask.strUrl];
        if (downloadObject == nil) {

            [CXMProgressView showText:@"已经添加到下载队列"];

            downloadObject = [WHC_DownloadObject new];
        }
        downloadObject.fileName = fileName;
        downloadObject.downloadPath = kWHC_DefaultDownloadUrl;
        downloadObject.downloadState = WHCDownloadWaitting;
        downloadObject.currentDownloadLenght = 0;
        downloadObject.totalLenght = 0;
        [downloadObject writeDiskCache];
    }
}
- (void)saveDownloadStateOperation:(WHC_DownloadOperation *)operation {
    WHC_DownloadObject * downloadObject = [WHC_DownloadObject readDiskCache:operation.strUrl];
    if (downloadObject != nil) {
        downloadObject.currentDownloadLenght = operation.recvDataLenght;
        downloadObject.totalLenght = operation.fileTotalLenght;
        [downloadObject writeDiskCache];
    }
}

- (void) errorHandle:(WHC_DownloadOperation *)operation error:(NSError *)error {
    NSString * errInfo = error.userInfo[NSLocalizedDescriptionKey];
    
    NSLog(@"error=======%@",errInfo);
    if ([errInfo containsString:@"404"]) {

        [CXMProgressView showErrorText:@"该文件不存在,链接错误"];
        WHC_DownloadObject * downloadObject = [WHC_DownloadObject readDiskCache:operation.strUrl];
        if (downloadObject != nil) {
            [downloadObject removeFromDisk];
        }
    }else if ([errInfo isEqualToString:@"已在下载列表中"]){
        
        [CXMProgressView showText:@"已在下载列表中,去看看吧 "];

        
    }else if([errInfo isEqualToString:@"下载失败"]){
        
        [CXMProgressView showErrorText:@"下载失败"];
        
    }else{
        if ([errInfo containsString:@"已经在下载中"]) {
            [CXMProgressView showErrorText:@"已在下载列表中"];

        }else {
            [CXMProgressView showErrorText:@"下载失败"];

        }
    }
}
-(void)pushBtnClick{
  
    DownloadListViewController *downloadVC = [[DownloadListViewController alloc] init];
    [self.navigationController pushViewController:downloadVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
