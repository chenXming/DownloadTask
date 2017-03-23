//
//  CXMProgressView.h
//  MBProgressHud_Demo
//
//  Created by 陈小明 on 2016/12/12.
//  Copyright © 2016年 陈小明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHud.h"


typedef void(^ProgressHideComplete)(void);

@interface CXMProgressView : NSObject

/**
 *  只显示纯文本
 *
 * @param aText 要显示的文本
 */
+(void)showText:(NSString*)aText;

/**
*  显示纯文本 加一个转圈
*
*  @param aText 要显示的文本
*/
+ (void)showTextWithCircle:(NSString *)aText;

/**
 *  隐藏加载框（所有类型的加载框 都可以通过这个方法 隐藏）
 */
+ (void)dismissLoading;

/**
 *  显示错误信息
 *
 *  @param aText 错误信息文本
 */
+ (void)showErrorText:(NSString *)aText;

/**
 *  显示成功信息
 *
 *  @param aText 成功信息文本
 */
+ (void)showSuccessText:(NSString *)aText;
/**
 *  显示文本信息，以及hud隐藏后的回掉
 *
 *  @param aText 成功信息文本
 *  @param complete 展示完成后的回掉
 */
+(void)showText:(NSString *)aText hideComplete:(ProgressHideComplete)complete;
/**
 *  显示成功文本信息，以及hud隐藏后的回掉
 *
 *  @param aText 成功信息文本
 *  @param complete 展示完成后的回掉
 */
+(void)showSuccessText:(NSString *)aText hideComplete:(ProgressHideComplete)complete;
/**
 *  显示错误文本信息，以及hud隐藏后的回掉
 *
 *  @param aText 错误信息文本
 *  @param complete 展示完成后的回掉
 */
+(void)showErrorText:(NSString *)aText hideComplete:(ProgressHideComplete)complete;

@end
