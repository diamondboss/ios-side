//
//  AppDelegate.m
//  DiamondBoss
//
//  Created by bonday012 on 17/4/7.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "IQKeyboardManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "REFrostedViewController.h"
#import "LeftCenterViewController.h"
#import "GFHomeNavViewController.h"

#import <RongIMKit/RongIMKit.h>
#import <AlipaySDK/AlipaySDK.h>

#import "WXApiManager.h"


//#import "GeTuiSdk.h"     // GetuiSdk头文件应用
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
//#define kGtAppId           @"wDV62wDmLT6zpGoL5gsHC"
//#define kGtAppKey          @"Z1eOXz6SSNAoSXNV7h4UP8"
//#define kGtAppSecret       @"KMkPskpVjy6yakzPqvg057"
@interface AppDelegate ()<REFrostedViewControllerDelegate,RCIMConnectionStatusDelegate, UNUserNotificationCenterDelegate>
//GeTuiSdkDelegate
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"ISUSER"];
    //闪屏页面1s
    [NSThread sleepForTimeInterval:1];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    MainViewController *Home = [[MainViewController alloc] init];
    
    GFHomeNavViewController *globalNav = [[GFHomeNavViewController alloc]initWithRootViewController:Home];
    LeftCenterViewController *leftHome = [[LeftCenterViewController alloc]init];
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:globalNav menuViewController:leftHome];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    self.window.rootViewController = frostedViewController;
    [self.window makeKeyAndVisible];

    
    //高德地图
//    [AMapServices sharedServices].apiKey = @"8c1e6b6219874f14b5ae722eef8ff834";
    // 键盘
    [self setKeyBoard];
    //网络请求：HYBNetworking
    [self HYBNetworking];
 //融云
    [self startCreatRCIMWithToken];
    
    //向微信注册
    [WXApi registerApp:@"wx983d46ae08f1c58d"];

    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
//    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
//    //[1-2]:设置是否后台运行开关
//    [GeTuiSdk runBackgroundEnable:YES];
//    // 注册 APNs
//    [self registerRemoteNotification];
    return YES;
}

-(void)startCreatRCIMWithToken{
    
    [[RCIM sharedRCIM] initWithAppKey:@"bmdehs6pbihks"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]);
    if ([DEFAULTS objectForKey:@"token"]) {
        [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
        [[RCIM sharedRCIM] connectWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]     success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];
    }
    
}
/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:
                              @"您的帐号在其它设备上登录，"
                              @"如需继续使用，请重新登录！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        [DEFAULTS removeObjectForKey:@"token"];
        [[UIApplication sharedApplication].delegate window].rootViewController = [[MainViewController alloc] init];
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        if ([DEFAULTS objectForKey:@"user_id"]) {
            //[self setRCIMTokenWithUserID:[DEFAULTS objectForKey:@"user_id"]];
            
        }
        
    }
}


- (void)HYBNetworking{
    [HYBNetworking updateBaseUrl:@"http://apistore.baidu.com"];
    [HYBNetworking enableInterfaceDebug:YES];
    // 配置请求和响应类型，由于部分伙伴们的服务器不接收JSON传过去，现在默认值改成了plainText
    [HYBNetworking configRequestType:kHYBRequestTypePlainText
                        responseType:kHYBResponseTypeJSON
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];
    // 设置GET、POST请求都缓存
    [HYBNetworking cacheGetRequest:YES shoulCachePost:YES];
}
#pragma mark 设置
- (void)setKeyBoard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/************* 支付集成  **************/
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (resultDic) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"AlipayNotification" object:self  userInfo:resultDic];
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"defaultService result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else if([url.host isEqualToString:@"pay"]){
        
        
        return [WXApi handleOpenURL:url delegate:[WXApiManager shareInstance]];
    }else{
        
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if (resultDic) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"AlipayNotification" object:self  userInfo:resultDic];
            }
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"defaultService==result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    } else if ([url.host isEqualToString:@"pay"])
    {
        
        return  [WXApi handleOpenURL:url delegate:[WXApiManager shareInstance]];
    }else
    {
        
        
    }
    
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    
    return  [WXApi handleOpenURL:url delegate:[WXApiManager shareInstance]];
}

//#pragma mark-  个推
///** 注册 APNs */
//- (void)registerRemoteNotification {
//    /*
//     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
//     */
//    
//    /*
//     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
//     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
//     */
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = self;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
//            if (!error) {
//                NSLog(@"request authorization succeeded!");
//            }
//        }];
//        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//#else // Xcode 7编译会调用
//        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//#endif
//    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else {
//        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
//                                                                       UIRemoteNotificationTypeSound |
//                                                                       UIRemoteNotificationTypeBadge);
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
//    }
//}
///** 远程通知注册成功委托 */
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
//    
//    // 向个推服务器注册deviceToken
//    [GeTuiSdk registerDeviceToken:token];
//}
///** SDK启动成功返回cid */
//- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
//    // [4-EXT-1]: 个推SDK已注册，返回clientId
//    NSLog(@"\n>>[GTSdk RegisterClient]:%@\n\n", clientId);
//    [[NSUserDefaults standardUserDefaults]setObject:clientId forKey:@"CLIENTE"];
//}
//
///** SDK遇到错误回调 */
//- (void)GeTuiSdkDidOccurError:(NSError *)error {
//    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
//    NSLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
//}
//
///** SDK收到透传消息回调 */
//- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
//    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
//    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
//    
//    // 数据转换
//    NSString *payloadMsg = nil;
//    if (payloadData) {
//        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
//    }
//    // 控制台打印日志
//    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
//    NSLog(@"\n>>[GTSdk ReceivePayload]:%@\n\n", msg);
//    
//    
//    
//}
@end
