//
//  PanterOrderViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/7/20.
//  Copyright © 2017年 bonday012. All rights reserved.

#import "PanterOrderViewController.h"
#import "MyOrderViewController.h"
#import "GrabViewController.h"
#import "MainViewController.h"
@interface PanterOrderViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userName;//用户名字
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLbl;//订单价格
@property (weak, nonatomic) IBOutlet UILabel *returnTimelbl;//接宠时间
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLbl;//送宠时间
@property (weak, nonatomic) IBOutlet UILabel *ISDogfoodlbl;//是否携带狗粮
@property (weak, nonatomic) IBOutlet UILabel *animalName;//宠物名字
@property (weak, nonatomic) IBOutlet UILabel *age;//年龄
@property (weak, nonatomic) IBOutlet UILabel *sex;

@property (weak, nonatomic) IBOutlet UILabel *renarklbl;//备注
@property (weak, nonatomic) IBOutlet UIButton *QiangDanBtn;//抢单按钮
@property (weak, nonatomic) IBOutlet UILabel *pinzhonglbl;//品种
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;

@property (weak, nonatomic) IBOutlet UIImageView *userImg;


@property (weak, nonatomic) IBOutlet UIScrollView *myScrolleView;

@end

@implementation PanterOrderViewController
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
    if (_pushstatus == 1) {
        MyOrderViewController *grab = [[MyOrderViewController alloc]init];
        [self.navigationController pushViewController:grab animated:YES];
    }else{
        GrabViewController *grab = [[GrabViewController alloc]init];
        [self.navigationController pushViewController:grab animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    self.QiangDanBtn.layer.masksToBounds = YES;
    self.QiangDanBtn.layer.cornerRadius = 5;
    
    
    
    [self buildUI];

    if (_pushstatus == 1) {
        [_QiangDanBtn setTitle:@"" forState:UIControlStateNormal];
        _QiangDanBtn.backgroundColor = [UIColor clearColor];

    }else{
         [_QiangDanBtn addTarget:self action:@selector(qiangdan) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)buildUI{
    NSString *urlString = [KPictureUrl stringByAppendingString:KPictureUserUrl];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",urlString,_OrderDic[@"userId"]]] placeholderImage:[UIImage imageNamed:@"IMAGe-2"] completed:nil];
    _userName.text = [NSString stringWithFormat:@"%@",_OrderDic[@"userName"]];
    _orderMoneyLbl.text = [NSString stringWithFormat:@"%@元",_OrderDic[@"amt"]];
    _sendTimeLbl.text = [NSString stringWithFormat:@"送宠时间：%@",_OrderDic[@"receiveTime"]];
    _returnTimelbl.text = [NSString stringWithFormat:@"接宠时间：%@",_OrderDic[@"returnTime"]];
    _age.text = [NSString stringWithFormat:@"宠物年龄：%@",_OrderDic[@"age"]];
    _animalName.text = [NSString stringWithFormat:@"宠物姓名：%@",_OrderDic[@"petName"]];
    _phoneLbl.text = [NSString stringWithFormat:@"电话：%@",_OrderDic[@"userPhone"]];
    if ([_OrderDic[@"dogFood"] isEqualToString:@"1"]) {
        _ISDogfoodlbl.text = @"携带狗粮";
    }else{
        _ISDogfoodlbl.text = @"未携带狗粮";
    }
    _pinzhonglbl.text = [NSString stringWithFormat:@"宠物品种:%@",_OrderDic[@"varieties"]];//宠物品
    if ([_OrderDic[@"sex"] isEqualToString:@"1"]) {
        _sex.text = @"宠物性别：公狗";//宠物性别
    }else{
        _sex.text = @"宠物性别：母狗";//宠物性别
    }
    _renarklbl.text = [NSString stringWithFormat:@"%@",_OrderDic[@"remark"]];//备注
}

#pragma mark 打电话
- (IBAction)callUser:(id)sender {
    [PanterOrderViewController callPhoneStr:[NSString stringWithFormat:@"%@",_OrderDic[@"userPhone"]] withVC:self];
}
#pragma mark 抢单
- (void)qiangdan{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    NSDictionary *dict1 = nil;
    dict1 = @{@"partnerId":str,@"id":_OrderDic[@"id"],@"amt":_OrderDic[@"amt"],@"orderDate":_OrderDic[@"orderDate"]};
    NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_PanterGrabOrder];
    [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            if ([response[@"retnCode"] integerValue] == 0) {
                //初始化提示框；
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:response[@"retnDesc"] preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                    MainViewController *grab = [[MainViewController alloc]init];
                    [self.navigationController pushViewController:grab animated:NO];
                }]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            }else{
                //初始化提示框；
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:response[@"retnDesc"] preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                    GrabViewController *grab = [[GrabViewController alloc]init];
                    [self.navigationController pushViewController:grab animated:NO];
                }]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            }
        }
    } fail:^(NSError *error) {
        
    }];

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
@end
