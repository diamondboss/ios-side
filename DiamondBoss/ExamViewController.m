//
//  ExampleViewController.m
//  SegmentView
//
//  Created by tom.sun on 16/5/27.
//  Copyright © 2016年 tom.sun. All rights reserved.
//

#import "ExamViewController.h"
#import "UIView+frame.h"
#import "GrabTableViewCell.h"
#import "PanterOrderViewController.h"
#import "UserOrderViewController.h"
@interface ExamViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *dict1;
}
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) NSArray *ary1;
@property (nonatomic, strong) NSArray *ary2;
@property (nonatomic, strong) NSArray *ary3;
@property (nonatomic, strong) NSArray *Allary;
@property (nonatomic, copy) NSString *urlString1;
@end

@implementation ExamViewController
- (instancetype)initWithIndex:(NSInteger)index title:(NSString *)title
{
    self = [super init];
    if (self) {
        _titleStr = title;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _dic = [NSDictionary dictionary];
    _ary1 = [NSArray array];
    _ary2 = [NSArray array];
    _ary3 = [NSArray array];
    _Allary = [NSArray array];
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    NSString *str1 = [[NSUserDefaults standardUserDefaults ]objectForKey:@"isuser"];
    dict1 = nil;
    if ([str1 isEqualToString:@"1"]) {
        dict1 = @{@"partnerId":str};
        _urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_LeftPartnerOrderList];
    }else{
        dict1 = @{@"userId":str};
        _urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_LeftUserOrderList];
    }
    [HYBNetworking postWithUrl:_urlString1 refreshCache:YES params:dict1 success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            _dic = response[@"data"];
            _ary1 = _dic[@"underway"];
            _ary2 = _dic[@"canceled"];
            _ary3 = _dic[@"finish"];
            if ([_titleStr isEqualToString:@"正在进行"]) {
                _Allary = _ary1;
            }
            if ([_titleStr isEqualToString:@"已经取消"]) {
                _Allary = _ary2;
            }
            if ([_titleStr isEqualToString:@"已经完成"]) {
                _Allary = _ary3;
            }
            [self setupUI];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupUI
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.height = tableView.height - 50;
    [tableView registerNib:[UINib nibWithNibName:@"GrabTableViewCell" bundle:nil] forCellReuseIdentifier:@"GrabTableViewCell"];
    tableView.backgroundColor = UIColorFromRGB(0Xf2f2f2);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    if (_Allary.count == 0) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 42, (kScreenHeight-64)/2 - 63 - 64, 83, 126)];
        img.image = [UIImage imageNamed:@"grabimg"];
        [self.view addSubview:img];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, (kScreenHeight-64)/2, kScreenWidth, 20)];
        lbl.text = @"暂无任何信息";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:13];
        lbl.textColor = UIColorFromRGB(0x979797);
        
        [self.view addSubview:lbl];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _Allary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GrabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GrabTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
    if ([_titleStr isEqualToString:@"正在进行"]) {
        cell.grablbl.text = @"已支付";
    }
    if ([_titleStr isEqualToString:@"已经取消"]) {
        cell.grablbl.text = @"已取消";
    }
    if ([_titleStr isEqualToString:@"已经完成"]) {
        cell.grablbl.text = @"已完成";
    }
    NSString *str1 = [[NSUserDefaults standardUserDefaults ]objectForKey:@"isuser"];
    dict1 = nil;
    if ([str1 isEqualToString:@"1"]) {
        NSString *string = _Allary[indexPath.row][@"id"];
        NSArray *array = [string componentsSeparatedByString:@"sy"];//字符串按照【分隔成数组
        cell.OrderLbl.text = [array objectAtIndex:array.count - 1];
    }else{
        cell.OrderLbl.text = _Allary[indexPath.row][@"id"];
    }

    cell.sendTimeLbl.text = _Allary[indexPath.row][@"receiveTime"];
    cell.OrderMoneylbl.text = _Allary[indexPath.row][@"amt"];
    cell.getTimeLbl.text = _Allary[indexPath.row][@"returnTime"];
    cell.downLbl.text = _Allary[indexPath.row][@"partnerName"];
    return cell;
}
//"underway":
//[
// {
//     "id": "13",
//     "receiveTime": "07:00",
//     "returnTime": "19:20",
//     "amt": "19.99",
//     "partnerName": "订单异常,客服处理中",
//     "orderStatus": "3",
//     "sex": "1",
//     "age": "1",
//     "varieties": "边牧",
//     "remark": "安静、乖",
//     "orderDate": "2017-06-25",
//     "createTime": "2017-06-25 14:25:44.0"
// },
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str1 = [[NSUserDefaults standardUserDefaults ]objectForKey:@"isuser"];
    dict1 = nil;
    if ([str1 isEqualToString:@"1"]) {
        PanterOrderViewController *graddetailvc = [[PanterOrderViewController alloc]init];
        graddetailvc.OrderDic = _Allary[indexPath.row];
        graddetailvc.pushstatus = 1;
        GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:graddetailvc];
        self.frostedViewController.contentViewController = navigationController;
        [self.frostedViewController hideMenuViewController];
        
    }else{
        if ([_titleStr isEqualToString:@"已经取消"]) {

        }else{
            UserOrderViewController *graddetailvc = [[UserOrderViewController alloc]init];
            graddetailvc.OrderDic = _Allary[indexPath.row];
            GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:graddetailvc];
            self.frostedViewController.contentViewController = navigationController;
            [self.frostedViewController hideMenuViewController];
        }
        
    }


}

@end
