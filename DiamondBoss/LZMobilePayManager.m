

//
//  LZMobilePayManager.m
//  GoldeneyeFrame
//
//  Created by goldeneye on 2017/6/6.
//  Copyright © 2017年 ZZgoldeneye. All rights reserved.
//

#import "LZMobilePayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "RSADataSigner.h"
#import <CommonCrypto/CommonCryptor.h>
#import "CommonCrypto/CommonDigest.h"
#import "WechatPayManager.h" //微信支付类

/*************** 微信支付 ********************/
static NSString * const  kWEIXINID  = @"wx983d46ae08f1c58d";
static NSString * const  kWEIXINKEY = @"6474ec51f5d926fa7d53ecba4a556693";
/**
 * 支付成功回调地址
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
static NSString * const kWEIXINNOTIFYURL = @"http://139.196.12.103/{client_type}/{version}/customer/payAmount";
/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
static NSString * const  KWXPartnerKey = @"zfxue430bwguan0109zhenzhenli0316";
/**
 *  微信公众平台商户模块生成的ID
 */
static NSString * const  kWEIXINPartnerId = @"1482739832";

@implementation LZMobilePayManager

//单利
+ (LZMobilePayManager *)shareInstance{
    
    static LZMobilePayManager * tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool  = [[LZMobilePayManager alloc]init];
    });
    return tool;
}

/*
 * 微信支付
 * orderTitle 订单title
 * orderId    订单编号
 * orderPrice 订单价格
 *
 */
- (void)wechatPayOrderTitle:(NSString *)orderTitle orderNumber:(NSString *)orderNumber orderPrice:(NSString *)orderPrice compltedHandle:(void (^)(PayCompltedHandle handel))compltedHandle{
    
    
    [LZMobilePayManager shareInstance].PayCompltedHandleBlock = compltedHandle;
    //微信
    WechatPayManager * wxpayManager  = [[WechatPayManager alloc]initWithAppID:kWEIXINID mchID:kWEIXINPartnerId spKey:KWXPartnerKey notifyUrl:kWEIXINNOTIFYURL];
    //错误提示
    //NSString *debug = [wxpayManager getDebugInfo];
    //[NSString stringWithFormat:@"%.0lf",_price*100]
    NSMutableDictionary  * params = [wxpayManager getPrepayWithOrderName:orderTitle price:orderPrice orderNo:orderNumber];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [params objectForKey:@"appid"];  //微信开放平台审核通过的应用APPID
    req.partnerId          = [params objectForKey:@"partnerid"]; //微信支付分配的商户号
    req.prepayId            = [params objectForKey:@"prepayid"]; //微信返回的支付交易会话ID
    req.nonceStr            = [params objectForKey:@"noncestr"]; //随机字符串，不长于32位。推荐
    req.timeStamp          =  [[params objectForKey:@"timestamp"] intValue];//时间戳
    req.package            =   @"Sign=WXPay"; //[dataDict objectForKey:@"package"];// Sign=WXPay
    req.sign                = [params objectForKey:@"sign"]; // 签名
    [WXApi sendReq:req];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wechatPayHandle:) name:@"WechatPayNotification" object:nil];
    
}
//微信支付通知
- (void)wechatPayHandle:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"WXErrCodeUserCancel"]) {
        
        if ([LZMobilePayManager shareInstance].PayCompltedHandleBlock ){
            [LZMobilePayManager shareInstance].PayCompltedHandleBlock(PayCancleHandle);
            
        }
        [[NSNotificationCenter defaultCenter]removeObserver:self];

    }else if ([notification.object isEqualToString:@"WXSuccess"])
    {
        if ([[LZMobilePayManager alloc]init].PayCompltedHandleBlock) {
            [[LZMobilePayManager alloc]init].PayCompltedHandleBlock(PaySuccessHandle);
        }
        [[NSNotificationCenter defaultCenter]removeObserver:self];

    }else{
        if ([[LZMobilePayManager alloc]init].PayCompltedHandleBlock) {
            [[LZMobilePayManager alloc]init].PayCompltedHandleBlock(PayFailedHandle);
        }
        [[NSNotificationCenter defaultCenter]removeObserver:self];

    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)showErrorMessage:(NSString *)message{
    
    UIAlertView  * alert  = [[UIAlertView alloc]initWithTitle:@"错误提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
}

@end
