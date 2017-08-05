//
//  WithDrawViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/7/31.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "WithDrawViewController.h"
#import "WallletViewController.h"
@interface WithDrawViewController ()

@end

@implementation WithDrawViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = DMBSColor;
    NSDictionary *dit = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dit];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 5, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"grzx_ht"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
}
- (void)popTo{
    WallletViewController *wallMesage = [[WallletViewController alloc]init];
    [self.navigationController pushViewController:wallMesage animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提现";
    _moneyLbl.keyboardType = UIKeyboardTypeNumberPad;
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 18;
    
    self.commitBtn.layer.cornerRadius = 5;
    self.commitBtn.layer.masksToBounds = YES;
}

- (IBAction)coommit:(id)sender {
    NSDecimalNumber * rest = [NSDecimalNumber decimalNumberWithString:_moneyLbl.text];
    NSDecimalNumber * pointMoney = [NSDecimalNumber decimalNumberWithString:_priceStr];
    NSComparisonResult result = [rest compare:pointMoney];
    if (result ==NSOrderedDescending) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提现金额不能大于余额" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else{
        
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
        NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KLeft_Withdrawals];
        NSDictionary *dict = nil;
        dict = @{@"partnerId":str,@"value":_moneyLbl.text};
        [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
            NSLog(@"post请求成功%@", response);
            NSDictionary *dic = nil;
            if ([response isKindOfClass:[NSData class]]) {
                dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            }else{
                dic = response;
            }
            if (response) {
                
                if ([response[@"retnCode"] integerValue] == 0) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:response[@"retnDesc"] preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        WallletViewController *wallMesage = [[WallletViewController alloc]init];
                        [self.navigationController pushViewController:wallMesage animated:NO];
                    }]];
                    //弹出提示框；
                    [self presentViewController:alert animated:true completion:nil];
                }
                //提现失败
                if ([response[@"retnCode"] integerValue] == 1) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:response[@"retnDesc"] preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        
                    }]];
                    //弹出提示框；
                    [self presentViewController:alert animated:true completion:nil];
                }
                
            }
        } fail:^(NSError *error) {
            
        }];

    }
}

@end
