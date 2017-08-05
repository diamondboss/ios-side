//
//  ChooseKindViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/7/20.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "ChooseKindViewController.h"
#import "AnnimalmessageViewController.h"
#import "AppointmentViewController.h"
@interface ChooseKindViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *MutableAry;
    NSMutableDictionary *mutableDic;
    UITableView *mytableView;
}
@end

@implementation ChooseKindViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    AnnimalmessageViewController *animal = [[AnnimalmessageViewController alloc]init];
    [self.navigationController pushViewController:animal animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    self.title = @"选择宠物品种";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUItableview];
    
    if (_ISAppoint == 1) {
        NSArray *dataary = nil;
        dataary = @[_panterId,_panterName,[NSString stringWithFormat:@"%ld",_ISAppoint]];
        _GetSelectdataDict(dataary);
    }else{
        NSArray *dataary = nil;
        dataary = @[[NSString stringWithFormat:@"%ld",_ISAppoint]];
        _GetSelectdataDict(dataary);
    }
    
}
- (void)loadData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AnimalPlist" ofType:@"plist"];
    NSMutableDictionary *data2 = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSLog(@"%@",data2);
    
    NSArray* arr = [data2 allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    NSLog(@"%@",arr);
    
    MutableAry = [NSMutableArray array];
    mutableDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < arr.count; i ++) {
        NSArray* ary = [[data2 objectForKey:arr[i]] allKeys];
        ary = [ary sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2];
            return result==NSOrderedDescending;
        }];
        [MutableAry addObjectsFromArray:ary];
        
        NSDictionary *dict = [data2 objectForKey:arr[i]];
        [mutableDic addEntriesFromDictionary:dict];
        
//        ary = [ary sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
//            NSComparisonResult result = [obj1 compare:obj2];
//            return result==NSOrderedDescending;
//        }];
//        [MutableAry addObjectsFromArray:ary];
    }
}

- (void)creatUItableview{
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [mytableView registerNib:[UINib nibWithNibName:@"WalletTableViewCell" bundle:nil] forCellReuseIdentifier:@"WalletTableViewCell"];
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.backgroundColor = [UIColor whiteColor];
    mytableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:mytableView];
}

#pragma mark - tableView的协议方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MutableAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    cell.backgroundColor = [UIColor whiteColor];
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    cell.textLabel.text = MutableAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.GetSelectKind) {
        _GetSelectKind(MutableAry[indexPath.row]);
        _GetSelectDict([mutableDic objectForKey:MutableAry[indexPath.row]]);
        [[NSUserDefaults standardUserDefaults]setObject:MutableAry[indexPath.row] forKey:@"VARIETIES"];

        if (_IsChoose == 1) {
            AppointmentViewController *animal = [[AppointmentViewController alloc]init];
            animal.ISBreed = 1;
            animal.animalKindStr = MutableAry[indexPath.row];
            [self.navigationController pushViewController:animal animated:NO];
        }else{
            NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KMain_LeftUpdatePetInfo];
            NSDictionary *dict = nil;
            dict = @{@"userId":[NSString stringWithFormat:@"%@",_dic[@"userId"]],@"name":_dic[@"name"],@"age":[NSString stringWithFormat:@"%@",_dic[@"age"]],@"sex":[NSString stringWithFormat:@"%@",_dic[@"sex"]],@"varieties":MutableAry[indexPath.row]};
            [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
                NSLog(@"post请求成功%@", response);
                NSDictionary *dic = nil;
                if ([response isKindOfClass:[NSData class]]) {
                    dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                }else{
                    dic = response;
                }
                if (response) {
                    AnnimalmessageViewController *animal = [[AnnimalmessageViewController alloc]init];
                    [self.navigationController pushViewController:animal animated:NO];
                }
            } fail:^(NSError *error) {
                
            }];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_IsChoose == 1) {
        AppointmentViewController *animal = [[AppointmentViewController alloc]init];
        [self.navigationController pushViewController:animal animated:NO];
    }
}
@end
