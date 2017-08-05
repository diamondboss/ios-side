//
//  OnlinepayViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/6/24.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "OnlinepayViewController.h"
#import "AppointmentViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WechatPayManager.h" //微信支付类
#import "WXApi.h"
#import "LZMobilePayManager.h"
#import "NSObject+GetIP.h"
#import "MainViewController.h"
#import "MyOrderViewController.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface OnlinepayViewController ()
{
    int secondsCountDown; //倒计时总时长
    NSTimer *countDownTimer;
    int firstCountDown;
    BOOL isAliSDk;
}
@property (nonatomic,copy) NSString *urlString1;
@property (nonatomic,copy) NSString *outTradeNo;//验证微信
@property (nonatomic,copy) NSString *loginPhone;


@end

@implementation OnlinepayViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = DMBSColor;
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 5, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"grzx_ht"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
}
- (void)popTo{
    AppointmentViewController * buttonsView = [[AppointmentViewController alloc]init];
    [self.navigationController pushViewController:buttonsView animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"在线支付";
    isAliSDk = YES;
    self.entureOnlineBtn.layer.masksToBounds = YES;
    self.entureOnlineBtn.layer.cornerRadius = 5;
    
    _loginPhone = [[NSUserDefaults standardUserDefaults]objectForKey:@"PhoneNumber"];
    _priceLbl.text = [NSString stringWithFormat:@"%@",_Orderpricce];
    
    
    //设置倒计时总时长
    firstCountDown = 10;
    //设置倒计时总时长
    secondsCountDown = 0;//60秒倒计时
    //开始倒计时
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    
    //设置倒计时显示的时间
    _TimeLbl.text=[NSString stringWithFormat:@"%02d:%02d",firstCountDown,secondsCountDown];
}
//点击支付宝
- (IBAction)ZhifubaoBtn:(id)sender {
    isAliSDk = YES;
    [self.chooseZhifubaoBtn setImage:[UIImage imageNamed:@"dinddan_lvse"] forState:UIControlStateNormal];
    [self.wechatBtn setImage:[UIImage imageNamed:@"dindan_cuohao"] forState:UIControlStateNormal];
    [self.view reloadInputViews];
}
//点击微信
- (IBAction)WeixinBtn:(id)sender {
    isAliSDk = NO;
    [self.chooseZhifubaoBtn setImage:[UIImage imageNamed:@"dindan_cuohao"] forState:UIControlStateNormal];
    [self.wechatBtn setImage:[UIImage imageNamed:@"dinddan_lvse"] forState:UIControlStateNormal];
    [self.view reloadInputViews];
}
//确定支付Btn
- (IBAction)EntureBtn:(id)sender {
    if (isAliSDk) {
        [self AlisdkPay];
    }else{
        [self WXPay];
    }
}

#pragma mark 支付宝支付
- (void)AlisdkPay{
    //支付宝
    NSDictionary *dict1 = nil;
    if (_IsAppoint) {
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
        NSString *nameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"];
        [_MuTabdic setObject:_loginPhone forKey:@"phone"];
        [_MuTabdic setObject:[NSString stringWithFormat:@"%@",nameStr] forKey:@"userName"];
        [_MuTabdic setObject:[NSString stringWithFormat:@"%@",str] forKey:@"userId"];
        [_MuTabdic setObject:[NSString stringWithFormat:@"%@",_PanterId] forKey:@"partnerId"];
        [_MuTabdic setObject:_PanterName forKey:@"partnerName"];
        
        dict1 = _MuTabdic;
        
        _urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_Appoint];
    }else{
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
        NSString *nameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"];
        [_MuTabdic setObject:_loginPhone forKey:@"phone"];
        [_MuTabdic setObject:[NSString stringWithFormat:@"%@",nameStr] forKey:@"userName"];
        [_MuTabdic setObject:[NSString stringWithFormat:@"%@",str] forKey:@"userId"];
        dict1 = _MuTabdic;
        
        _urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_Random];
    }
    [HYBNetworking postWithUrl:_urlString1 refreshCache:YES params:dict1 success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            if ([response[@"retnCode"] intValue] == 0){
                //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
                NSString *appScheme = @"alisdkgoldeneye.item";
                // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = response[@"data"][@"alipaySign"];
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"payOrder =reslut = %@",resultDic);
                    if (resultDic) {
                        // 9000 订单支付成功
                        // 8000 正在处理中
                        // 4000 订单支付失败
                        // 6001 用户中途取消
                        // 6002 网络连接出错
                        NSInteger orderState = [resultDic[@"resultStatus"] integerValue];
                        if (orderState == 9000) {
                            NSDictionary *dict1 = nil;
                            dict1 = @{@"resultStatus":[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]],@"result":[NSString stringWithFormat:@"%@",resultDic[@"result"]],@"memo":[NSString stringWithFormat:@"%@",resultDic[@"memo"]]};
                            NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_CheckAliPayResult];
                            [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
                                NSLog(@"post请求成功%@", response);
                                NSDictionary *dic = nil;
                                if ([response isKindOfClass:[NSData class]]) {
                                    dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                                }else{
                                    dic = response;
                                }
                                if (response) {
                                    [self showOnlineSuccessAlertView:@"支付宝支付成功"];
                                }
                            } fail:^(NSError *error) {
                                
                            }];
                        }else if (orderState ==  6001)
                        {
                            [self showOnlinefalseAlertView:@"取消支付宝支付"];
                        }else{
                            [self showOnlinefalseAlertView:@"支付宝支付失败"];
                        }
                    }
                    NSLog(@"payOrder =reslut = %@",resultDic);
                }];
            }
            if ([response[@"retnCode"] intValue] == 1) {
                [self showOnlinefalseAlertView:response[@"retnDesc"]];
            }
        }
    } fail:^(NSError *error) {
        [self showOnlinefalseAlertView:@"支付宝支付失败"];
    }];
}
#pragma mark 微信支付
- (void)WXPay{
    NSString *StringIP = [NSString deviceIPAdress]; //调用方法 获取ip地址 赋值给字符串 stringIP
    NSLog(@"%@",StringIP);
    NSDictionary *dict1 = nil;
    if (_IsAppoint) {
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
        NSString *nameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"];
        [_MuTabdic setObject:_loginPhone forKey:@"phone"];
        [_MuTabdic setObject:[NSString stringWithFormat:@"%@",nameStr] forKey:@"userName"];
        [_MuTabdic setObject:[NSString stringWithFormat:@"%@",str] forKey:@"userId"];
        [_MuTabdic setObject:[NSString stringWithFormat:@"%@",_PanterId] forKey:@"partnerId"];
        [_MuTabdic setObject:_PanterName forKey:@"partnerName"];
        [_MuTabdic setObject:StringIP forKey:@"userIp"];
        dict1 = _MuTabdic;
        //用户下单微信-指定合伙人
        _urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_AppointWXPay];
    }else{
//        NSDate * date = [NSDate date];//当前时间
//        NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
//        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
//        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
//        NSString *strDate1 = [dateFormatter1 stringFromDate:nextDay];
//        NSLog(@"%@", strDate1);
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
        NSString *nameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"];
//        [_MuTabdic setObject:[NSString stringWithFormat:@"%@ 09:00",strDate1] forKey:@"receiveTime"];
//        [_MuTabdic setObject:[NSString stringWithFormat:@"%@ 18:00",strDate1] forKey:@"returnTime"];
        [_MuTabdic setObject:_loginPhone forKey:@"phone"];
        [_MuTabdic setObject:[NSString stringWithFormat:@"%@",nameStr] forKey:@"userName"];
        [_MuTabdic setObject:[NSString stringWithFormat:@"%@",str] forKey:@"userId"];
//        [_MuTabdic setObject:[NSString stringWithFormat:@"%@",strDate1] forKey:@"orderDate"];
        [_MuTabdic setObject:StringIP forKey:@"userIp"];
        dict1 = _MuTabdic;
        //用户下单微信-不指定合伙人
        _urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_RandomWXPay];
    }
    [HYBNetworking postWithUrl:_urlString1 refreshCache:YES params:dict1 success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            if ([response[@"retnCode"] intValue] == 0) {
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = response[@"data"][@"appid"];//微信开放平台审核通过的应用APPID
                req.partnerId           = response[@"data"][@"partnerid"];//微信支付分配的商户号
                req.prepayId            = response[@"data"][@"prepayid"];//微信返回的支付交易会话ID
                req.nonceStr            = response[@"data"][@"nonceStr"];//随机字符串，不长于32位。推荐
                req.timeStamp           = [response[@"data"][@"timeStamp"] intValue];//时间戳
                req.package             = response[@"data"][@"package"];
                req.sign                = response[@"data"][@"sign"];// 签名
                _outTradeNo             = response[@"data"][@"outTradeNo"];
                [WXApi sendReq:req];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPayHandle:) name:@"WechatPayNotification" object:nil];
            }
            if ([response[@"retnCode"] intValue] == 1) {
                [self showOnlinefalseAlertView:response[@"retnDesc"]];
            }
        }
    } fail:^(NSError *error) {
         [self showOnlinefalseAlertView:@"微信支付失败"];
    }];
}
//微信支付通知
- (void)wechatPayHandle:(NSNotification *)notification
{
    if ([notification.object isEqualToString:@"WXErrCodeUserCancel"]) {
       [self showOnlinefalseAlertView:@"取消微信支付"];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }else if ([notification.object isEqualToString:@"WXSuccess"])
    {
        //微信成功失败
        NSDictionary *dict1 = nil;
        dict1 = @{@"outTradeNo":_outTradeNo};
        NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_CheckWXPayResult];
        [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
            NSLog(@"post请求成功%@", response);
            NSDictionary *dic = nil;
            if ([response isKindOfClass:[NSData class]]) {
                dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            }else{
                dic = response;
            }
            if (response) {
                if ([response[@"retnCode"] intValue] == 0) {
                     [self showOnlineSuccessAlertView:response[@"retnDesc"]];
                    [[NSNotificationCenter defaultCenter]removeObserver:self];
                }else{
                    [self showOnlinefalseAlertView:response[@"retnDesc"]];
                }
            }
        } fail:^(NSError *error) {
            [self showOnlinefalseAlertView:@"微信支付失败"];
        }];
       
    }else{
        [self showOnlinefalseAlertView:@"微信支付失败"];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"WechatPayNotification"];
}

-(void)timeFireMethod{
    //倒计时
    if (firstCountDown == 0 && secondsCountDown == 0) {
        _TimeLbl.text=[NSString stringWithFormat:@"%@",@"支付超时"];
         [countDownTimer invalidate];
    }else{
        if (secondsCountDown == 00 ) {
            firstCountDown--;
            secondsCountDown = 59;
        }
        //修改倒计时标签现实内容
        _TimeLbl.text=[NSString stringWithFormat:@"%02d:%02d",firstCountDown,secondsCountDown];
        secondsCountDown--;
    }
}
- (void)showOnlineSuccessAlertView:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MyOrderViewController * buttonsView = [[MyOrderViewController alloc]init];
        [self.navigationController pushViewController:buttonsView animated:NO];
        
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
- (void)showOnlinefalseAlertView:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MainViewController * buttonsView = [[MainViewController alloc]init];
        [self.navigationController pushViewController:buttonsView animated:NO];
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}


/**
 *  生成随机字符串
 *
 *  @param kNumber 订单号的长度
 */
//- (NSString *)generateRomNumWithNumber: (NSInteger)kNumber
//{
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand((unsigned int)time(0));
//    for (NSInteger i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}

@end
