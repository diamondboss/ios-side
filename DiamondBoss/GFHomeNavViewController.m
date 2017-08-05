//
//  GFHomeNavViewController.m
//  CaoCaoKuaiDi
//
//  Created by goofygao on 16/3/13.
//  Copyright © 2016年 goofyy. All rights reserved.
//

#import "GFHomeNavViewController.h"
#import "REFrostedViewController.h"
#import "MainViewController.h"
#import "UIBarButtonItem+GFBarButtonItem.h"
#pragma mark 定义常用的颜色
#define  DMBSColor UIColorFromRGB(0x86C532)
// 4.二进制颜色(16进制－10进制)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface GFHomeNavViewController ()

@end

@implementation GFHomeNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)showMenu
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
    
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"%s",__func__);
    if (self.viewControllers.count != 0) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"iconfont-dianjicichufanhui"] highImage:[UIImage imageNamed:@"iconfont-dianjicichufanhui"] target:self action:@selector(backToMainMenu) forControlEvents:UIControlEventTouchDown];
        
    }
    [super pushViewController:viewController animated:animated];
}

-(void)backToMainMenu {
    [self popToRootViewControllerAnimated:YES];
}


-(void)popToRoot {
    [self pushViewController:[MainViewController new] animated:YES];
}
@end
