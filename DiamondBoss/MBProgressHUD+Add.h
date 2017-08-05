//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

// 错误提示
static NSString * const HUDPasswordFormatErrorRemindString = @"密码格式不合法";
static NSString * const HUDUsernameFormatErrorRemindString = @"用户名不合法";
static NSString * const HUDPhoneErrorRemindString = @"手机号格式不对";
static NSString * const HUDMoneyErrorRemindString = @"输入的金额格式不对";
static NSString * const HUDChangeMessagePCErrorRemindString = @"您是pc端注册的帐号，请至pc端修改";
static NSString * const HUDUsernameLengthMinRemindString = @"用户名最低4位";
static NSString * const HUDPasswordLengthMinRemindString = @"密码最低6位";

static NSString * const HUDLoadingRemindString = @"正在加载";


@interface MBProgressHUD (Add)
/**
 *  类似错误信息的提示框(没有菊花的试图)
 *
 *  @param text 提示内容
 *  @param icon 提示的图片(原本菊花换成自己给的图片)
 *  @param view 加载的试图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;
//转盘次数提示框
+ (void)showlottery:(NSString *)text icon:(NSString *)icon view:(UIView *)view;


+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  显示加载中的试图(是镭老板图片)
 *
 *  @param message 内容
 *  @param view    加载的试图
 *
 *  @return 返回一个View
 */
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

// 大菊花，有背景
+ (MBProgressHUD *)showActiveMessag:(NSString *)message toView:(UIView *)view;

// 加载中的indicator，没背景
+ (void)showIndicatorInview:(UIView *)view style:(UIActivityIndicatorViewStyle)style center:(CGPoint)center;
+ (void)removeIndicatorInview:(UIView *)view;

@end
