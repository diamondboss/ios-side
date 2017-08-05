//
//  FeedBackViewController.m
//  DiamondBoss
//
//  Created by edz on 2017/5/11.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "FeedBackViewController.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"
@interface FeedBackViewController ()<UITextViewDelegate>
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *ensureBtn;
@property (strong, nonatomic) UILabel *lb;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation FeedBackViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    self.view.backgroundColor = UIColorRGB(237, 237, 237);
    self.title = @"意见反馈";
    [self builUI];
}
- (void)builUI{
     _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 150)];
    _textView.delegate = self;
    _textView.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_textView];
    
    _lb = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, 300, 30)];
    _lb.text = @"您有什么不爽的统统告诉我们吧！";
    _lb.textColor = UIColorRGB(237, 237, 237);
    _lb.font = [UIFont systemFontOfSize:13];
    _lb.enabled = NO;
    [_textView addSubview:_lb];
    
//    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 215, kScreenWidth , 35)];
//    _textField.placeholder = @"   手机号或者微信号，以便我及时联系";
//    _textField.font = [UIFont systemFontOfSize:14];
//    _textField.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_textField];
    
    _ensureBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 250,kScreenWidth -20, 35)];
    _ensureBtn.backgroundColor = DMBSColor;
    _ensureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_ensureBtn setTitle:@"提交意见" forState:UIControlStateNormal];
    _ensureBtn.layer.masksToBounds = YES;
    _ensureBtn.layer.cornerRadius = 5;
    [_ensureBtn addTarget:self action:@selector(tijiao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ensureBtn];
}
- (void)tijiao{
    if (_textView.text.length == 0) {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }else{
        //合伙人首页
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
        NSString *PhoneStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"PhoneNumber"];
        NSDictionary *dict1 = nil;
        dict1 = @{@"UserId":str,@"phone":PhoneStr,@"feedback":_textView.text};
        NSString *urlString1 = [KDmbsBaseUrl stringByAppendingString:KMain_LeftuserFeedBack];
        [HYBNetworking postWithUrl:urlString1 refreshCache:YES params:dict1 success:^(id response) {
            NSLog(@"post请求成功%@", response);
            NSDictionary *dic = nil;
            if ([response isKindOfClass:[NSData class]]) {
                dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
            }else{
                dic = response;
            }
            if (response) {
                //初始化提示框；
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"我们已经收到，谢谢您的反馈" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    MainViewController *con = [[MainViewController alloc]init];
                    [self.navigationController pushViewController:con animated:NO];
                }]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            }
        } fail:^(NSError *error) {
            
        }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.lb.alpha = 0;//开始编辑时
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
        self.lb.alpha = 1;
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
