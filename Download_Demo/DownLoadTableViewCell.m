//
//  DownLoadTableViewCell.m
//  Download_Demo
//
//  Created by 陈小明 on 2017/3/23.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import "DownLoadTableViewCell.h"
#import "WHC_BaseOperation.h"
#import "Masonry.h"
#import "WHC_HttpManager.h"


@interface DownLoadTableViewCell ()<WHC_DownloadDelegate>
{
    UIImageView *_imageView;
    UIButton *_downloadButton;
    WHC_DownloadObject          * _downloadObject;
    NSInteger angle;// 旋转标记
    UIImageView *_circleView;
    NSString *uidStr;
    BOOL _isAnmition;
    BOOL _isPause;// 旋转动画是否暂停
}
@property (nonatomic , strong) UILabel          * titleLabel;// 标题
@property (nonatomic , strong) UILabel          * downloadValueLabel;// 显示大小
@property (nonatomic , strong) UILabel          * speedLabel; // 下载速度，及状态显示
@property (nonatomic , strong) UIProgressView   * progressBar; //下载进度条

@end



@implementation DownLoadTableViewCell

#define IMAGEWIDTH (125*SCREEN_WIDTH)/375
#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if(self){

        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
        [self makeMainUI];

    }

    
    return self;
}
-(void)makeMainUI{
    
    _isAnmition=NO;
    _isPause=NO;
    
    self.backgroundColor =[UIColor whiteColor];
    
    _imageView =[[UIImageView alloc] initWithFrame:CGRectMake(10,15,IMAGEWIDTH,IMAGEWIDTH/2)];
    if(SCREEN_WIDTH==320.0f){
        _imageView.frame =CGRectMake(10, 15, IMAGEWIDTH, IMAGEWIDTH/2+5);
    }
    _imageView.backgroundColor =[UIColor lightGrayColor];
    _imageView.layer.masksToBounds= YES;
    _imageView.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:_imageView];
    
    _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(20+IMAGEWIDTH,5,SCREEN_WIDTH-20-IMAGEWIDTH,50)];
    _titleLabel.numberOfLines =0;
    _titleLabel.textColor=[UIColor blackColor];
    _titleLabel.text =@"IOS开发- C语言篇我还能促进农科教按随处可见你才离开ceshi";
    _titleLabel.font =[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
    
    UIImage *loadwaiting=[UIImage imageNamed:@"loadwaiting"];
    _downloadButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_downloadButton setImage:[UIImage imageNamed:@"loadwaiting"] forState:UIControlStateNormal];
    _downloadButton.selected=NO;
    _downloadButton.backgroundColor =[UIColor clearColor];
    [_downloadButton addTarget:self action:@selector(downloadBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_downloadButton];
    [_downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_imageView);
        make.left.equalTo(_imageView.mas_right).offset(10);
        make.width.mas_equalTo(loadwaiting.size.width);
        make.height.mas_equalTo(loadwaiting.size.height);
    }];
    
    UIImage *loaddowning =[UIImage imageNamed:@"loaddowning"];
    _circleView=[UIImageView new];
    _circleView.image =loaddowning;
    _circleView.backgroundColor =[UIColor clearColor];
    _circleView.userInteractionEnabled=NO;
    [self.contentView addSubview:_circleView];
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_downloadButton);
        make.centerY.equalTo(_downloadButton);
        make.width.mas_equalTo(loaddowning.size.width);
        make.height.mas_equalTo(loaddowning.size.height);
    }];
    
    
    _speedLabel=[UILabel new];
    _speedLabel.backgroundColor =[UIColor clearColor];
    _speedLabel.font =[UIFont systemFontOfSize:13];
    _speedLabel.text= @"等待中...";
    _speedLabel.textColor =[UIColor lightGrayColor];
    [self.contentView addSubview:_speedLabel];
    [_speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downloadButton.mas_right).offset(10);
        make.bottom.equalTo(_downloadButton);
    }];
    
    _downloadValueLabel =[UILabel new];
    _downloadValueLabel.text =@"0.0M/0.0M";
    _downloadValueLabel.textColor= [UIColor blackColor];
    _downloadValueLabel.backgroundColor =[UIColor clearColor];
    _downloadValueLabel.font =[UIFont systemFontOfSize:13];
    [self.contentView addSubview:_downloadValueLabel];
    [_downloadValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLabel).offset(-10);
        make.bottom.equalTo(_imageView);
    }];
    
    _progressBar =[[UIProgressView alloc] initWithFrame:CGRectMake(0,90-3,SCREEN_WIDTH,2)];
    _progressBar.tintColor =RGBACOLOR(42, 183, 206, 1);
    _progressBar.trackTintColor =[UIColor lightGrayColor];
    _progressBar.progress =0.5;
    [self.contentView addSubview:_progressBar];
    
    UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0,89,SCREEN_WIDTH,1/[UIScreen mainScreen].scale)];
    lineView.backgroundColor =[UIColor lightGrayColor];
    [self.contentView addSubview:lineView];
    
}

- (void)updateDownloadValue {
    _progressBar.progress = _downloadObject.downloadProcessValue;
    _downloadValueLabel.text = _downloadObject.downloadProcessText;
    NSString * strSpeed = _downloadObject.downloadSpeed;
    if (_downloadObject.downloadState != WHCDownloading) {
        _circleView.hidden=YES;
        
    }else {
        if(_isAnmition==NO){
            _circleView.hidden=NO;
            if(_isPause==NO){
                [self startAnimation];
                _isPause=YES;
            }else{
                [self resumeLayer:_imageView.layer];
            }
            _isAnmition=YES;
        }
        // [self startDownloadAnimation];
    }
    switch (_downloadObject.downloadState) {
        case WHCDownloadWaitting:{
            [_downloadButton setImage:[UIImage imageNamed:@"loadwaiting"] forState:UIControlStateNormal];
            strSpeed = @"等待中...";
            _speedLabel.textColor =[UIColor lightGrayColor];
        }
            break;
        case WHCDownloading:{
            [_downloadButton setImage:[UIImage imageNamed:@"loaddowning"] forState:UIControlStateNormal];
            _speedLabel.textColor =RGBACOLOR(42, 183, 206, 1);
        }
            break;
        case WHCDownloadCanceled:{
            
            [_downloadButton setImage:[UIImage imageNamed:@"loadpause"] forState:UIControlStateNormal];
            strSpeed = @"暂停";
            _speedLabel.textColor =[UIColor blackColor];
            
        }
            break;
        case WHCDownloadCompleted:{
            [_downloadButton setImage:[UIImage imageNamed:@"loadcompelate"] forState:UIControlStateNormal];
            strSpeed = @"缓存完成";
            _downloadButton.userInteractionEnabled=NO;
            _progressBar.hidden=YES;
            _speedLabel.textColor =RGBACOLOR(60, 179, 89, 1);
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"DoenloadMissionCompleted" object:nil userInfo:nil];
        }
        case WHCNone:
            break;
    }
    _speedLabel.text = strSpeed;
}

- (void)downloadBtnDown:(UIButton *)sender {
    
    NSLog(@"index=======%ld",(long)self.index);
    switch (_downloadObject.downloadState) {
        case WHCDownloading:{
            _downloadObject.downloadState = WHCDownloadCanceled;
            [[WHC_HttpManager shared] cancelDownloadWithFileName:_downloadObject.fileName deleteFile:NO];
            if(_isAnmition==YES){
                
                [self pauseLayer:_imageView.layer];
            }
        }
            break;
        case WHCDownloadCanceled:{
            _isAnmition=NO;
            
            _downloadObject.downloadState = WHCDownloadWaitting;
            WHC_DownloadOperation * operation = [[WHC_HttpManager shared] download:_downloadObject.downloadPath
                                                                          savePath:[WHC_DownloadObject videoDirectory]
                                                                      saveFileName:_downloadObject.fileName delegate:self];
            operation.index = self.index;
            [self updateDownloadValue];
        }
            break;
        case WHCDownloadWaitting:
            break;
        case WHCDownloadCompleted:
            if (_delegate && [_delegate respondsToSelector:@selector(videoPlayerIndex:)]) {
                [_delegate videoPlayerIndex:_index];
            }
            break;
        default:
            break;
    }
}
-(void)addDownloadMissionWithObject:(WHC_DownloadObject*)downloadObject{
    
    _isAnmition=NO;
    downloadObject.downloadState = WHCDownloadWaitting;
    WHC_DownloadOperation * operation = [[WHC_HttpManager shared] download:downloadObject.downloadPath
                                                                  savePath:[WHC_DownloadObject videoDirectory]
                                                              saveFileName:downloadObject.fileName delegate:self];
    operation.index = self.index;
    [self updateDownloadValue];
    
}
-(void)cancelDownloadMissionWithObject:(WHC_DownloadObject*)downloadObject{
    
    downloadObject.downloadState = WHCDownloadCanceled;
    [[WHC_HttpManager shared] cancelDownloadWithFileName:downloadObject.fileName deleteFile:NO];
    if(_isAnmition==YES){
        
        [self pauseLayer:_imageView.layer];
    }
}
- (void)displayCell:(WHC_DownloadObject *)object index:(NSInteger)index {
    
    // NSLog(@"=====%ld",(long)index);
    // 添加网络图片
//    NSString *titleStr=object.fileName;
//    //  NSLog(@"fileName======%@",object.fileName);
//    NSInteger uidLength =uidStr.length;
//    NSString *subStr =[titleStr substringFromIndex:uidLength];
//    NSArray *strArr =[subStr componentsSeparatedByString:@"."];
//    NSString *imageStr =strArr[0];
    //NSString*imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:imageStr];
    //[_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    
    _imageView.image = [UIImage imageNamed:@"placeholder_icon"];
    NSString *titleStr=object.fileName;
    NSInteger uidLength =uidStr.length;
    NSString *subStr =[titleStr substringFromIndex:uidLength];
    _titleLabel.text = subStr;
    
    self.index = index;
    _downloadObject = object;
    if (_downloadObject.downloadState == WHCNone ||
        _downloadObject.downloadState == WHCDownloading ) {
        _downloadObject.downloadState = WHCDownloadWaitting;
    }
    
    WHC_DownloadOperation * operation = [[WHC_HttpManager shared] replaceCurrentDownloadOperationDelegate:self fileName:_downloadObject.fileName];
    if ([[WHC_HttpManager shared] existDownloadOperationTaskWithFileName:_downloadObject.fileName]) {
        if (_downloadObject.downloadState == WHCDownloadCanceled) {
            _downloadObject.downloadState = WHCDownloadWaitting;
        }
    }else{// 缓存完成的
        if(_downloadObject.downloadState==WHCDownloadCompleted){
            _downloadObject.downloadState = WHCDownloadCompleted;
            _downloadButton.userInteractionEnabled=NO;
            _progressBar.hidden=YES;
            _speedLabel.textColor =RGBACOLOR(60, 179, 89, 1);
            _speedLabel.text =@"缓存完成";
        }else{
            _downloadObject.downloadState = WHCDownloadCanceled;
        }
    }
    operation.index = index;
    [self updateDownloadValue];
    //  [self removeDownloadAnimtion];
}

- (void)saveDownloadState:(WHC_DownloadOperation *)operation {
    _downloadObject.currentDownloadLenght = operation.recvDataLenght;
    _downloadObject.totalLenght = operation.fileTotalLenght;
    [_downloadObject writeDiskCache];
}
#pragma mark - 图片旋转
// 图片旋转
-(void)startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.05f];//转的速度
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(circileAnimation)];
    _circleView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
    
}
-(void)circileAnimation
{
    angle += 10;
    [self startAnimation];
}
// 暂停动画
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

// 恢复动画
-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark - WHC_DownloadDelegate -
- (void)WHCDownloadResponse:(nonnull WHC_DownloadOperation *)operation
                      error:(nullable NSError *)error
                         ok:(BOOL)isOK {
    if (isOK) {
        if (self.index == operation.index) {
            _downloadObject.downloadState = WHCDownloading;
            _downloadObject.currentDownloadLenght = operation.recvDataLenght;
            _downloadObject.totalLenght = operation.fileTotalLenght;
            [self updateDownloadValue];
        }else {
            WHC_DownloadObject * tempDownloadObject = [WHC_DownloadObject readDiskCache:operation.strUrl];
            if (tempDownloadObject != nil) {
                tempDownloadObject.downloadState = WHCDownloading;
                tempDownloadObject.currentDownloadLenght = operation.recvDataLenght;
                tempDownloadObject.totalLenght = operation.fileTotalLenght;
                [tempDownloadObject writeDiskCache];
                if (_delegate && [_delegate respondsToSelector:@selector(updateDownloadValue: index:)]) {
                    [_delegate updateDownloadValue:tempDownloadObject index:operation.index];
                }
            }
        }
    }else {
        _downloadObject.downloadState = WHCNone;
        if (_delegate &&
            [_delegate respondsToSelector:@selector(videoDownload:index:strUrl:)]) {
            [_delegate videoDownload:error index:_index strUrl:operation.strUrl];
        }
    }
}

- (void)WHCDownloadProgress:(nonnull WHC_DownloadOperation *)operation
                       recv:(uint64_t)recvLength
                      total:(uint64_t)totalLength
                      speed:(nullable NSString *)speed {
    if (operation.index == self.index) {
        if (_downloadObject.totalLenght < 10) {
            _downloadObject.totalLenght = totalLength;
        }
        _downloadObject.currentDownloadLenght = recvLength;
        _downloadObject.downloadSpeed = speed;
        _downloadObject.downloadState = WHCDownloading;
        [self updateDownloadValue];
        //  [self startDownloadAnimation];
    }
}

- (void)WHCDownloadDidFinished:(nonnull WHC_DownloadOperation *)operation
                          data:(nullable NSData *)data
                         error:(nullable NSError *)error
                       success:(BOOL)isSuccess {
    if (isSuccess) {
        if (self.index == operation.index) {
            _downloadObject.downloadState = WHCDownloadCompleted;
            [self saveDownloadState:operation];
        }else {
            WHC_DownloadObject * tempDownloadObject = [WHC_DownloadObject readDiskCache:operation.strUrl];
            if (tempDownloadObject != nil) {
                tempDownloadObject.downloadState = WHCDownloadCompleted;
                tempDownloadObject.currentDownloadLenght = operation.recvDataLenght;
                tempDownloadObject.totalLenght = operation.fileTotalLenght;
                [tempDownloadObject writeDiskCache];
                if (_delegate && [_delegate respondsToSelector:@selector(updateDownloadValue:index:)]) {
                    [_delegate updateDownloadValue:tempDownloadObject index:operation.index];
                }
            }
        }
    }else {
        
        WHC_DownloadObject * tempDownloadObject;
        if (self.index == operation.index) {
            _downloadObject.downloadState = WHCDownloadCanceled;
        }else {
            tempDownloadObject = [WHC_DownloadObject readDiskCache:operation.strUrl];
            if (tempDownloadObject != nil) {
                tempDownloadObject.downloadState = WHCDownloadCanceled;
            }
        }
        NSLog(@"error ==== %@",error);
        
        if (error != nil &&
            error.code == WHCCancelDownloadError &&
            !operation.isDeleted) {
            if (self.index == operation.index) {
                [self saveDownloadState:operation];
            }else {
                if (tempDownloadObject != nil) {
                    tempDownloadObject.currentDownloadLenght = operation.recvDataLenght;
                    tempDownloadObject.totalLenght = operation.fileTotalLenght;
                    [tempDownloadObject writeDiskCache];
                }
                
            }
            [self saveDownloadState:operation];
        }else if(error.code == -1005||error.code ==-1009){
            
            NSLog(@"网络链接中断，下载暂停");
            //   [[[UIAlertView alloc] initWithTitle:@"下载取消" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        if (tempDownloadObject != nil) {
            if (_delegate && [_delegate respondsToSelector:@selector(updateDownloadValue:index:)]) {
                [_delegate updateDownloadValue:tempDownloadObject index:operation.index];
            }
        }
    }
    if (self.index == operation.index) {
        [self updateDownloadValue];
    }
}



@end
