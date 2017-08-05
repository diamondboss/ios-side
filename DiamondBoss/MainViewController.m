//
//  FirstViewController.m
//  DiamondBoss
//  Created by bonday012 on 17/4/7.
//  Copyright © 2017年 bonday012. All rights reserved.


#import "MainViewController.h"
#import "REFrostedViewController.h"
#import "MainTableViewCell2.h"

#import "GrabViewController.h"
#import "GlobalNavigationController.h"
#import "RongchatViewController.h"
#import "HistorymesageViewController.h"

#import "CommnuityViewControler.h"

#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAMapView.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "UserKnowViewController.h"

#import "pantermessageView.h"
#import "UserorderView.h"

#import <RongIMKit/RongIMKit.h>
#import "DBLoginViewController.h"

#import "AppointmentViewController.h"
#import "MyOrderViewController.h"
//0 用户   1 合伙人   2 没登录  接口
//0 合伙人   1 用户   2 没登录
//#define ISPANTER 2

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate,MAMultiPointOverlayRendererDelegate>
{
    NSInteger ISPANTER;
    NSDictionary *dataDic2;//合伙人首页数据
    NSArray *panterAry;//合伙人首页
    NSArray *UserOrderAry;//用户单子数组
    
    pantermessageView *panterView;
    UIButton *panterbutton;
    
    UserorderView *OrderView;//用户单子
    
    UIImageView *NoOrderImg;
    UILabel *NoOrderLbl;
    NSString *orderuseid;
    NSString *orderid;
    
//    NSArray *locationID;
    NSMutableArray *locationID;
//    NSArray *locArr;
    NSMutableArray *locArr;

}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UISwitch *mySwitch;
@property (nonatomic,strong) UILabel *rightlbl;


@property (nonatomic, strong) UIImageView          *centerAnnotationView;
@property (nonatomic, assign) BOOL                  isMapViewRegionChangedFromTableView;

@property (nonatomic, assign) BOOL                  isLocated;

@property (nonatomic, strong) UIButton             *locationBtn;
@property (nonatomic, strong) UIImage              *imageLocated;
@property (nonatomic, strong) UIImage              *imageNotLocate;

@property (nonatomic, assign) NSInteger             searchPage;

@property (nonatomic, strong) UISegmentedControl    *searchTypeSegment;
@property (nonatomic, copy) NSString               *currentType;
@property (nonatomic, copy) NSArray                *searchTypes;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = DMBSColor;
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    NSString *str = [[NSUserDefaults standardUserDefaults ]objectForKey:@"ISUSER"];
    NSString *teleStr = [[NSUserDefaults standardUserDefaults ]objectForKey:@"PhoneNumber"];
    if ([str isEqualToString:@""]) {
        if ([teleStr isEqualToString:@""]) {
            ISPANTER = 2;
        }else{
            NSString *str1 = [[NSUserDefaults standardUserDefaults ]objectForKey:@"isuser"];
            if ([str1 isEqualToString:@"1"]) {
                ISPANTER = 0;
            }else if([str1 isEqualToString:@"0"]) {
                ISPANTER = 1;
            }else{
                ISPANTER = 2;
            }
        }
    }else{
        NSString *str1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"isuser"];
        if ([str1 isEqualToString:@"1"]) {
            ISPANTER = 0;
        }else if([str1 isEqualToString:@"0"]) {
            ISPANTER = 1;
        }else{
            ISPANTER = 2;
        }
    }
    
    if (ISPANTER == 0) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"userOrpanter"];
        [self loadData];
    }
    if (ISPANTER == 1) {
        //请开启定位服务
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status)
        {
            //            //读取本地数据
            NSString * isPositioning = [[NSUserDefaults standardUserDefaults] valueForKey:@"isPositioning"];
            if (isPositioning == nil)//提示
            {
                UIAlertView * positioningAlertivew = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"为了更好的体验,请到设置->隐私->定位服务中开启【呆萌博士】定位服务!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                positioningAlertivew.tag = 30;
                [positioningAlertivew show];
            }
        }
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"userOrpanter"];
        [self buildUI];
    }else if (ISPANTER == 2) {
        [self buildUI];
    }
    [self buildBarButtonItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"呆萌博士";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)buildUI{
    if (ISPANTER == 0) {
        [self builbtn];
        [self createTableView];
    }else{
        if (ISPANTER == 1) {
            //用户首页
            [self buildUserUI];
        }else{
            //未登录首页
            [self buildNotLogonUI];
        }
    }
}

- (void)createTableView{
    //半透明条(导航条/tabBar) 对滚动视图的影响
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 50)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator =NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //如果 autolayout 自动计算cell 高需要设置预设高
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell2" bundle:nil] forCellReuseIdentifier:@"MainTableViewCell2"];
    [self.view addSubview:self.tableView];
    if (panterAry.count == 0) {
        NoOrderImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 20, (kScreenHeight-64)/2  , 40, 60)];
        NoOrderImg.image = [UIImage imageNamed:@"grabimg"];
        [self.tableView addSubview:NoOrderImg];
        
        NoOrderLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, (kScreenHeight-64)/2 + 60, kScreenWidth, 20)];
        NoOrderLbl.text = @"暂无订单信息";
        NoOrderLbl.textAlignment = NSTextAlignmentCenter;
        NoOrderLbl.font = [UIFont systemFontOfSize:13];
        NoOrderLbl.textColor = UIColorFromRGB(0x979797);
        [self.tableView addSubview:NoOrderLbl];
    }
}
#pragma mark - tableView的协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 203;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return panterAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    UIButton *brn = [[UIButton alloc]init];
    brn.frame = CGRectMake(0, 0, kScreenWidth , 118);
    [brn setBackgroundImage:[UIImage imageNamed:@"Image"] forState:UIControlStateNormal];
    [brn addTarget:self action:@selector(Grab) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:brn];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(13, 123, 80, 30)];
    lbl.text = @"账号余额:";
    lbl.font = [UIFont systemFontOfSize:14];
    [view addSubview:lbl];
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(93, 123, 80, 30)];
    if (nil == dataDic2) {
        lb.text = @"0元";
    }else{
        lb.text = [NSString stringWithFormat:@"%@元",dataDic2[@"availableBalance"]];
    }
    lb.textColor = DMBSColor;
    lb.font = [UIFont systemFontOfSize:14];
    [view addSubview:lb];
    
    //    _rightlbl = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 123, 50, 30)];
    //    _rightlbl.font = [UIFont systemFontOfSize:12];
    //    _rightlbl.textColor = [UIColor orangeColor];
    //    _rightlbl.textAlignment = NSTextAlignmentRight;
    //    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"ISONUISwitch"];
    //    if ([str isEqualToString:@"1"]) {
    //        _rightlbl.text = @"开启接单";
    //    }else{
    //        _rightlbl.text = @"关闭接单";
    //    }
    //    [view addSubview:_rightlbl];
    //
    //    _mySwitch = [[UISwitch alloc]init];
    //    //宽度和高度值无法改变(80,40)写了也没有用的，不会起到作用的。默认的。
    //    _mySwitch.frame=CGRectMake(kScreenWidth - 50, 123, 30, 20);
    //    _mySwitch.onTintColor = [UIColor colorWithRed:0.984 green:0.478 blue:0.224 alpha:1.000];
    //    // 控件大小，不能设置frame，只能用缩放比例
    //    _mySwitch.transform = CGAffineTransformMakeScale(0.6, 0.6);
    //    //YES:开启状态
    //    //NO:关闭状态
    //
    //    [self.view addSubview:_mySwitch];
    //    //设置开启状态的风格颜色
    //    [_mySwitch setOnTintColor:[UIColor darkGrayColor]];
    //    //设置开关圆按钮的风格颜色
    //    [_mySwitch setThumbTintColor:DMBSColor];
    //
    //    //设置整体风格颜色,按钮的白色是整个父布局的背景颜色
    //    //        [_mySwitch setTintColor:[UIColor greenColor]];
    //    [_mySwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
    //    [view addSubview:_mySwitch];
    
    UIView *xianview = [[UIView alloc]initWithFrame:CGRectMake(10, 155, kScreenWidth - 20, 1)];
    xianview.backgroundColor = UIColorRGB(237, 237, 237);
    [view addSubview:xianview];
    
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(13, 158, 80, 30)];
    lbl1.text = @"今日收益:";
    lbl1.font = [UIFont systemFontOfSize:14];
    [view addSubview:lbl1];
    
    UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(93, 158, 80, 30)];
    if (nil == dataDic2) {
        lb1.text = @"0元";
    }else{
        lb1.text = [NSString stringWithFormat:@"%@元",dataDic2[@"earningsToday"]];
    }
    lb1.textColor = DMBSColor;
    lb1.font = [UIFont systemFontOfSize:14];
    [view addSubview:lb1];
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 193, kScreenWidth, 10)];
    bgview.backgroundColor = UIColorFromRGB(0Xf2f2f2);
    [view addSubview:bgview];
    self.tableView.tableHeaderView=view;
    return view;
}
//参数传入开关对象本身
//- (void) swChange:(UISwitch*) sw{
//    if(sw.on==YES){
//        NSLog(@"开关被打开");
//        _rightlbl.text = @"开启接单";
//        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"ISONUISwitch"];
//        [_rightlbl reloadInputViews];
//    }else{
//        NSLog(@"开关被关闭");
//        _rightlbl.text = @"关闭接单";
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"ISONUISwitch"];
//        [_rightlbl reloadInputViews];
//    }
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //0 合伙人   1 用户   2 没登录  3 预约成功
    MainTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell2" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    //phone
    cell.callphoneBtn.tag = [panterAry[indexPath.row][@"phone"] integerValue];
    [cell.callphoneBtn addTarget:self action:@selector(callPhoneUser:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.enterReturnBtn.tag = indexPath.row;
    [cell.enterReturnBtn addTarget:self action:@selector(enterbtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.enterReturnBtn addTarget:self action:@selector(enterbtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell showUserMessageDataWithModel:panterAry[indexPath.row] indexPath:indexPath];
    return cell;
}
- (void)enterbtn:(UIButton *)btn{
    
    //4是未接宠
    if ([panterAry[btn.tag][@"orderStatus"] integerValue] == 4) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定接到" preferredStyle:UIAlertControllerStyleActionSheet];
        // 设置popover指向的item
        alert.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
        // 添加按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSLog(@"点击了确定按钮");
            
            NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
            NSDictionary *dict1 = nil;
            
            dict1 = @{@"partnerId":str,@"outTradeNo":panterAry[btn.tag][@"outTradeNo"],@"userId":panterAry[btn.tag][@"userId"]};
            NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_Receive];
            [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
                NSLog(@"post请求成功%@", response);
                NSDictionary *dic = nil;
                if ([response isKindOfClass:[NSData class]]) {
                    dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                }else{
                    dic = response;
                }
                if (response) {
                    [self loadData];
                }
                
            } fail:^(NSError *error) {
                
            }];

        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"点击了取消按钮");
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
       
    }
    
    //5是已接到
    if ([panterAry[btn.tag][@"orderStatus"] integerValue]  == 5) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定送还" preferredStyle:UIAlertControllerStyleActionSheet];
        // 设置popover指向的item
        alert.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
        // 添加按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSLog(@"点击了确定按钮");
            
            NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
            NSDictionary *dict1 = nil;
            
            dict1 = @{@"partnerId":str,@"outTradeNo":panterAry[btn.tag][@"outTradeNo"],@"userId":panterAry[btn.tag][@"userId"]};
            NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_GiveBack];
            [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
                NSLog(@"post请求成功%@", response);
                NSDictionary *dic = nil;
                if ([response isKindOfClass:[NSData class]]) {
                    dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                }else{
                    dic = response;
                }
                if (response) {
                    [self loadData];
                }
                
            } fail:^(NSError *error) {
                
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"点击了取消按钮");
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
#pragma mark 导航栏
-(void)buildBarButtonItem{
    self.title = @"呆萌博士";
    self.navigationController.navigationBar.barTintColor = DMBSColor;
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    UIButton *personalCenter = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    [personalCenter setImage:[UIImage imageNamed:@"sy_grzx1"] forState:UIControlStateNormal];
    if (ISPANTER == 0 || ISPANTER == 1) {
        [personalCenter addTarget:self action:@selector(pushPerCenter) forControlEvents:UIControlEventTouchDown];
    }else{
        [personalCenter addTarget:self action:@selector(logonbtn) forControlEvents:UIControlEventTouchDown];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:personalCenter];
    //右上角消息中心，暂时没有用到
    //    UIButton *rightItemButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    //    [rightItemButton setImage:[UIImage imageNamed:@"sy_grzx-2"] forState:UIControlStateNormal];
    //    rightItemButton.titleLabel.textAlignment = NSTextAlignmentRight;
    //    if (ISPANTER == 0 || ISPANTER == 1) {
    //        [rightItemButton addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchDown];
    //    }else{
    //        [rightItemButton addTarget:self action:@selector(logonbtn) forControlEvents:UIControlEventTouchDown];
    //    }
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightItemButton];
}
//左抽屉动画
-(void)pushPerCenter {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
#pragma mark 合伙人首页网络请求
- (void)loadData{
    //合伙人首页
    NSDictionary *dict1 = nil;
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    dict1 = @{@"partnerId":str};
    NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_PanterMessage];
    [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            
            panterAry = [NSArray array];
            panterAry = response[@"data"];
            
            [self buildUI];
            
            NSDictionary *dict1 = nil;
            dict1 = @{@"partnerId":str};
            NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_PartnerWallet];
            [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
                NSLog(@"post请求成功%@", response);
                NSDictionary *dic = nil;
                if ([response isKindOfClass:[NSData class]]) {
                    dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                }else{
                    dic = response;
                }
                if (response) {
                    dataDic2 = [NSDictionary dictionary];
                    dataDic2 = response[@"data"];
                    [self.tableView reloadData];
                }
                
            } fail:^(NSError *error) {
                
            }];
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark 合伙人咨询抢单
- (void)builbtn{
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/6 - 17.5, kScreenHeight  - 46, 32, 32)];
    leftImg.image = [UIImage imageNamed:@"sy_zx"];
    [self.view addSubview:leftImg];
    UILabel *leftLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenHeight -  18, kScreenWidth/3, 15)];
    leftLbl.text = @"咨询";
    leftLbl.textAlignment = NSTextAlignmentCenter;
    leftLbl.backgroundColor = [UIColor clearColor];
    leftLbl.textColor = [UIColor lightGrayColor];
    leftLbl.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:leftLbl];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth/3, 50)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn addTarget:self action:@selector(leftbtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *reservationBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/3, kScreenHeight - 44, kScreenWidth*2/3, 44)];
    [reservationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reservationBtn setTitle:@"我要抢单" forState:UIControlStateNormal];
    reservationBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    reservationBtn.backgroundColor = DMBSColor;
    [reservationBtn addTarget:self action:@selector(Grab) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:leftBtn];
    [self.view addSubview:reservationBtn];
}

#pragma mark 跳转抢单
- (void)Grab{
    GrabViewController *grab = [[GrabViewController alloc]init];
    GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:grab];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark 跳转客服
- (void)leftbtn{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]) {
        //        // chatService.csInfo = csInfo; //用户的详细信息，此数据用于上传用户信息到客服后台，数据的nickName和portraitUrl必须填写。(目前该字段暂时没用到，客服后台显示的用户信息是你获取token时传的参数，之后会用到）
        RongchatViewController *chatService = [[RongchatViewController alloc] init];
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = @"KEFU149663440586772";
        chatService.title = @"客服";
        //chatService.csInfo = csInfo; //用户的详细信息，此数据用于上传用户信息到客服后台，数据的nickName和portraitUrl必须填写。(目前该字段暂时没用到，客服后台显示的用户信息是你获取token时传的参数，之后会用到）
        [self.navigationController pushViewController :chatService animated:YES];
    }else{
        DBLoginViewController *loginVC = [[DBLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma mark 跳转推送消息
- (void)rightBarButtonItemAction{
    HistorymesageViewController *hisvc = [[HistorymesageViewController alloc]init];
    GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:hisvc];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}
#pragma mark  跳转选择小区
- (void)address{
    //去选地图
    CommnuityViewControler *chhosemap = [[CommnuityViewControler alloc]init];
    [self.navigationController pushViewController:chhosemap animated:YES];
}
#pragma mark 未登录首页
- (void)buildNotLogonUI{
    
    [AMapServices sharedServices].apiKey = @"8c1e6b6219874f14b5ae722eef8ff834";
    //    [self initSearch];
    [self initMapView];
    
    //头部小区
    [self buildheadView];
    //预约托管按钮
    [self TrusteeshipBtn];
    //融云按钮
    [self buildCallRongIM];
    //服务保障
    [self buildSrviceKnow];
}
#pragma mark 用户首页
- (void)buildUserUI{
    [AMapServices sharedServices].apiKey = @"8c1e6b6219874f14b5ae722eef8ff834";
    //    [self initSearch];
    [self initMapView];
    
    //头部小区
    [self buildheadView];
    //合伙人信息弹框
    [self buildPanterView];
    //预约托管按钮
    [self TrusteeshipBtn];
    //融云按钮
    [self buildCallRongIM];
    //服务保障
    [self buildSrviceKnow];
    //进行中的订单
    [self buildUserorder];
}
#pragma mark 用户---头部小区UI
- (void)buildheadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(10, 74, kScreenWidth - 20, 30)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UIImageView *headimg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 15, 15)];
    headimg.image = [UIImage imageNamed:@"rl_cw-1"];
    [headView addSubview:headimg];
    
    UILabel *headlbl = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 30)];
    headlbl.font = [UIFont systemFontOfSize:13];
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedCommunty"];
    if ([str isEqualToString:@"1"]) {
        headlbl.text = @"请选择小区";
    }else{
        headlbl.text = str;
    }
    
    headlbl.textColor = UIColorFromRGB(0X666666);
    [headView addSubview:headlbl];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20 - 30, 5, 20,20)];
    img.image = [UIImage imageNamed:@"grzx_qj"];
    [headView addSubview:img];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0 ,0,kScreenWidth,30)];
    if (ISPANTER == 1) {
        [btn addTarget:self action:@selector(address) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btn addTarget:self action:@selector(logonbtn) forControlEvents:UIControlEventTouchUpInside];
    }
    [headView addSubview:btn];
}
#pragma mark 用户---跳转融云
- (void)buildCallRongIM{
    UIButton *rongbtn = [[UIButton alloc]initWithFrame:CGRectMake(20 , kScreenHeight - 58, 50, 50)];
    rongbtn.layer.masksToBounds = YES;
    rongbtn.layer.cornerRadius = 25;
    [rongbtn setImage:[UIImage imageNamed:@"sy_kefu"] forState:UIControlStateNormal];
    if (ISPANTER == 0 || ISPANTER == 1) {
        [rongbtn addTarget:self action:@selector(leftbtn) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [rongbtn addTarget:self action:@selector(logonbtn) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:rongbtn];
}
#pragma mark 跳转预约托管
- (void)TrusteeshipBtn{
    UIButton *SrviceKnowBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 80, kScreenHeight - 53, 160, 40)];
    SrviceKnowBtn.layer.masksToBounds = YES;
    SrviceKnowBtn.layer.cornerRadius = 20;
    SrviceKnowBtn.backgroundColor = DMBSColor;
    [SrviceKnowBtn setTitle:@"预约托管" forState:UIControlStateNormal];
    [SrviceKnowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (ISPANTER == 1) {
        [SrviceKnowBtn addTarget:self action:@selector(turstship1:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [SrviceKnowBtn addTarget:self action:@selector(logonbtn) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:SrviceKnowBtn];
}
#pragma mark 跳转服务保障
- (void)buildSrviceKnow{
    UIButton *UserKnowbtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 70, kScreenHeight - 58, 50, 50)];
    UserKnowbtn.layer.masksToBounds = YES;
    UserKnowbtn.layer.cornerRadius = 25;
    [UserKnowbtn setImage:[UIImage imageNamed:@"sy_cwbz"] forState:UIControlStateNormal];
    if (ISPANTER == 1) {
        [UserKnowbtn addTarget:self action:@selector(SrviceKnowBtn) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [UserKnowbtn addTarget:self action:@selector(logonbtn) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:UserKnowbtn];
}
#pragma mark 跳转用户须知
- (void)SrviceKnowBtn{
    UserKnowViewController *SrviceVc = [[UserKnowViewController alloc]init];
    GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:SrviceVc];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}
#pragma mark 跳转预约界面
- (void)logonbtn{
    DBLoginViewController *logonvc = [[DBLoginViewController alloc]init];
    GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:logonvc];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}
#pragma 用户--合伙人信息弹框
- (void)buildPanterView{
    NSString *selectedCommuntyStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedCommunty"];
    NSDictionary *dic = nil;
    dic = @{@"communityName":selectedCommuntyStr};
    NSString *str = [KDmbsBaseUrl stringByAppendingString:KMain_QueryPartnerOfCommunityList];
    [HYBNetworking postWithUrl:str refreshCache:YES params:dic success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            
            NSArray *dat = [NSArray array];
            dat = response[@"data"];
            if (dat.count == 0) {
                
            }else{
                locationID = [NSMutableArray array];
                locArr = [NSMutableArray array];
                for (int i = 0; i <dat.count; i ++) {
                    [locationID addObject:dat[i][@"partnerId"]];
                    [locArr addObject:[NSString stringWithFormat:@"%@,%@",dat[i][@"latitude"],dat[i][@"longitude"]]];
                }
                for (int i = 0;i < locArr.count ; i++) {
                    
                    NSArray *arr = [locArr[i] componentsSeparatedByString:@","];
                    if (arr.count != 2) {
                        continue;
                    }
                    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
                    pointAnnotation.coordinate = CLLocationCoordinate2DMake([arr[0] doubleValue], [arr[1] doubleValue]);
                    pointAnnotation.title = locationID[i];;
                    //        pointAnnotation.subtitle = @"阜通东大街6号";
                    [self.mapView addAnnotation:pointAnnotation];
                }
            }
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - 地图模块
- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), kScreenHeight - 64)];
    self.mapView.delegate = self;
    self.mapView.showsCompass= NO;
    
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    self.isLocated = NO;
    
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;
    [self.mapView updateUserLocationRepresentation:r];
    
    //    locationIDStr = nil;
}
- (void)initLocationButton
{
    self.imageLocated = [UIImage imageNamed:@"gpssearchbutton"];
    //    self.imageNotLocate = [UIImage imageNamed:@"gpsnormal"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.mapView.zoomLevel = 17;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        
        NSString *urlString = [KPictureUrl stringByAppendingString:KPicturePartner];
        annotationView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",urlString,annotation.title]]]];
        annotationView.frame = CGRectMake(0, 0, 50, 50);        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        annotationView.layer.masksToBounds = YES;
        annotationView.layer.cornerRadius = 25;
        
        UIButton *Panterbtn = [[UIButton alloc]initWithFrame:annotationView.frame];
        Panterbtn.layer.masksToBounds = YES;
        Panterbtn.layer.cornerRadius = 25;
        Panterbtn.tag = [annotation.title integerValue];
        [Panterbtn addTarget:self action:@selector(penterBtn:) forControlEvents:UIControlEventTouchUpInside];
        [annotationView addSubview:Panterbtn];
        
        return annotationView;
    }
    return nil;
}
#pragma 用户--合伙人信息展示
- (void)penterBtn:(UIButton *)panterBtn{
    panterbutton = [[UIButton alloc]initWithFrame:CGRectMake(0 , 0, kScreenWidth, kScreenHeight - 200)];
    [panterbutton addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:panterbutton];
    
    //合伙人点击信息
    NSDictionary *dict1 = nil;
    dict1 = @{@"partnerId":[NSString stringWithFormat:@"%ld",panterBtn.tag]};
    NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_PartnerOrder];
    [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            panterView= [[[NSBundle mainBundle]loadNibNamed:@"pantermessageView" owner:self options:nil]objectAtIndex:0];
            NSString *urlString = [KPictureUrl stringByAppendingString:KPicturePartner];
            [panterView.userImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%ld.jpg",urlString,(long)panterBtn.tag]] placeholderImage:[UIImage imageNamed:@"IMAGe-2"] completed:nil];
            
            panterView.frame = CGRectMake(10, 110, kScreenWidth - 20, 120);
            panterView.panterNamelbl.text = response[@"data"][@"partnerName"];
            panterView.JDNumLbl.text = [NSString stringWithFormat:@"接单:%@次",response[@"data"][@"orderCount"]];
            panterView.TGnumLbl.text = [NSString stringWithFormat:@"%@",response[@"data"][@"numByPartnerOrder"]];
            panterView.CallBtn.tag = [response[@"data"][@"phoneNum"] integerValue];
            [panterView.CallBtn addTarget:self action:@selector(callBtn:) forControlEvents:UIControlEventTouchUpInside];
            panterView.OrderBtn.tag = panterBtn.tag;
            if([response[@"data"][@"appointmentFlag"] isEqualToString:@"1"]){
                [panterView.OrderBtn setTitle:@"预约已满" forState:UIControlStateNormal];
            }else{
                [panterView.OrderBtn addTarget:self action:@selector(turstship:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:panterView];
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
    
    [self.tableView reloadData];
}











#pragma mark - MapViewDelegate
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.isMapViewRegionChangedFromTableView = NO;
}
#pragma mark - userLocation
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(!updatingLocation)
        return ;
    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
    // only the first locate used.
    if (!self.isLocated)
    {
        self.isLocated = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
    }
}
- (void)mapView:(MAMapView *)mapView  didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    if (mode == MAUserTrackingModeNone)
    {
        [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
    }
    else
    {
        [self.locationBtn setImage:self.imageLocated forState:UIControlStateNormal];
    }
}
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}









#pragma mark 用户首页下面弹框取消预约，接口还没出
- (void)cancalBtn{
}
#pragma mark 用户首页下面弹框拨打电话
- (void)callBtn:(UIButton *)btn{
    [MainViewController callPhoneStr:[NSString stringWithFormat:@"%ld",btn.tag] withVC:self];
}
#pragma mark 用户首页下面更多订单
- (void)moreOderBtn:(UIButton *)btn{
    MyOrderViewController *MyOrdervc = [[MyOrderViewController alloc]init];
    GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:MyOrdervc];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark 打电话
- (void)callPhoneUser:(UIButton *)btn{
    NSLog(@"%ld",btn.tag);
    [MainViewController callPhoneStr:[NSString stringWithFormat:@"%ld",btn.tag] withVC:self];
}
+ (void)callPhoneStr:(NSString*)phoneStr withVC:(UIViewController *)selfvc{
    if (phoneStr.length >= 10) {
        NSString *str2 = [[UIDevice currentDevice] systemVersion];
        if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
        {
            NSString* PhoneStr = [NSString stringWithFormat:@"telprompt://%@",phoneStr];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:^(BOOL success) {
                NSLog(@"phone success");
            }];
        }else {
            NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
            if (phoneStr.length == 10) {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:7];// 把一个字符串插入另一个字符串中的某一个位置
            }else {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:8];// 把一个字符串插入另一个字符串中的某一个位置
            }
            NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message: nil preferredStyle:UIAlertControllerStyleAlert];
            // 设置popover指向的item
            alert.popoverPresentationController.barButtonItem = selfvc.navigationItem.leftBarButtonItem;
            // 添加按钮
            [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                NSLog(@"点击了呼叫按钮10.2下");
                NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
                if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                    UIApplication * app = [UIApplication sharedApplication];
                    if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                        [app openURL:[NSURL URLWithString:PhoneStr]];
                    }
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消按钮");
            }]];
            [selfvc presentViewController:alert animated:YES completion:nil];
        }
    }
}
#pragma 用户--进行中的订单
- (void)buildUserorder{
    //合伙人首页
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    NSDictionary *dict1 = nil;
    dict1 = @{@"UserId":str};
    NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_LoginInit];
    [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            if ([@"" isEqualToString:response[@"data"]]) {
                
            }else{
                OrderView= [[[NSBundle mainBundle]loadNibNamed:@"UserorderView" owner:self options:nil]objectAtIndex:0];
                NSString *urlString = [KPictureUrl stringByAppendingString:KPicturePartner];
                [OrderView.petImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",urlString,response[@"data"][0][@"partnerId"]]] placeholderImage:[UIImage imageNamed:@"IMAGe-2"] completed:nil];
                OrderView.frame = CGRectMake(10, kScreenHeight - 200, kScreenWidth - 20, 130);
                OrderView.PetNameLbl.text = response[@"data"][0][@"userName"];
                OrderView.sendTimeLbl.text = [NSString stringWithFormat:@"接宠时间：%@",response[@"data"][0][@"receiveTime"]];
                OrderView.getTimeLbl.text = [NSString stringWithFormat:@"送宠时间：%@",response[@"data"][0][@"returnTime"]];
                OrderView.OrderNumLbl.text = [NSString stringWithFormat:@"接单:%@次",response[@"data"][0][@"orderCount"]];
                OrderView.petImg.image = [UIImage imageNamed:@"logo"];
                [OrderView.cancalBtn addTarget:self action:@selector(cancalBtn) forControlEvents:UIControlEventTouchUpInside];
                OrderView.CallBtn.tag = [response[@"data"][0][@"phoneNum"] integerValue];
                [OrderView.CallBtn addTarget:self action:@selector(callBtn:) forControlEvents:UIControlEventTouchUpInside];
                [OrderView.moreOderBtn addTarget:self action:@selector(moreOderBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:OrderView];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)btn{
    [panterView removeFromSuperview];
    [panterbutton removeFromSuperview];
    [self.tableView reloadData];
}

#pragma mark 跳转预约界面
- (void)turstship:(UIButton *)btn{
    AppointmentViewController *turstshipvc = [[AppointmentViewController alloc]init];
    //    ButtonsViewController *turstshipvc = [[ButtonsViewController alloc]init];
    turstshipvc.panterId = [NSString stringWithFormat:@"%ld",btn.tag];
    //合伙人点击信息
    NSDictionary *dict1 = nil;
    dict1 = @{@"partnerId":turstshipvc.panterId};
    turstshipvc.ISAppoint = 1;
    NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_PartnerOrder];
    [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            turstshipvc.panterName = response[@"data"][@"partnerName"];
            GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:turstshipvc];
            self.frostedViewController.contentViewController = navigationController;
            [self.frostedViewController hideMenuViewController];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)turstship1:(UIButton *)btn{
    NSString *selectedCommuntyStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedCommunty"];
    NSDictionary *dict1 = nil;
    dict1 = @{@"communityName":selectedCommuntyStr};
    NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_QueryCommunityId];
    [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            if ([response[@"retnCode"] integerValue] == 1) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:response[@"retnDesc"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            }else{
                AppointmentViewController *turstshipvc = [[AppointmentViewController alloc]init];
                turstshipvc.ISAppoint = 0;
                GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:turstshipvc];
                self.frostedViewController.contentViewController = navigationController;
                [self.frostedViewController hideMenuViewController];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}


//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)//确认跳转设置
    {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
@end
