//
//  AnnimalmessageViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/6/21.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "AnnimalmessageViewController.h"
#import "EditPersonViewController.h"
#import "EditTableViewCell.h"
#import "MainViewController.h"
#import "ChnageAnimalViewController.h"
#import "EditAnimalAgeSheet.h"
#import "EditAnimalSexSheet.h"
#import "ChooseKindViewController.h"
@interface AnnimalmessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (strong, nonatomic) NSArray *dataAry;
@property (strong, nonatomic) NSArray *dataAry1;
@property (strong, nonatomic) NSArray *dataAry2;
@property (strong, nonatomic) NSArray *dataAry3;
@property (strong, nonatomic) NSArray *dataAry4;
@property (strong, nonatomic) NSString *photoUrl;
@property (strong, nonatomic) NSDictionary *PetMessageDic;

@property (weak, nonatomic) IBOutlet UILabel *lblShowBirth;

@end

@implementation AnnimalmessageViewController
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
    EditPersonViewController *con = [[EditPersonViewController alloc]init];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"宠物资料";
    self.view.backgroundColor = UIColorRGB(237, 237, 237);

    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    NSDictionary *dict = nil;
    dict = @{@"UserId":str};
    NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KMain_LeftQueryPetInfo];
    [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            _PetMessageDic = [NSDictionary dictionary];
            _PetMessageDic = response[@"data"];
            _dataAry = @[@"宠物名字",@"宠物年龄"];
            _dataAry3 = @[response[@"data"][@"name"],response[@"data"][@"age"]];
            _dataAry2 = @[@"宠物品种",@"性别"];
            if ([response[@"data"][@"sex"] intValue] == 1) {
                _dataAry4 = @[response[@"data"][@"varieties"],@"公"];
            }else{
                _dataAry4 = @[response[@"data"][@"varieties"],@"母"];
            }
            [self creatUITable];
        }
    } fail:^(NSError *error) {
        
    }];

}
- (void)creatUITable{
    //半透明条(导航条/tabBar) 对滚动视图的影响
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth , kScreenHeight - 50)];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.showsVerticalScrollIndicator =NO;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = UIColorRGB(237, 237, 237);
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"EditTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditTableViewCell"];
    [self.view addSubview:self.myTableView];
}
#pragma mark - tableView的协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 10)];
    [headerView setBackgroundColor:UIColorRGB(237, 237, 237)];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTableViewCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLbl.text = _dataAry[indexPath.row];
        cell.edituserlbl.text = _dataAry3[indexPath.row];
        return cell;
    }else {
        EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTableViewCell" forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLbl.text = _dataAry2[indexPath.row];
        cell.edituserlbl.text = _dataAry4[indexPath.row];
        return cell;
    }
}
#pragma mark 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //填写昵称
            ChnageAnimalViewController *changeVC =[[ChnageAnimalViewController alloc]init];
            changeVC.animalName = @"宠物名字";
            changeVC.dic = _PetMessageDic;
            GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:changeVC];
            self.frostedViewController.contentViewController = navigationController;
            [self.frostedViewController hideMenuViewController];
        }
        if (indexPath.row == 1) {
            EditAnimalAgeSheet *datesheet = [[EditAnimalAgeSheet alloc] initWithFrame:self.view.bounds];
            datesheet.GetSelectDate = ^(NSString *dateStr) {
                [self chooseAgeBtn:dateStr];
            };
            [self.view addSubview:datesheet];
            [self.myTableView reloadData];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ChooseKindViewController *chooseVC = [[ChooseKindViewController alloc] init];
            chooseVC.GetSelectKind = ^(NSString *animalKind) {
                NSLog(@"%@",animalKind);
            };
            chooseVC.GetSelectDict = ^(NSDictionary *animalDict) {
                NSLog(@"%@",animalDict);
            };
            chooseVC.GetSelectdataDict = ^(NSArray *ary){

            };
            chooseVC.dic = _PetMessageDic;
            GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:chooseVC];
            self.frostedViewController.contentViewController = navigationController;
            [self.frostedViewController hideMenuViewController];
            [self.myTableView reloadData];
        }
        if (indexPath.row == 1){
            EditAnimalSexSheet *datesheet = [[EditAnimalSexSheet alloc] initWithFrame:self.view.bounds];
            datesheet.GetSelectDate = ^(NSString *dateStr) {
                if ([dateStr isEqualToString:@"公"]){
                    dateStr = @"1";
                }else{
                    dateStr = @"0";
                }
                [self chooseAgeBtn1:dateStr];
            };
            [self.view addSubview:datesheet];
            [self.myTableView reloadData];
        }
    }
}
- (void)chooseAgeBtn:(NSString *)str{
    
    NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KMain_LeftUpdatePetInfo];
    NSDictionary *dict = nil;
    
    dict = @{@"userId":[NSString stringWithFormat:@"%@",_PetMessageDic[@"userId"]],@"name":_PetMessageDic[@"name"],@"age":str,@"sex":[NSString stringWithFormat:@"%@",_PetMessageDic[@"sex"]],@"varieties":_PetMessageDic[@"varieties"]};
    
    [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            
            AnnimalmessageViewController *annimal = [[AnnimalmessageViewController alloc]init];
            [self.navigationController pushViewController:annimal animated:NO];
        }
    } fail:^(NSError *error) {

    }];
}
- (void)chooseAgeBtn1:(NSString *)str{
    NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KMain_LeftUpdatePetInfo];
    NSDictionary *dict = nil;
    
    dict = @{@"userId":[NSString stringWithFormat:@"%@",_PetMessageDic[@"userId"]],@"name":_PetMessageDic[@"name"],@"age":_PetMessageDic[@"age"],@"sex":str,@"varieties":_PetMessageDic[@"varieties"]};
    
    [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            
            AnnimalmessageViewController *annimal = [[AnnimalmessageViewController alloc]init];
            [self.navigationController pushViewController:annimal animated:NO];
        }
    } fail:^(NSError *error) {
        
    }];
}

@end
