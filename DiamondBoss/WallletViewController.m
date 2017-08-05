//
//  SecondViewController.m
//  DiamondBoss
//
//  Created by bonday012 on 17/4/7.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "WallletViewController.h"
#import "WalletTableViewCell.h"
#import "WalletMesageViewController.h"
#import "MainViewController.h"
#import "LeftCenterViewController.h"
#import "WithDrawViewController.h"
@interface WallletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,copy) NSDictionary *amtDic;

@end

@implementation WallletViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KLeft_QueryDetailed];
    NSDictionary *dict = nil;
    dict = @{@"partnerId":str};
    [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            _dataArr = [NSArray array];
            _dataArr = dic[@"data"];
            if (0 == _dataArr.count) {
                UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 42, (kScreenHeight-64)/2 - 63 - 64, 83, 126)];
                img.image = [UIImage imageNamed:@"grabimg"];
                [self.view addSubview:img];
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, (kScreenHeight-64)/2, kScreenWidth, 20)];
                lbl.text = @"暂无明细记录";
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.font = [UIFont systemFontOfSize:13];
                lbl.textColor = UIColorFromRGB(0x979797);
                
                [self.view addSubview:lbl];
            }else{
                NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
                NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KLeft_QuerySummaryInfo];
                NSDictionary *dict = nil;
                dict = @{@"partnerId":str};
                [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
                    NSLog(@"post请求成功%@", response);
                    NSDictionary *dic = nil;
                    if ([response isKindOfClass:[NSData class]]) {
                        dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                    }else{
                        dic = response;
                    }
                    if (response) {
                        _amtDic = [NSDictionary dictionary];
                        _amtDic = response[@"data"];
                        
                        [self creatUItableview];
                    }
                    
                } fail:^(NSError *error) {
                    
                }];
            }
        }
    } fail:^(NSError *error) {
        
    }];
    
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
    MainViewController *con = [[MainViewController alloc]init];
    [self.navigationController pushViewController:con animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"钱包";
    self.view.backgroundColor =UIColorFromRGB(0XF2F2F2);
}
- (void)creatUItableview{
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-70)];
    [_leftTableView registerNib:[UINib nibWithNibName:@"WalletTableViewCell" bundle:nil] forCellReuseIdentifier:@"WalletTableViewCell"];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.backgroundColor = UIColorFromRGB(0XF2F2F2);
    _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_leftTableView];

}
- (void)animate{
    WalletMesageViewController *walletmeessage = [[WalletMesageViewController alloc]init];
    [self.navigationController pushViewController:walletmeessage animated:YES];
}


#pragma mark - tableView的协议方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 85;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 95;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.dataArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, kScreenWidth, 25)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:18];
    lbl.textColor = UIColorFromRGB(0X979797);
    lbl.text = @"我的余额 (元)";
    [view addSubview:lbl];
    
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, kScreenWidth, 42)];
    lbl1.text = [NSString stringWithFormat:@"¥%@",_amtDic[@"availableBalance"]];
    lbl1.font = [UIFont systemFontOfSize:42];
    lbl1.textColor = UIColorFromRGB(0X444444);
    lbl1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lbl1];
    
    UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, kScreenWidth, 15)];
    lbl3.textAlignment = NSTextAlignmentCenter;
    lbl3.font = [UIFont systemFontOfSize:11];
    lbl3.textColor = UIColorFromRGB(0X979797);
    lbl3.text = [NSString stringWithFormat:@"即将入账：%@元",_amtDic[@"realBalance"]];
    [view addSubview:lbl3];
    
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, kScreenWidth, 10)];
    lbl2.backgroundColor = UIColorFromRGB(0Xf2f2f2);
    [view addSubview:lbl2];
    
    UILabel *lbl5 = [[UILabel alloc]initWithFrame:CGRectMake(20, 170, 100, 20)];
    lbl5.text = @"时间";
    lbl5.font = [UIFont systemFontOfSize:14];
    lbl5.textColor = UIColorFromRGB(0XAFAFAF);
    [view addSubview:lbl5];
    
    UILabel *lbl6 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-30, 170, 100, 20)];
    lbl6.text = @"时间";
    lbl6.font = [UIFont systemFontOfSize:14];
    lbl6.textColor = UIColorFromRGB(0XAFAFAF);
    [view addSubview:lbl6];
    
    UILabel *lbl7 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 170, 85, 20)];
    lbl7.text = @"状态";
    lbl7.font = [UIFont systemFontOfSize:14];
    lbl7.textColor = UIColorFromRGB(0XAFAFAF);
    lbl7.textAlignment = NSTextAlignmentRight;
    [view addSubview:lbl7];
    
    
    UILabel *xianlbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 199, kScreenWidth, 1)];
    xianlbl.backgroundColor = UIColorFromRGB(0Xf2f2f2);
    [view addSubview:xianlbl];
    
    self.leftTableView.tableHeaderView=view;
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = UIColorFromRGB(0XF2F2F2);
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, kScreenWidth +20, 34)];
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1 setTitleColor:UIColorFromRGB(0X979797) forState:UIControlStateNormal];
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 5;
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn1 setTitle:@"查看更多" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(animate) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];

    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 55, kScreenWidth - 30, 40)];
    btn.backgroundColor = DMBSColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    [btn setTitle:@"提现" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tixian) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    self.leftTableView.tableFooterView = view;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletTableViewCell" forIndexPath:indexPath];
    NSString *string = _dataArr[indexPath.row][@"time"];
    NSArray *array = [string componentsSeparatedByString:@" "];//字符串按照【分隔成数组
    cell.leftlbl.text = array[0];
    cell.timeLbl.text = array[1];
    cell.rightlbl.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"amt"]];
    cell.statusLbl.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"status"]];//状态
    cell.gatarylbl.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"kind"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tixian{
    WithDrawViewController *feedback = [[WithDrawViewController alloc]init];
    feedback.priceStr = _amtDic[@"availableBalance"];
    GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:feedback];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}


@end
