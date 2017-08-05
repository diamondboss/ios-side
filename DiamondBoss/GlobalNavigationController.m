//
//  GlobalNavigationController.m
//  CaoCaoKuaiDi
//
//  Created by goofygao on 16/2/27.
//  Copyright © 2016年 goofyy. All rights reserved.
//

#import "GlobalNavigationController.h"
#import "UIBarButtonItem+GFBarButtonItem.h"
#import "REFrostedViewController.h"
#import "MainViewController.h"

@interface GlobalNavigationController () <UINavigationControllerDelegate>

@property (nonatomic,strong) id popGestureRecognizerDelegate;

@end

@implementation GlobalNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
//    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma delegate
//-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (viewController == self.viewControllers[0]) {
//        self.interactivePopGestureRecognizer.delegate =_popGestureRecognizerDelegate;
//    } else {
//        _popGestureRecognizerDelegate = self.interactivePopGestureRecognizer.delegate;
//        self.interactivePopGestureRecognizer.delegate = nil;
//        
//    }
//}
//



#pragma action

-(void)backToPre {
    [self popViewControllerAnimated:NO];
}


- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController panGestureRecognized:sender];
}

- (void)popToRoot {
    //    [self pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>]
    [self pushViewController:[MainViewController new] animated:NO];
}

@end
