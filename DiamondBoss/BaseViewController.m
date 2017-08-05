//
//  BaseViewController.m
//  DiamondBoss
//
//  Created by bonday012 on 17/4/7.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_pushstatus == 1) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem=back;
    }else{
        [self buildbasekBtn];
    }
}
- (void)buildbasekBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 5, 38, 38);
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_prev"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(baskbtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
}

- (void)baskbtn{
    [self.navigationController popViewControllerAnimated:YES];
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
