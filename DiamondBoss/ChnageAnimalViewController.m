//
//  ChnageAnimalViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/6/21.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "ChnageAnimalViewController.h"
#import "AnnimalmessageViewController.h"
@interface ChnageAnimalViewController ()
{
    UITextField *tefield;
}
@end

@implementation ChnageAnimalViewController

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
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(kScreenWidth - 60, 5, 40, 30);
    [btn1 setTitle:@"保存" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(popTo1) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back1=[[UIBarButtonItem alloc]initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem=back1;
}
- (void)popTo{
    AnnimalmessageViewController *annimal = [[AnnimalmessageViewController alloc]init];
    [self.navigationController pushViewController:annimal animated:YES];
}
- (void)popTo1{
    NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KMain_LeftUpdatePetInfo];
    NSDictionary *dict = nil;
    dict = _dic;
    if ([tefield.text isEqualToString:@""]) {
        [self shouSucessView:@"您还没有填写信息"];
    }else if ([_animalName isEqualToString:@"宠物品种"]) {
        int i = [self convertToInt:tefield.text];
        if (i >= 32) {
            [self shouSucessView:@"宠物品种字符过长"];
        }else{
             dict = @{@"userId":[NSString stringWithFormat:@"%@",_dic[@"userId"]],@"name":_dic[@"name"],@"age":[NSString stringWithFormat:@"%@",_dic[@"age"]],@"sex":[NSString stringWithFormat:@"%@",_dic[@"sex"]],@"varieties":tefield.text};
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
                    [self.navigationController pushViewController:annimal animated:YES];
                }
            } fail:^(NSError *error) {
                
            }];

        }
    }else if ([_animalName isEqualToString:@"宠物名字"]) {
        int i = [self convertToInt:tefield.text];
        if (i >= 12) {
            [self shouSucessView:@"宠物名字字符过长"];
        }else{
             dict = @{@"userId":[NSString stringWithFormat:@"%@",_dic[@"userId"]],@"name":tefield.text,@"age":[NSString stringWithFormat:@"%@",_dic[@"age"]],@"sex":[NSString stringWithFormat:@"%@",_dic[@"sex"]],@"varieties":_dic[@"varieties"]};
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
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"修改%@",_animalName];
    self.view.backgroundColor = UIColorRGB(245, 245, 245);
    [self buildUI];
}
- (void)buildUI{
    tefield = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, kScreenWidth - 40, 40)];
    tefield.placeholder = [NSString stringWithFormat:@"请输入您的昵称%@",_animalName];
    [tefield setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    [self.view addSubview:tefield];
    
    if ([_animalName isEqualToString:@"年龄"]) {
        tefield.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (void)shouSucessView:(NSString *)str{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}
@end
