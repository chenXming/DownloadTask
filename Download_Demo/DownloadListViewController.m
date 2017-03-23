//
//  DownloadListViewController.m
//  Download_Demo
//
//  Created by 陈小明 on 2017/3/23.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import "DownloadListViewController.h"
#import "WHC_HttpManager.h"
#import "WHC_DownloadObject.h"
#import "CXMProgressView.h"
#import "DownLoadTableViewCell.h"

@interface DownloadListViewController ()<UITableViewDelegate,UITableViewDataSource,DownLoadTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    NSString *_timerInter;

}
@end

@implementation DownloadListViewController
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
  
    self.title = @"全部下载任务";

    [self initData];
    [self makeTableView];
    [self makeDownloadData];
}
-(void)initData{

  
    _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
}
-(void)makeTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    
    UIView *footView =[[UIView alloc] init];
    _tableView.tableFooterView = footView;

}
-(void)makeDownloadData{

    _dataArr = [NSMutableArray arrayWithArray:[WHC_DownloadObject readDiskAllCache]];
    NSLog(@"_mainArr========%@",_dataArr);


}
#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell =nil;
//    _timerInter =[self getTimerInvster];
//    NSString *identifer = [NSString stringWithFormat:@"INDEXPATH%ld_%@",(long)indexPath.row,_timerInter];
    NSString *identifer = @"Cell_Identifer";
    cell =[tableView dequeueReusableCellWithIdentifier:identifer];
    
    if(cell==nil){
        DownLoadTableViewCell *offcell =[[DownLoadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        [offcell setCellIndex:indexPath.row];
        WHC_DownloadObject *downloadObject =[_dataArr objectAtIndex:indexPath.row];
        [offcell  displayCell:downloadObject index:indexPath.row];
        offcell.delegate=self;
        cell =offcell;
    }
    cell.contentView.backgroundColor=RGBACOLOR(233, 237, 240, 1);
    cell.tintColor =RGBACOLOR(239, 66, 89, 1);
    return cell;
    
}
#pragma mark 横划删除方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    WHC_DownloadObject * downloadObject = _dataArr[row];
    
    [[WHC_HttpManager shared] cancelDownloadWithFileName:downloadObject.fileName deleteFile:YES];
    
    [downloadObject removeFromDisk];
    
    //[downloadObject removeFromDisk];
    [_dataArr removeObjectAtIndex:row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

-(NSString *)getTimerInvster{
    
    NSString *timer =[NSString stringWithFormat:@"ID_%f",[NSDate date].timeIntervalSince1970];
    return timer;
    
}

#pragma mark - WHC_OffLineVideoCellDelegate
- (void)videoDownload:(NSError *)error index:(NSInteger)index strUrl:(NSString *)strUrl {
    if (error != nil) {
        NSLog(@"error.userInfo[NSLocalizedDescriptionKey]==%@",error.userInfo[NSLocalizedDescriptionKey]);
        
        [CXMProgressView showErrorText:@"下载链接出错，请重新下载"];
    }
    WHC_DownloadObject * downloadObject = _dataArr[index];
    [downloadObject removeFromDisk];
    [_dataArr removeObjectAtIndex:index];
    [_tableView reloadData];
}

- (void)updateDownloadValue:(WHC_DownloadObject *)downloadObject index:(NSInteger)index {
    if (downloadObject != nil) {
        WHC_DownloadObject * tempDownloadObject = _dataArr[index];
        tempDownloadObject.currentDownloadLenght = downloadObject.currentDownloadLenght;
        tempDownloadObject.totalLenght = downloadObject.totalLenght;
        tempDownloadObject.downloadSpeed = downloadObject.downloadSpeed;
        tempDownloadObject.downloadState = downloadObject.downloadState;
    }
}

- (void)videoPlayerIndex:(NSInteger)index {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
