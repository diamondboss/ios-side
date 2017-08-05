//
//  AboutViewController.m
//  DiamondBoss
//
//  Created by edz on 2017/5/11.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "AboutViewController.h"
#import "MainViewController.h"
#import "LMWebProgressLayer.h"
#import "UIView+Frame.h"
@interface AboutViewController ()<UIWebViewDelegate>
{
    LMWebProgressLayer *_progressLayer; ///< 网页加载进度条
}
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation AboutViewController
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
    [self.navigationController pushViewController:con animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    self.view.backgroundColor = UIColorRGB(239, 239, 239);
    [self buildUI];
}

- (void)buildUI{
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 40, 90, 80, 80)];
    img.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:img];
    
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 180, kScreenWidth , 30)];
    lbl1.text = @"我们是谁？";
    lbl1.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:lbl1];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 200, kScreenWidth - 60, 250)];
    lbl.numberOfLines = 0;
    lbl.textColor = [UIColor darkGrayColor];
    lbl.text = @"呆萌博士创立于2017年是一个从事宠物生态链的创业团队核心成员均是技术大牛和深度宠物控。\n\n呆萌博士是致力于宠物生态链的发展，前期进行宠物的预约托管服务。让上班和外出的你不必担心家里的它，给你们一个安全放心，快捷便利的寄养环境。\n\n现在业务已经开始试推市场。致力成为大家生活中必不可缺的贴心App。\n\n上海夙愿网络科技有限公司";
    lbl.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:lbl];
    
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(30, kScreenHeight - 50, kScreenWidth - 60, 20)];
    lbl2.textAlignment = NSTextAlignmentCenter;
    lbl2.textColor = [UIColor lightGrayColor];
    lbl2.text = @"Copyright 2016-2017";
    lbl2.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:lbl2];
    
    UILabel *ll2 = [[UILabel alloc]initWithFrame:CGRectMake(30, kScreenHeight - 30, kScreenWidth - 60, 20)];
    ll2.textAlignment = NSTextAlignmentCenter;
    ll2.textColor = [UIColor lightGrayColor];
    ll2.text = @"上海夙愿网络科技有限公司";
    ll2.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:ll2];


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
