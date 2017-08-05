//
//  MyOrderViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/6/19.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MainViewController.h"
#import "SegViewController.h"
#import "ExamViewController.h"
static CGFloat const ButtonHeight = 44;

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController
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
    self.title = @"我的订单";
    self.view.backgroundColor = UIColorRGB(237, 237, 237);
//     Do any additional setup after loading the view.
    SegViewController *vc = [[SegViewController alloc]init];
    NSArray *titleArray = @[@"正在进行", @"已经取消", @"已经完成"];
    vc.titleArray = titleArray;
    NSMutableArray *controlArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < vc.titleArray.count; i ++) {
        ExamViewController *vc = [[ExamViewController alloc]initWithIndex:i title:titleArray[i]];
        [controlArray addObject:vc];
    }
    vc.titleSelectedColor = DMBSColor;
    vc.subViewControllers = controlArray;
    vc.buttonWidth = kScreenWidth/3;
    vc.buttonHeight = ButtonHeight;
    [vc initSegment];
    [vc addParentController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
