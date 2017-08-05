//
//  ChangeViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/6/21.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "ChangeViewController.h"
#import "EditPersonViewController.h"
@interface ChangeViewController ()
{
    UITextField *tefield;
}
@end

@implementation ChangeViewController
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
    EditPersonViewController *edit = [[EditPersonViewController alloc]init];
    [self.navigationController pushViewController:edit animated:YES];
}
- (void)popTo1{
//    userId 	string 	是 	用户Id
//    name 	string 	是 	姓名
//    phoneNumber 	string 	是 	手机号
//    age 	string 	是 	年龄
//    sex 	string 	是 	性别
//    address 	string 	是 	地址
//    industry 	string 	是 	行业
//    remark 	string 	是 	备注
    if ([tefield.text isEqualToString:@""]) {
        [self shouSucessView:@"您还没有填写信息"];
    }else if ([_name isEqualToString:@"昵称"]) {
        int i = [self convertToInt:tefield.text];
        if (i >= 12) {
            [self shouSucessView:@"用户名字字符过长"];
        }else{
            [self popUseMessage];
        }
    }else if ([_name isEqualToString:@"住址"]) {
        int i = [self convertToInt:tefield.text];
        if (i >= 60) {
            [self shouSucessView:@"住址字符过长"];
        }else{
            [self popUseMessage];
        }
    }else if ([_name isEqualToString:@"行业"]) {
        int i = [self convertToInt:tefield.text];
        if (i >= 40) {
            [self shouSucessView:@"行业字符过长"];
        }else{
            [self popUseMessage];
        }
    }else if([_name isEqualToString:@"备注"]){
        int i = [self convertToInt:tefield.text];
        if (i >= 80) {
            [self shouSucessView:@"宠物名字字符过长"];
        }else{
            [self popUseMessage];
        }
    }
}
- (void)popUseMessage{
    NSString *urlString = [KDmbsBaseUrl stringByAppendingString:KMain_LeftUpdateInfo];
    NSDictionary *dict = nil;
    dict = _dic;
    if ([_name isEqualToString:@"昵称"]) {
        dict = @{@"userId":[NSString stringWithFormat:@"%@",_dic[@"userId"]],@"phoneNumber":[NSString stringWithFormat:@"%@",_dic[@"phoneNumber"]],@"name":tefield.text,@"age":[NSString stringWithFormat:@"%@",_dic[@"age"]],@"sex":[NSString stringWithFormat:@"%@",_dic[@"sex"]],@"address":_dic[@"address"],@"industry":_dic[@"industry"],@"remark":_dic[@"remark"]};
    }
    if ([_name isEqualToString:@"住址"]) {
        dict = @{@"userId":[NSString stringWithFormat:@"%@",_dic[@"userId"]],@"phoneNumber":[NSString stringWithFormat:@"%@",_dic[@"phoneNumber"]],@"name":_dic[@"name"],@"age":[NSString stringWithFormat:@"%@",_dic[@"age"]],@"sex":[NSString stringWithFormat:@"%@",_dic[@"sex"]],@"address":tefield.text,@"industry":_dic[@"industry"],@"remark":_dic[@"remark"]};
    }
    if ([_name isEqualToString:@"行业"]) {
        dict = @{@"userId":[NSString stringWithFormat:@"%@",_dic[@"userId"]],@"phoneNumber":[NSString stringWithFormat:@"%@",_dic[@"phoneNumber"]],@"name":_dic[@"name"],@"age":[NSString stringWithFormat:@"%@",_dic[@"age"]],@"sex":[NSString stringWithFormat:@"%@",_dic[@"sex"]],@"address":_dic[@"address"],@"industry":tefield.text,@"remark":_dic[@"remark"]};
    }
    if ([_name isEqualToString:@"备注"]) {
        dict = @{@"userId":[NSString stringWithFormat:@"%@",_dic[@"userId"]],@"phoneNumber":[NSString stringWithFormat:@"%@",_dic[@"phoneNumber"]],@"name":_dic[@"name"],@"age":[NSString stringWithFormat:@"%@",_dic[@"age"]],@"sex":[NSString stringWithFormat:@"%@",_dic[@"sex"]],@"address":_dic[@"address"],@"industry":_dic[@"industry"],@"remark":tefield.text};
    }
    
    
    [HYBNetworking postWithUrl:urlString refreshCache:YES params:dict success:^(id response) {
        NSLog(@"post请求成功%@", response);
        NSDictionary *dic = nil;
        if ([response isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        }else{
            dic = response;
        }
        if (response) {
            EditPersonViewController *edit = [[EditPersonViewController alloc]init];
            [self.navigationController pushViewController:edit animated:NO];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"修改%@",_name];
    self.view.backgroundColor = UIColorRGB(245, 245, 245);
    [self buildUI];
}
- (void)buildUI{
    tefield = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, kScreenWidth - 40, 40)];
    tefield.placeholder = [NSString stringWithFormat:@"请输入您的%@",_name];
    [tefield setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    if ([_name isEqualToString:@"年龄"]) {
        tefield.keyboardType = UIKeyboardTypeNumberPad;
    }
    [self.view addSubview:tefield];
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
