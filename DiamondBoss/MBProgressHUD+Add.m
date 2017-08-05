//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.frame = CGRectMake(0, 0, 100, 100);

    if (icon) {
        hud.square = YES; // 方形
        // 设置图片
        UIImageView *imageView = [[UIImageView alloc] initWithImage:LOADIMAGE_NAME(icon)];
        hud.customView = imageView;
    }
    
    hud.detailsLabelText = notNil(text);
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:12];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1.5秒之后再消失
    if (text.length > 10) {
        [hud hide:YES afterDelay:2.5];
    }else{
        [hud hide:YES afterDelay:1.5];
    }
//    [hud hide:YES afterDelay:1.5];
}

+ (MBProgressHUD *)showActiveMessag:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
   
    if ([error isKindOfClass:[NSNull class]] || [error isEqualToString:@"null"] || !error.length) {
       
   
    }else{
        
        [self show:error icon:nil view:view];
    }
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    if ([success isEqualToString:@"null"]) {
        success = @"";
    }
    if (success.length) {
        [self show:success icon:@"success" view:view];
    }
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.labelFont = [UIFont boldSystemFontOfSize:12];
    hud.margin = 15; //内容边距
    hud.square = YES;
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    
    hud.customView = [[UIImageView alloc] initWithImage:LOADIMAGE_NAME(@"alertLoading")];
    
    hud.mode = MBProgressHUDModeCustomView;

    return hud;
}

#pragma mark 小菊花
+ (void)showIndicatorInview:(UIView *)view style:(UIActivityIndicatorViewStyle)style center:(CGPoint)center
{
    [MBProgressHUD removeIndicatorInview:view];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:style];
//    indicator.frame = CGRectMake(0, 0, 30, 30);
    indicator.center = center;

    [view addSubview:indicator];
    [indicator startAnimating];
}

+ (void)removeIndicatorInview:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UIActivityIndicatorView class]]) {
            [(UIActivityIndicatorView *)v stopAnimating];
            [v removeFromSuperview];
        }
    }
}
@end
