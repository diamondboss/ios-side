//
//  SecondViewController.m
//  DiamondBoss
//
//  Created by bonday012 on 17/4/7.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "LeftCenterViewController.h"
#import "LeftTableViewCell.h"
#import "WallletViewController.h"
#import "FeedBackViewController.h"
#import "AboutViewController.h"
#import "MainViewController.h"
#import "HistorymesageViewController.h"
#import "EditPersonViewController.h"
#import "DiamondTickViewController.h"

#import "BaseNavigationController.h"
#import "REFrostedViewController.h"
#import "GlobalNavigationController.h"

#import "MyOrderViewController.h"
@interface LeftCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *urlString;
}
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *headimgArr;
@property (nonatomic,strong) NSArray *controllArr;

@end

@implementation LeftCenterViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    NSString *str1 = [[NSUserDefaults standardUserDefaults ]objectForKey:@"isuser"];
    if ([str1 isEqualToString:@"1"]) {
        
        _dataArr = [NSArray array];
        _dataArr = @[@"我的订单",@"我的钱包",@"个人资料",@"问题反馈"];
        //    ,@"退出"
        _headimgArr = [NSArray array];
        _headimgArr = @[@"grzx_qb2",@"grzx_qb",@"grzx_bj",@"grzx_bzyfk"];
        //,@"grzx_bj"
        self.title = @"个人中心";
        
    }else{
        _dataArr = [NSArray array];
        _dataArr = @[@"我的订单",@"呆萌券",@"个人资料",@"问题反馈"];
        //    ,@"退出"
        _headimgArr = [NSArray array];
        _headimgArr = @[@"grzx_qb2",@"grzx_qb5",@"grzx_bj",@"grzx_bzyfk"];
        //,@"grzx_bj"
        self.title = @"个人中心";
    }
    [self creatUItableview];
    UIView *downview = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth - 100, 44)];
    downview.backgroundColor = UIColorFromRGB(0Xfdfdfd);
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(13, 5 , 100 , 34)];
    lbl.text = @"关于我们";
    lbl.textColor = UIColorFromRGB(0X666666);
    lbl.font = [UIFont systemFontOfSize:14];
    [downview addSubview:lbl];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 138, 10, 25, 25)];
    img.image = [UIImage imageNamed:@"grzx_qj"];
    [downview addSubview:img];
    
    UIView *xianview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 1)];
    xianview.backgroundColor = UIColorFromRGB(0Xd8d8d8);
    [downview addSubview:xianview];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 44)];
    [btn addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
    [downview addSubview:btn];
    
    [self.view addSubview:downview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _controllArr = [NSArray array];
    // Do any additional setup after loading the view.
}
- (void)creatUItableview{
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [_leftTableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeftTableViewCell"];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.backgroundColor = [UIColor whiteColor];
    _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _leftTableView.scrollEnabled = NO;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_leftTableView];
}

#pragma mark - tableView的协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 210;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = DMBSColor;
    
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(((kScreenWidth-100)/2) - 40, 60, 80, 80)];
    
//  leftImg.image = [UIImage imageNamed:@"IMAGe-2"];
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    NSString *str1 = [[NSUserDefaults standardUserDefaults ]objectForKey:@"isuser"];
    if ([str1 isEqualToString:@"1"]){
        urlString = [KPictureUrl stringByAppendingString:KPicturePartner];
    }else{
        urlString = [KPictureUrl stringByAppendingString:KPictureUserUrl];
    }
    [leftImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",urlString,str]] placeholderImage:[UIImage imageNamed:@"IMAGe-2"] completed:nil];
    
    leftImg.layer.cornerRadius = 40;
    leftImg.layer.masksToBounds = YES;
    [view addSubview:leftImg];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(((kScreenWidth-100)/2) - 40, 60, 80, 80)];
    [leftBtn addTarget:self action:@selector(gotoeditMessageBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, kScreenWidth - 100, 30)];
    NSString *nameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"];
    lbl.text = [NSString stringWithFormat:@"%@",nameStr];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [UIColor whiteColor];
    [view addSubview:lbl];
    
    UIView *xiview = [[UIView alloc]initWithFrame:CGRectMake(0,200, kScreenWidth, 10)];
    xiview.backgroundColor = [UIColor whiteColor];
    [view addSubview:xiview];


    self.leftTableView.tableHeaderView=view;
    return view;
}
- (void)gotoeditMessageBtn{
    EditPersonViewController *editvc = [[EditPersonViewController alloc]init];
    GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:editvc];
    self.frostedViewController.contentViewController = navigationController;
    
    [self.frostedViewController hideMenuViewController];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftTableViewCell" forIndexPath:indexPath];
    cell.leftlabel.text = _dataArr[indexPath.row];
    cell.headimg.image = [UIImage imageNamed:_headimgArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    if (indexPath.row == 0) {
        MyOrderViewController *myorder = [[MyOrderViewController alloc]init];
        GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:myorder];
        self.frostedViewController.contentViewController = navigationController;
        
        [self.frostedViewController hideMenuViewController];
    }
    if (indexPath.row == 1) {
        NSString *str1 = [[NSUserDefaults standardUserDefaults ]objectForKey:@"isuser"];
        if ([str1 isEqualToString:@"1"]) {
            WallletViewController *myorder = [[WallletViewController alloc]init];
            GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:myorder];
            self.frostedViewController.contentViewController = navigationController;
            [self.frostedViewController hideMenuViewController];
            
        }else{
            DiamondTickViewController *myorder = [[DiamondTickViewController alloc]init];
            GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:myorder];
            self.frostedViewController.contentViewController = navigationController;
            [self.frostedViewController hideMenuViewController];
            
        }
    }
    if (indexPath.row == 2) {
        EditPersonViewController *editvc = [[EditPersonViewController alloc]init];
        GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:editvc];
        self.frostedViewController.contentViewController = navigationController;
        
        [self.frostedViewController hideMenuViewController];
    }
    if (indexPath.row == 3) {
        FeedBackViewController *feedback = [[FeedBackViewController alloc]init];
        GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:feedback];
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
    }
}
//在页面消失的时候就让navigationbar还原样式
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)about{
    AboutViewController *ab =[[AboutViewController alloc]init];
    GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:ab];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}
@end
