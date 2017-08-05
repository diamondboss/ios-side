//
//  HistorymesageViewController.m
//  DiamondBoss
//
//  Created by edz on 2017/5/11.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "HistorymesageViewController.h"
#import "MessageTableViewCell.h"
#import "MainViewController.h"
@interface HistorymesageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mesageTableView;
@property (nonatomic,strong) NSArray *timeArr;
@property (nonatomic,strong) NSArray *moneyArr;

@end

@implementation HistorymesageViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KLeft_UserRow];
//    NSDictionary *dict = nil;
//    dict = @{@"parterId":@"3000004"};
//    [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
//        NSLog(@"post请求成功%@", response);
//        NSDictionary *dic = nil;
//        _timeArr = [NSArray array];
//        if ([response isKindOfClass:[NSData class]]) {
//            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
//        }else{
//            dic = response;
//        }
//        if (response) {
//           _timeArr = dic[@"data"];
//            [self creatUItableview];
//        }
//        [self.mesageTableView reloadData];
//    } fail:^(NSError *error) {
//        
//    }];

    self.navigationController.navigationBar.barTintColor = DMBSColor;
    NSDictionary *dct = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:dct];
    
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息记录";
}
- (void)creatUItableview{
    _mesageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    [_mesageTableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageTableViewCell"];
    _mesageTableView.delegate = self;
    _mesageTableView.dataSource = self;
    _mesageTableView.backgroundColor = UIColorRGB(237, 237, 237);
    _mesageTableView.separatorStyle = NO;
    [self.view addSubview:_mesageTableView];
}

#pragma mark - tableView的协议方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _timeArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell" forIndexPath:indexPath];
    cell.timelbl.text = [NSString stringWithFormat:@"%@",_timeArr[indexPath.row][@"orderTime"]];
//    cell.moneyLbl.text = _timeArr[indexPath.row][@"createTime"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
