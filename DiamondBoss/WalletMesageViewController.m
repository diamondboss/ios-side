//
//  SecondViewController.m
//  DiamondBoss
//
//  Created by bonday012 on 17/4/7.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "WalletMesageViewController.h"
#import "WalletTableViewCell.h"
#import "WallletViewController.h"
@interface WalletMesageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation WalletMesageViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KLeft_QueryTotalDetailed];
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
                [self creatUItableview];
            }

        }
    } fail:^(NSError *error) {
        
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 5, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"grzx_ht"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
}
- (void)popTo{
    WallletViewController *wallMesage = [[WallletViewController alloc]init];
    [self.navigationController pushViewController:wallMesage animated:NO];}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"钱包明细";
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)creatUItableview{
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    [_leftTableView registerNib:[UINib nibWithNibName:@"WalletTableViewCell" bundle:nil] forCellReuseIdentifier:@"WalletTableViewCell"];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.backgroundColor = [UIColor whiteColor];
    _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_leftTableView];
}

#pragma mark - tableView的协议方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl5 = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
    lbl5.text = @"时间";
    lbl5.font = [UIFont systemFontOfSize:14];
    lbl5.textColor = UIColorFromRGB(0XAFAFAF);
    [view addSubview:lbl5];
    
    UILabel *lbl6 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-30, 10, 100, 20)];
    lbl6.text = @"金额";
    lbl6.font = [UIFont systemFontOfSize:14];
    lbl6.textColor = UIColorFromRGB(0XAFAFAF);
    [view addSubview:lbl6];
    
    UILabel *lbl7 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 10, 85, 20)];
    lbl7.text = @"状态";
    lbl7.font = [UIFont systemFontOfSize:14];
    lbl7.textColor = UIColorFromRGB(0XAFAFAF);
    lbl7.textAlignment = NSTextAlignmentRight;
    [view addSubview:lbl7];
    
    
    UILabel *xianlbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    xianlbl.backgroundColor = UIColorFromRGB(0Xf2f2f2);
    [view addSubview:xianlbl];
    
    self.leftTableView.tableHeaderView=view;
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
@end
