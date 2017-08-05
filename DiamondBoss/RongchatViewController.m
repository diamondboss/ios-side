//
//  RongchatViewController.m
//  DiamondBoss
//
//  Created by wendf on 2017/6/12.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "RongchatViewController.h"
#import "MainViewController.h"
#import "IQKeyboardManager.h"
@interface RongchatViewController ()

@end

@implementation RongchatViewController
//-(void)viewWillAppear:(BOOL)animated
//{
//    self.navigationController.navigationBar.barTintColor = DMBSColor;
//    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//    [self.navigationController.navigationBar setTitleTextAttributes:dict];

//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(10, 5, 30, 30);
//    [btn setBackgroundImage:[UIImage imageNamed:@"grzx_ht"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(popTo) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem=back;
    
//}
- (void)popTo{
    MainViewController *con = [[MainViewController alloc]init];
     [IQKeyboardManager sharedManager].enable = YES;
    [self.navigationController pushViewController:con animated:NO];
}
//
- (void)viewDidLoad {
    [IQKeyboardManager sharedManager].enable = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
     [self notifyUpdateUnreadMessageCount];
}
//等待用户评价结束后调用如下函数离开当前VC。
- (void)leftBarButtonItemPressed:(id)sender {
    //需要调用super的实现
    [super leftBarButtonItemPressed:sender];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//评价客服，并离开当前会话
//如果您需要自定义客服评价界面，请把本函数注释掉，并打开“应用自定义评价界面开始1/2”到“应用自定义评价界面结束”部分的代码，然后根据您的需求进行修改。
//如果您需要去掉客服评价界面，请把本函数注释掉，并打开下面“应用去掉评价界面开始”到“应用去掉评价界面结束”部分的代码，然后根据您的需求进行修改。
- (void)commentCustomerServiceWithStatus:(RCCustomerServiceStatus)serviceStatus
                               commentId:(NSString *)commentId
                        quitAfterComment:(BOOL)isQuit {
    [super commentCustomerServiceWithStatus:serviceStatus
                                  commentId:commentId
                           quitAfterComment:isQuit];
}
- (void)notifyUpdateUnreadMessageCount {
    __weak typeof(&*self) __weakself = self;
    int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                @(ConversationType_PRIVATE),
                                                                @(ConversationType_DISCUSSION),
                                                                @(ConversationType_APPSERVICE),
                                                                @(ConversationType_PUBLICSERVICE),
                                                                @(ConversationType_GROUP)
                                                                ]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *backString = nil;
        if (count > 0 && count < 1000) {
            backString = [NSString stringWithFormat:@"返回(%d)", count];
        } else if (count >= 1000) {
            backString = @"返回(...)";
        } else {
            backString = @"返回";
        }
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 6, 87, 23);
        UIImageView *backImg = [[UIImageView alloc]
                                initWithImage:[UIImage imageNamed:@"grzx_ht"]];
        backImg.frame = CGRectMake(-10, 2, 20, 20);
        [backBtn addSubview:backImg];
        UILabel *backText =
        [[UILabel alloc] initWithFrame:CGRectMake(9, 4, 85, 17)];
        backText.text = backString; // NSLocalizedStringFromTable(@"Back",
        // @"RongCloudKit", nil);
        //   backText.font = [UIFont systemFontOfSize:17];
        [backText setBackgroundColor:[UIColor clearColor]];
        [backText setTextColor:[UIColor whiteColor]];
        [backBtn addSubview:backText];
        [backBtn addTarget:__weakself
                    action:@selector(popTo)
          forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftButton =
        [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        [__weakself.navigationItem setLeftBarButtonItem:leftButton];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
