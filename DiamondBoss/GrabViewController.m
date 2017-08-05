//
//  GrabViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/6/20.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "GrabViewController.h"
#import "MainViewController.h"
#import "GrabTableViewCell.h"
#import "PanterOrderViewController.h"
@interface GrabViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *TableView;
@property (nonatomic,strong) NSArray *Allary;

@end

@implementation GrabViewController
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
    self.title = @"抢单";
    self.view.backgroundColor = UIColorRGB(237, 237, 237);
    [self loadDataSource];
}
- (void)creatGravUItableview{
    _TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    [_TableView registerNib:[UINib nibWithNibName:@"GrabTableViewCell" bundle:nil] forCellReuseIdentifier:@"GrabTableViewCell"];
    _TableView.backgroundColor = UIColorRGB(237, 237, 237);
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_TableView];
    
    if (_Allary.count == 0) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 42, (kScreenHeight-64)/2 - 63 - 64, 83, 126)];
        img.image = [UIImage imageNamed:@"grabimg"];
        [self.view addSubview:img];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, (kScreenHeight-64)/2, kScreenWidth, 20)];
        lbl.text = @"暂无订单信息";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:13];
        lbl.textColor = UIColorFromRGB(0x979797);
        
        [self.view addSubview:lbl];
    }
}
- (void)loadDataSource{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    NSDictionary *dict1 = nil;
    dict1 = @{@"partnerId":str};
    NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_panterqueryOrder];
    [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            _Allary = [NSArray array];
            _Allary = response[@"data"];
            [self creatGravUItableview];
        }
        [self.TableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark 添加 RightBarButtonItem

#pragma mark - tableView的协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _Allary.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GrabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GrabTableViewCell" forIndexPath:indexPath];
    cell.OrderLbl.text = [NSString stringWithFormat:@"%@",_Allary[indexPath.row][@"id"]];
    cell.sendTimeLbl.text = _Allary[indexPath.row][@"receiveTime"];
    cell.OrderMoneylbl.text = _Allary[indexPath.row][@"amt"];
    cell.getTimeLbl.text = _Allary[indexPath.row][@"returnTime"];
    cell.downLbl.text = _Allary[indexPath.row][@"userName"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PanterOrderViewController *graddetailvc = [[PanterOrderViewController alloc]init];
    graddetailvc.OrderDic = _Allary[indexPath.row];
    GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:graddetailvc];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

@end
