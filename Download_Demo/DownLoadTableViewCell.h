//
//  DownLoadTableViewCell.h
//  Download_Demo
//
//  Created by 陈小明 on 2017/3/23.
//  Copyright © 2017年 陈小明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHC_DownloadObject.h"

@protocol DownLoadTableViewCellDelegate <NSObject>

- (void)videoDownload:(NSError *)error index:(NSInteger)index strUrl:(NSString *)strUrl;
- (void)updateDownloadValue:(WHC_DownloadObject *)downloadObject index:(NSInteger)index;
- (void)videoPlayerIndex:(NSInteger)index;

@end


@interface DownLoadTableViewCell : UITableViewCell

@property(nonatomic,weak)id<DownLoadTableViewCellDelegate> delegate;

@property (nonatomic , assign)NSInteger index;
@property (nonatomic, assign) NSInteger cellIndex;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)displayCell:(WHC_DownloadObject *)object index:(NSInteger)index;

//从新把任务添加到下载线程，开始下载任务
-(void)addDownloadMissionWithObject:(WHC_DownloadObject*)downloadObject;
// 取消掉下载任务
-(void)cancelDownloadMissionWithObject:(WHC_DownloadObject*)downloadObject;



@end
