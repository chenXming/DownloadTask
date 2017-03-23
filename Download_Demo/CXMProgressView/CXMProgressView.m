//
//  CXMProgressView.m
//  MBProgressHud_Demo
//
//  Created by 陈小明 on 2016/12/12.
//  Copyright © 2016年 陈小明. All rights reserved.
//

#import "CXMProgressView.h"
#import "AppDelegate.h"

@interface CXMProgressView()

@end


@implementation CXMProgressView

+ (void)showTextWithCircle:(NSString *)aText{

    [self dismissLoading];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    hud.label.numberOfLines = 0;
   // hud.removeFromSuperViewOnHide = YES;//hud隐藏时同时从父视图上移除

    // Set the label text.
    hud.label.text = aText;
    [app.window bringSubviewToFront:hud];
}

+ (void)showText:(NSString *)aText{

    [self dismissLoading];

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    hud.mode = MBProgressHUDModeText;

    // Move to bottm center.
   // hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    // Set the label text.
    hud.label.text = aText;
    hud.label.numberOfLines = 0;
    [hud hideAnimated:YES afterDelay:[self displayDurationForString:aText]];
}

+(void)dismissLoading{

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [MBProgressHUD hideHUDForView:app.window animated:YES];

}
+(void)showErrorText:(NSString *)aText{

    [self dismissLoading];

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"progressView_error"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
    
    hud.customView =complateView;
    
    hud.label.text = aText;
    hud.label.numberOfLines = 0;

    [hud hideAnimated:YES afterDelay:[self displayDurationForString:aText]];
    
}
+ (void)showSuccessText:(NSString *)aText{

    [self dismissLoading];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"progressView_success"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
    
    hud.customView =complateView;
    
    hud.label.text = aText;
    hud.label.numberOfLines = 0;

    [hud hideAnimated:YES afterDelay:[self displayDurationForString:aText]];

}
// 根据 提示文字字数，判断 HUD 显示时间
+ (NSTimeInterval)displayDurationForString:(NSString*)string
{
    return MAX((float)string.length*0.06 + 0.5, 2.0);
}

+(void)showText:(NSString *)aText hideComplete:(ProgressHideComplete)complete{
    [self dismissLoading];

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = aText;
    hud.label.numberOfLines = 0;

    NSTimeInterval time = [self displayDurationForString:aText];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(time);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            if(complete ==nil){
                return ;
            }
            complete();
        });
    });
}
+(void)showErrorText:(NSString *)aText hideComplete:(ProgressHideComplete)complete{
    [self dismissLoading];

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"progressView_error"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
    
    hud.customView =complateView;
    
    hud.label.text = aText;
    hud.label.numberOfLines = 0;

    NSTimeInterval time = [self displayDurationForString:aText];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(time);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            if(complete ==nil){
                return ;
            }
            complete();
        });
    });

}
+(void)showSuccessText:(NSString *)aText hideComplete:(ProgressHideComplete)complete{
    [self dismissLoading];

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"progressView_success"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
    
    hud.customView =complateView;
    
    hud.label.text = aText;
    hud.label.numberOfLines = 0;
    NSTimeInterval time = [self displayDurationForString:aText];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(time);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            if(complete ==nil){
                return ;
            }
            complete();
        });
    });

}
@end
