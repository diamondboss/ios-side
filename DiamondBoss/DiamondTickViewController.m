//
//  DiamondTickViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/6/7.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "DiamondTickViewController.h"
#import "MainViewController.h"
@interface DiamondTickViewController ()
@property (nonatomic,strong)UIButton *btn;
@end

@implementation DiamondTickViewController
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
    MainViewController *con = [[MainViewController alloc]init];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"呆萌券";
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildUI];
}
- (void)buildUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 120)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 20)/2 - 40, 84, 30, 30)];
    img.image = [UIImage imageNamed:@"grzx_qb5"];
    [view addSubview:img];
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 20)/2 - 10, 84, 100, 30)];
    lb.text = @"呆萌券";
    [view addSubview:lb];
    
    UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, kScreenWidth - 20, 50)];
    lb1.text = [NSString stringWithFormat:@"%@张",@"0"];
    lb1.textAlignment = NSTextAlignmentCenter;
    lb1.font = [UIFont systemFontOfSize:40];
    [view addSubview:lb1];
    [self.view addSubview:view];
    
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 204, kScreenWidth - 20, 160)];
    lbl.numberOfLines = 0;
    lbl.backgroundColor = UIColorRGB(245, 245, 245);
    lbl.text = @"说明：呆萌券是上海夙愿网络科技旗下的宠物预约使用券。\n\n应用场景：宠物预约的时候可以使用呆萌券支付。\n\n如何获取：购买呆萌券或者取消预约返还，活动发放。\n\n如何使用：在预约支付的时候，如果用户拥有呆萌券可以勾选呆萌券支付。";
    lbl.textColor = [UIColor lightGrayColor];
    lbl.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:lbl];
    
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 384, kScreenWidth, 30)];
    lbl1.textColor = DMBSColor;
    lbl1.text = @"敬请期待，会在将来的版本中加入呆萌券";
    lbl1.font = [UIFont systemFontOfSize:15];
    lbl1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl1];
}

@end
