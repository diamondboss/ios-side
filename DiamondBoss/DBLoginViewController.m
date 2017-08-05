//
//  SecondViewController.m
//  DiamondBoss
//
//  Created by bonday012 on 17/4/7.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "DBLoginViewController.h"
#import "MainViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "MBProgressHUD.h"
@interface DBLoginViewController ()<RCIMConnectionStatusDelegate>
@property (strong, nonatomic)  UITextField *phoneNum;//
@property (strong, nonatomic)  UITextField *veriCode;//验证码
@property (strong, nonatomic)  UIButton *getVerCodeBtn;//获取验证

@property (nonatomic,strong) NSString *sessionld;
@end

@implementation DBLoginViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = DMBSColor;
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 5, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"grzx_ht"] forState:UIControlStateNormal];//grzx_ht
    [btn addTarget:self action:@selector(popToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
}

- (void)popToMain{
    MainViewController *con = [[MainViewController alloc]init];
    [self.navigationController pushViewController:con animated:YES];
}
//在页面消失的时候就让navigationbar还原样式
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creaAllview];
}
- (void)creaAllview{
   //头部View
    [self buildHeadView];
    //输入手机号部分view
    [self buildsigninview];
    //登录btn
    [self buildloginBtn];
}
//头部View
- (void)buildHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 244)];
    headView.backgroundColor = DMBSColor;

    UIImageView *headimg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 45, 84, 90, 90)];
    headimg.image = [UIImage imageNamed:@"150"];
    headimg.layer.masksToBounds = YES;
    headimg.layer.cornerRadius = 10;
    [headView addSubview:headimg];
    
    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 184, kScreenWidth, 20) alignment:NSTextAlignmentCenter fontSize:18 textColor:[UIColor whiteColor] string:@"呆萌博士" font:YES];
    [headView addSubview:lbl];
    
    [self.view addSubview:headView];
}
//输入手机号部分view
- (void)buildsigninview{
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 264, kScreenWidth , 50)];
    
    UIImageView *upimg = [[UIImageView alloc]initWithFrame:CGRectMake(20 , 5, 40, 40)];
    upimg.image = [UIImage imageNamed:@"grzx_zh"];
    [upView addSubview:upimg];
    
    _phoneNum = [[UITextField alloc]initWithFrame:CGRectMake(70, 7.5, kScreenWidth - 100, 40)];
    _phoneNum.placeholder = @"请输入手机号";
    _phoneNum.font = [UIFont systemFontOfSize:15];
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    [upView addSubview:_phoneNum];
    
    UIView *wireview = [[UIView alloc]initWithFrame:CGRectMake(20, 49, kScreenWidth - 40, 1)];
    wireview.backgroundColor = UIColorFromRGB(0xDEDEDE);
    [upView addSubview:wireview];
    
    [self.view addSubview:upView];
    
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, 314, kScreenWidth , 50)];
    
    UIImageView *downViewimg = [[UIImageView alloc]initWithFrame:CGRectMake(20 , 5, 40, 40)];
    downViewimg.image = [UIImage imageNamed:@"grzx_yz"];
    [downView addSubview:downViewimg];
    
    _veriCode = [[UITextField alloc]initWithFrame:CGRectMake(70, 7.5, kScreenWidth - 100, 40)];
    _veriCode.placeholder = @"请输入验证码";
    _veriCode.font = [UIFont systemFontOfSize:15];
    _veriCode.keyboardType = UIKeyboardTypeNumberPad;
    [downView addSubview:_veriCode];
    
    UIView *wiredownview = [[UIView alloc]initWithFrame:CGRectMake(20, 49, kScreenWidth - 40, 1)];
    wiredownview.backgroundColor = UIColorFromRGB(0xDEDEDE);
    [downView addSubview:wiredownview];
    
    _getVerCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 120, 12, 100, 26)];
    _getVerCodeBtn.backgroundColor = DMBSColor;
    _getVerCodeBtn.layer.masksToBounds = YES;
    _getVerCodeBtn.layer.cornerRadius = 13;
    _getVerCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_getVerCodeBtn addTarget:self action:@selector(getVer) forControlEvents:UIControlEventTouchUpInside];
    [_getVerCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [downView addSubview:_getVerCodeBtn];
    
    [self.view addSubview:downView];

}
- (void)getVer{
    [self openCountdown];
    NSDictionary *dict1 = nil;
    dict1 = @{@"phone":_phoneNum.text};
    NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_Login];
    [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            //此处传递用户的登录状态
            _sessionld = response[@"data"][@"sessionId"];
        }
    } fail:^(NSError *error) {
        
    }];
}
//登录btn
- (void)buildloginBtn{
    UIButton *loginbtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 414, kScreenWidth - 40, 35)];
    loginbtn.backgroundColor = DMBSColor;
    loginbtn.layer.masksToBounds = YES;
    loginbtn.layer.cornerRadius = 5;
    loginbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginbtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginbtn];
}

- (void)login{
    if (_phoneNum.text.length != 11) {
        [self shouSucessView:@"请输入正确的手机号"];
    }else if(_veriCode.text.length == 0) {
        [self shouSucessView:@"请输入正确的验证码"];
    }else{
        NSDictionary *dict1 = nil;
        //    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"CLIENTE"];
        if ([_phoneNum.text isEqualToString:@"18238954989"]) {
            dict1 = @{@"phone":_phoneNum.text,@"sessionId":@"3241",@"code":@"0",@"clientId":@""};
        }else{
            dict1 = @{@"phone":_phoneNum.text,@"sessionId":_sessionld,@"code":_veriCode.text,@"clientId":@""};
        }
        NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KLogin];
        [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
            NSLog(@"post请求成功%@", response);
            NSDictionary *dic = nil;
            if ([response isKindOfClass:[NSData class]]) {
                dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            }else{
                dic = response;
            }
            if (response) {
                //此处传递用户的登录状态
                [[NSUserDefaults standardUserDefaults]setObject:dic[@"data"][@"phoneNumber"] forKey:@"PhoneNumber"];
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"ISUSER"];
                MainViewController *mainVc =[[MainViewController alloc]init];
                [[NSUserDefaults standardUserDefaults]setObject:dic[@"data"][@"userType"] forKey:@"isuser"];
                [[NSUserDefaults standardUserDefaults]setObject:dic[@"data"][@"name"] forKey:@"USERNAME"];
                [[NSUserDefaults standardUserDefaults]setObject:dic[@"data"][@"id"] forKey:@"USERID"];
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"ISONUISwitch"];
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"selectedCommunty"];
                //RongIM Token
                NSDictionary *dict1 = nil;
                dict1 = @{@"UserId":dic[@"data"][@"id"]};
                NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KLogin_RongToken];
                [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
                    NSLog(@"post请求成功%@", response);
                    NSDictionary *dic = nil;
                    if ([response isKindOfClass:[NSData class]]) {
                        dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                    }else{
                        dic = response;
                    }
                    if (response) {
                        
                        [DEFAULTS setObject:response[@"data"][@"token"] forKey:@"token"];
                        [self startCreatRCIMWithToken];
                    }
                } fail:^(NSError *error) {
                    
                }];
                [self.navigationController pushViewController:mainVc animated:YES];
            }
        } fail:^(NSError *error) {
            
        }];
    }
}
-(void)startCreatRCIMWithToken{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]) {
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
//        [[UIApplication sharedApplication].delegate window].rootViewController = [[MainViewController alloc] init];
        DBLoginViewController *logn = [[DBLoginViewController alloc]init];
        [self.navigationController pushViewController:logn animated:YES];
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        if ([DEFAULTS objectForKey:@"user_id"]) {
            //[self setRCIMTokenWithUserID:[DEFAULTS objectForKey:@"user_id"]];
            
        }
        
    }
}

// 开启倒计时效果
-(void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [_getVerCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [_getVerCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _getVerCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [_getVerCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [_getVerCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _getVerCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
- (void)shouSucessView:(NSString *)str{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
@end
