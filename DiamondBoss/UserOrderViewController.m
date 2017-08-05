//
//  UserOrderViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/7/20.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "UserOrderViewController.h"
#import "MyOrderViewController.h"
@interface UserOrderViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *PanterImg;//合伙人图片
@property (weak, nonatomic) IBOutlet UILabel *panterNameLbl;//合伙人姓名
@property (weak, nonatomic) IBOutlet UILabel *panterPhoneLbl;//合伙人电话

@property (weak, nonatomic) IBOutlet UILabel *orderLbl;//订单价格lbl
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLbl;//送宠时间
@property (weak, nonatomic) IBOutlet UILabel *returnTimeLbl;//接宠时间

@property (weak, nonatomic) IBOutlet UILabel *annimalNameLbl;//宠物名字
@property (weak, nonatomic) IBOutlet UILabel *animalSex;//宠物性别
@property (weak, nonatomic) IBOutlet UILabel *AnimalVartiesLbl;//宠物品种
@property (weak, nonatomic) IBOutlet UILabel *animalAgeLbl;//宠物年龄

@property (weak, nonatomic) IBOutlet UILabel *animalRemarklbl;//备注

@end

@implementation UserOrderViewController
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
    MyOrderViewController *grab = [[MyOrderViewController alloc]init];
    [self.navigationController pushViewController:grab animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户订单";
    
    [self buildUI];
}
- (void)buildUI{
    NSString *urlString = [KPictureUrl stringByAppendingString:KPicturePartner];
    [_PanterImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",urlString,_OrderDic[@"partnerId"]]] placeholderImage:[UIImage imageNamed:@"IMAGe-2"] completed:nil];

    _panterNameLbl.text = [NSString stringWithFormat:@"%@",_OrderDic[@"partnerNameOfOrder"]];//合伙人姓名
    _panterPhoneLbl.text = [NSString stringWithFormat:@"%@",_OrderDic[@"partnerPhone"]];//手机号
    _orderLbl.text = [NSString stringWithFormat:@"%@元",_OrderDic[@"amt"]];//订单价格lbl
    _sendTimeLbl.text = [NSString stringWithFormat:@"送宠时间:%@",_OrderDic[@"receiveTime"]];//送宠时间
    _returnTimeLbl.text = [NSString stringWithFormat:@"接宠时间:%@",_OrderDic[@"returnTime"]];//接宠时间
    
    
    _annimalNameLbl.text = [NSString stringWithFormat:@"宠物姓名:%@",_OrderDic[@"petName"]];//宠物名字
    if ([_OrderDic[@"sex"] isEqualToString:@"1"]) {
        _animalSex.text = @"宠物性别:公狗";//宠物性别
    }else{
        _animalSex.text = @"宠物性别:母狗";//宠物性别
    }
    _AnimalVartiesLbl.text = [NSString stringWithFormat:@"宠物品种:%@",_OrderDic[@"varieties"]];//宠物品
    _animalAgeLbl.text = [NSString stringWithFormat:@"宠物年龄:%@",_OrderDic[@"age"]];//宠物年龄
    _animalRemarklbl.text = [NSString stringWithFormat:@"%@",_OrderDic[@"remark"]];//备注
}
#pragma mark- 打电话
- (IBAction)callPanterbtn:(id)sender {
    [UserOrderViewController callPhoneStr:[NSString stringWithFormat:@"%@",_OrderDic[@"partnerPhone"]] withVC:self];
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
