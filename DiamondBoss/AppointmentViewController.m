//
//  AppointmentViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/7/20.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "AppointmentViewController.h"
#import "MainViewController.h"
#import "OnlinepayViewController.h"
#import "RongchatViewController.h"
#import "DBLoginViewController.h"
#import "THDatePickerView.h"
#import "EditAnimalSexSheet.h"
#import "EditAnimalAgeSheet.h"
#import "ChooseKindViewController.h"
#import "AgreeementViewController.h"
@interface AppointmentViewController ()<UITextFieldDelegate>
{
    UIView *changeTimeView;
    THDatePickerView *dateView;
    NSMutableDictionary *Mutabledict1;
    NSString *str;
    
    NSMutableArray *MutableAry;
    NSMutableDictionary *mutableDic;
}
@property (weak, nonatomic) IBOutlet UILabel *TrustAddressLbl;//托管地点
@property (weak, nonatomic) IBOutlet UILabel *TrustTimeLbl;//托管时间

@property (weak, nonatomic) IBOutlet UITextField *AnimalTextField;//宠物昵称
@property (weak, nonatomic) IBOutlet UITextField *AnimalSexTextfield;//宠物性别
@property (weak, nonatomic) IBOutlet UITextField *AnimalAgeTextField;//宠物年龄
@property (weak, nonatomic) IBOutlet UITextField *AnimalBreedTextField;//宠物品种
@property (weak, nonatomic) IBOutlet UITextField *NoteTextField;//备注

@property (weak, nonatomic) IBOutlet UIButton *chooseSexBtn;//选择性别Btn
@property (weak, nonatomic) IBOutlet UIButton *chooseBreedBtn;//选择品种Btn
@property (weak, nonatomic) IBOutlet UIButton *ChooseAgeBtn;//选择年龄Btn
@property (weak, nonatomic) IBOutlet UIButton *IsChooseDogFoodBtn;//选择携带狗粮
@property (weak, nonatomic) IBOutlet UIButton *NOChooseDogFoodBtn;//不携带狗粮按钮
@property (weak, nonatomic) IBOutlet UILabel *OrderPriceLbl;//订单价格Lbl
@property (weak, nonatomic) IBOutlet UIButton *AgreementBtn;//托管协议按钮
@property (weak, nonatomic) IBOutlet UIButton *changeTimeBtn;//修改时间按钮


@property (strong, nonatomic) NSString *AnimalsexStr;

//状态
@property (weak, nonatomic) IBOutlet UIImageView *animalNameImg;
@property (weak, nonatomic) IBOutlet UIImageView *seximg;
@property (weak, nonatomic) IBOutlet UIImageView *Breedimg;
@property (weak, nonatomic) IBOutlet UIImageView *ageimg;
@property (weak, nonatomic) IBOutlet UIImageView *rmarkimg;

@end

@implementation AppointmentViewController
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
        
        _OrderPriceLbl.text = [NSString stringWithFormat:@"%ld.00元",[mutableDic[[[NSUserDefaults standardUserDefaults]objectForKey:@"VARIETIES"]][_AnimalAgeTextField.text] integerValue]+5];
    }
}
- (void)popTo{
    MainViewController * buttonsView = [[MainViewController alloc]init];
    [self.navigationController pushViewController:buttonsView animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    Mutabledict1 = [NSMutableDictionary dictionary];
    [self buildbutton];
    self.title = @"预约登记";
    _changeTimeBtn.layer.masksToBounds = YES;
    _changeTimeBtn.layer.cornerRadius = 10;
    
    _AnimalTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"PETNAME"];//宠物昵称
    _AnimalSexTextfield.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"ANIMALSEX"];//宠物性别
    _AnimalAgeTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"PETAGE"];//宠物年龄
    _AnimalBreedTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"VARIETIES"];//宠物品种
    _NoteTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"REMARK"];//备注
//    _OrderPriceLbl.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"OrderPriceLbl"];//价格

    if (_ISBreed == 1) {
        _AnimalBreedTextField.text = _animalKindStr;
        [Mutabledict1 setObject:_animalKindStr forKey:@"varieties"];
    }
   
    [Mutabledict1 setObject:@"0" forKey:@"dogFood"];
    [_IsChooseDogFoodBtn setImage:[UIImage imageNamed:@"dindan_cuohao"] forState:UIControlStateNormal];
    [_NOChooseDogFoodBtn setImage:[UIImage imageNamed:@"dinddan_lvse"] forState:UIControlStateNormal];
    str = @"0.00元";
    
    
    if ([@"公" isEqualToString:_AnimalSexTextfield.text]) {
        [Mutabledict1 setObject:@"1" forKey:@"sex"];
    }else{
        [Mutabledict1 setObject:@"0" forKey:@"sex"];
    }
    
    
    NSDate * date = [NSDate date];//当前时间
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//后一天
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    NSString *strDate = [dateFormatter stringFromDate:nextDay];
    NSLog(@"%@", strDate);
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-MM-dd"];
    NSString *strDate1 = [dateFormatter2 stringFromDate:nextDay];

    
    _TrustTimeLbl.text = [NSString stringWithFormat:@"托管时间:%@/09:00-%@/18:00",strDate,strDate];
    [Mutabledict1 setObject:strDate1 forKey:@"orderDate"];
    [Mutabledict1 setObject:[NSString stringWithFormat:@"%@ 09:00",strDate] forKey:@"receiveTime"];
    [Mutabledict1 setObject:[NSString stringWithFormat:@"%@ 18:00",strDate] forKey:@"returnTime"];
    
    
    NSString *selectedCommuntyStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedCommunty"];
    _TrustAddressLbl.text = [NSString stringWithFormat:@"托管地点:%@",selectedCommuntyStr];

    
    _AnimalTextField.delegate = self;
    _NoteTextField.delegate = self;
    [_AnimalTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    _NoteTextField.tag = 4;
    [_NoteTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    if ([_NoteTextField.text  isEqual: @""]) {
        _rmarkimg.image = [UIImage imageNamed:@"dindan_hongse"];
    }
    if ([_AnimalTextField.text  isEqual: @""]) {
        _animalNameImg.image = [UIImage imageNamed:@"dindan_hongse"];
    }
    if ([_AnimalSexTextfield.text  isEqual: @""]) {
        _seximg.image = [UIImage imageNamed:@"dindan_hongse"];
    }
    if ([_AnimalBreedTextField.text  isEqual: @""]) {
        _Breedimg.image = [UIImage imageNamed:@"dindan_hongse"];
    }
    if ([_AnimalAgeTextField.text  isEqual: @""]) {
        _ageimg.image = [UIImage imageNamed:@"dindan_hongse"];
    }
}
#pragma mark 选择时间
- (IBAction)ChooseTime:(id)sender {
    changeTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    changeTimeView.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.5);
    dateView = [[THDatePickerView alloc] initWithFrame:CGRectMake(50, 200, kScreenWidth - 100, 300)];
    [changeTimeView addSubview:dateView];
    [self.view addSubview:changeTimeView];
    
    [dateView.cancleBtn addTarget:self action:@selector(cancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [dateView.nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
}
//取消
- (void)cancleBtn{
    [changeTimeView removeFromSuperview];
    [dateView removeFromSuperview];
}
//确定
- (void)nextBtn{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
//    NSString *strHour = [dateFormatter stringFromDate:date];
//    else if([dateView.orderTime isEqualToString:dateView.returnTime]||[dateView.orderhour integerValue] - [strHour integerValue] < 2){
//        [self shouSucessView:@"请选择两个小时后"];
//    }
    if (![dateView.orderTime isEqualToString:dateView.returnTime]) {
        [self shouSucessView:@"接送时间只能选择同一天，请重新选择"];
    }else  if ([dateView.returnhour integerValue]- [dateView.orderhour integerValue] < 2 ) {
        [self shouSucessView:@"间隔至少2小时，请重新选择时间"];
    }else {
        _TrustTimeLbl.text = @"";
        [changeTimeView removeFromSuperview];
        [dateView removeFromSuperview];
        _TrustTimeLbl.text = [NSString stringWithFormat:@"托管时间:%@-%@",dateView.sendTimeLbl.text,dateView.getTimeLbl.text];
        [_TrustTimeLbl reloadInputViews];
        
        [Mutabledict1 setObject:dateView.orderTime forKey:@"orderDate"];
        [Mutabledict1 setObject:dateView.sendTimeLbl.text forKey:@"receiveTime"];
        [Mutabledict1 setObject:dateView.getTimeLbl.text forKey:@"returnTime"];
    }
}

#pragma mark 选择性别
- (IBAction)ChooseSex:(id)sender {
    EditAnimalSexSheet *datesheet = [[EditAnimalSexSheet alloc] initWithFrame:self.view.bounds];
    datesheet.GetSelectDate = ^(NSString *dateStr) {
        _AnimalSexTextfield.text = dateStr;
        [[NSUserDefaults standardUserDefaults]setObject:dateStr forKey:@"ANIMALSEX"];
        if ([@"公" isEqualToString:dateStr]) {
            [Mutabledict1 setObject:@"1" forKey:@"sex"];
        }else{
            [Mutabledict1 setObject:@"0" forKey:@"sex"];
        }
    };
    [self.view addSubview:datesheet];
}
#pragma mark 选择品种
- (IBAction)chooseBreed:(id)sender {
    ChooseKindViewController *chooseVC = [[ChooseKindViewController alloc] init];
    chooseVC.IsChoose = 1;
    
    if (_ISAppoint == 1) {
        chooseVC.panterId = _panterId;
        chooseVC.panterName = _panterName;
        chooseVC.ISAppoint = _ISAppoint;
        
        chooseVC.GetSelectdataDict = ^(NSArray *ary){
            _panterId = ary[0];
            _panterName = ary[1];
            _ISAppoint = [ary[2] integerValue];
        };
    }else{
        chooseVC.ISAppoint = _ISAppoint;
        chooseVC.GetSelectdataDict = ^(NSArray *ary){
            _ISAppoint = [ary[0] integerValue];
        };
    }
    
    chooseVC.GetSelectKind = ^(NSString *animalKind) {
        NSLog(@"%@",animalKind);
        _AnimalBreedTextField.text = animalKind;
    };
    chooseVC.GetSelectDict = ^(NSDictionary *animalDict) {
        NSLog(@"%@",animalDict);
        _OrderPriceLbl.text = [NSString stringWithFormat:@"%@元",mutableDic[[[NSUserDefaults standardUserDefaults]objectForKey:@"VARIETIES"]][_AnimalAgeTextField.text]];
    };
   
    GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:chooseVC];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}
#pragma mark 选择年龄
- (IBAction)ChooseAge:(id)sender {
    EditAnimalAgeSheet *datesheet = [[EditAnimalAgeSheet alloc] initWithFrame:self.view.bounds];
    datesheet.GetSelectDate = ^(NSString *dateStr) {
        
        _AnimalAgeTextField.text = dateStr;
        if ([str isEqualToString:@"1"]) {
            _OrderPriceLbl.text = [NSString stringWithFormat:@"%@元",mutableDic[[[NSUserDefaults standardUserDefaults]objectForKey:@"VARIETIES"]][_AnimalAgeTextField.text]];
        }else{
            _OrderPriceLbl.text = [NSString stringWithFormat:@"%ld.00元",[mutableDic[[[NSUserDefaults standardUserDefaults]objectForKey:@"VARIETIES"]][_AnimalAgeTextField.text] integerValue]+5];
        }
//        [[NSUserDefaults standardUserDefaults]setObject:_OrderPriceLbl.text forKey:@"OrderPriceLbl"];//价格
        [Mutabledict1 setObject:dateStr forKey:@"age"];
        NSLog(@"%@",_OrderPriceLbl.text);
    };
    [self.view addSubview:datesheet];
}
#pragma mark 跳转协议
- (IBAction)GoToGreement:(id)sender {
    AgreeementViewController *Agreeemenvc = [[AgreeementViewController alloc]init];
    GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:Agreeemenvc];
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}
#pragma mark 选择携带狗粮
- (IBAction)ISAnimalFood:(id)sender {
    [Mutabledict1 setObject:@"1" forKey:@"dogFood"];
    [_IsChooseDogFoodBtn setImage:[UIImage imageNamed:@"dinddan_lvse"] forState:UIControlStateNormal];
    [_NOChooseDogFoodBtn setImage:[UIImage imageNamed:@"dindan_cuohao"] forState:UIControlStateNormal];
    str = [Mutabledict1 objectForKey:@"dogFood"];
    _OrderPriceLbl.text = [NSString stringWithFormat:@"%@元",mutableDic[[[NSUserDefaults standardUserDefaults]objectForKey:@"VARIETIES"]][_AnimalAgeTextField.text]];
}
#pragma mark 选择不携带狗粮
- (IBAction)NOAnimalFood:(id)sender {
    [Mutabledict1 setObject:@"0" forKey:@"dogFood"];
    [_IsChooseDogFoodBtn setImage:[UIImage imageNamed:@"dindan_cuohao"] forState:UIControlStateNormal];
    [_NOChooseDogFoodBtn setImage:[UIImage imageNamed:@"dinddan_lvse"] forState:UIControlStateNormal];
    str = [Mutabledict1 objectForKey:@"dogFood"];
    _OrderPriceLbl.text = [NSString stringWithFormat:@"%ld.00元",[mutableDic[[[NSUserDefaults standardUserDefaults]objectForKey:@"VARIETIES"]][_AnimalAgeTextField.text] integerValue]+5];
}

#pragma mark 下方咨询支付按钮
- (void)buildbutton{
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth/3, 44)];
    leftView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftView];
    
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/6 - 16, 0, 32, 32)];
    leftImg.image = [UIImage imageNamed:@"sy_zx"];
    [leftView addSubview:leftImg];
    
    UILabel *leftLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, kScreenWidth/3, 15)];
    leftLbl.text = @"咨询";
    leftLbl.textAlignment = NSTextAlignmentCenter;
    leftLbl.backgroundColor = [UIColor whiteColor];
    leftLbl.textColor = [UIColor lightGrayColor];
    leftLbl.font = [UIFont systemFontOfSize:11];
    [leftView addSubview:leftLbl];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth/3, 50)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn addTarget:self action:@selector(rongBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *reservationBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/3, kScreenHeight - 44, kScreenWidth*2/3, 44)];
    [reservationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reservationBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    reservationBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    reservationBtn.backgroundColor = DMBSColor;
    [reservationBtn addTarget:self action:@selector(boosucess) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:leftBtn];
    [self.view addSubview:reservationBtn];
}
- (void)boosucess{
    [Mutabledict1 setObject:_AnimalTextField.text forKey:@"petName"];
    [Mutabledict1 setObject:_NoteTextField.text forKey:@"remark"];
    [Mutabledict1 setObject:_AnimalAgeTextField.text forKey:@"age"];
    [Mutabledict1 setObject:_AnimalBreedTextField.text forKey:@"varieties"];

    if ([_TrustAddressLbl.text  isEqual: @""]) {
        [self shouSucessView:@"小区不能为空"];
    }else if ([_AnimalTextField.text  isEqual: @""]) {
        [self shouSucessView:@"请填写宠物昵称"];
    }else if ([_AnimalSexTextfield.text  isEqual: @""]) {
        [self shouSucessView:@"请选择性别"];
    }else if ([_AnimalBreedTextField.text  isEqual: @""]) {
        [self shouSucessView:@"请选择宠物品种"];
    }else if ([_AnimalAgeTextField.text  isEqual: @""]) {
        [self shouSucessView:@"请选择年龄"];
    }else{
        
        if (_ISAppoint == 1) {
            NSString *selectedCommuntyStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedCommunty"];
            NSDictionary *dict1 = nil;
            dict1 = @{@"communityName":selectedCommuntyStr};
            NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_QueryCommunityId];
            [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
                NSLog(@"post请求成功%@", response);
                NSDictionary *dic = nil;
                if ([response isKindOfClass:[NSData class]]) {
                    dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                }else{
                    dic = response;
                }
                if (response) {
                    if ([response[@"retnCode"] integerValue] == 1) {
                        [self shouSucessView:response[@"retnDesc"]];
                    }else{
                        [Mutabledict1 setObject:response[@"data"][@"communityId"] forKey:@"communityId"];
//                        OnlinepayViewController *OnlinePayvc = [[OnlinepayViewController alloc]init];
//                        OnlinePayvc.MuTabdic = Mutabledict1;
//                        OnlinePayvc.Orderpricce = _OrderPriceLbl.text;
//                        GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:OnlinePayvc];
//                        self.frostedViewController.contentViewController = navigationController;
//                        [self.frostedViewController hideMenuViewController];
                        OnlinepayViewController *OnlinePayvc = [[OnlinepayViewController alloc]init];
                        OnlinePayvc.IsAppoint = 1;
                        OnlinePayvc.PanterId = _panterId;
                        OnlinePayvc.PanterName = _panterName;
                        OnlinePayvc.MuTabdic = Mutabledict1;
                        OnlinePayvc.Orderpricce = _OrderPriceLbl.text;
                        GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:OnlinePayvc];
                        self.frostedViewController.contentViewController = navigationController;
                        [self.frostedViewController hideMenuViewController];
                    }
                }
            } fail:^(NSError *error) {
                
            }];
        }else{
            NSString *selectedCommuntyStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedCommunty"];
            NSDictionary *dict1 = nil;
            dict1 = @{@"communityName":selectedCommuntyStr};
            NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_QueryCommunityId];
            [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
                NSLog(@"post请求成功%@", response);
                NSDictionary *dic = nil;
                if ([response isKindOfClass:[NSData class]]) {
                    dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
                }else{
                    dic = response;
                }
                if (response) {
                    if ([response[@"retnCode"] integerValue] == 1) {
                        [self shouSucessView:response[@"retnDesc"]];
                    }else{
                        [Mutabledict1 setObject:response[@"data"][@"communityId"] forKey:@"communityId"];
                        OnlinepayViewController *OnlinePayvc = [[OnlinepayViewController alloc]init];
                        OnlinePayvc.MuTabdic = Mutabledict1;
                        OnlinePayvc.Orderpricce = _OrderPriceLbl.text;
                        GlobalNavigationController *navigationController = [[GlobalNavigationController alloc] initWithRootViewController:OnlinePayvc];
                        self.frostedViewController.contentViewController = navigationController;
                        [self.frostedViewController hideMenuViewController];
                    }
                }
            } fail:^(NSError *error) {
                
            }];
        }
    }
}
- (void)rongBtn{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"token"]) {
        //  chatService.csInfo = csInfo; //用户的详细信息，此数据用于上传用户信息到客服后台，数据的nickName和portraitUrl必须填写。(目前该字段暂时没用到，客服后台显示的用户信息是你获取token时传的参数，之后会用到）
        RongchatViewController *chatService = [[RongchatViewController alloc] init];
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = @"KEFU149663440586772";
        chatService.title = @"客服";
        //  chatService.csInfo = csInfo; //用户的详细信息，此数据用于上传用户信息到客服后台，数据的nickName和portraitUrl必须填写。(目前该字段暂时没用到，客服后台显示的用户信息是你获取token时传的参数，之后会用到）
        [self.navigationController pushViewController :chatService animated:YES];
        
    }else{
        DBLoginViewController *loginVC = [[DBLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            [Mutabledict1 setObject:_AnimalTextField.text forKey:@"petName"];
            [[NSUserDefaults standardUserDefaults]setObject:_AnimalTextField.text forKey:@"PETNAME"];
            break;
        case 4:
            [Mutabledict1 setObject:_NoteTextField.text forKey:@"remark"];
            [[NSUserDefaults standardUserDefaults]setObject:_NoteTextField.text forKey:@"REMARK"];
            break;
        default:
            break;
    }
}
- (void)shouSucessView:(NSString *)str{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

@end
