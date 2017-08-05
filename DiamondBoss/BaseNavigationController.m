//
//  BaseNavigationController.m
//  ZZQTableBarObjc
//
//  Created by jsmysoft on 15/8/12.
//  Copyright (c) 2015年 jsmysoft. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.appearance方法返回一个导航栏的外观对象
    // 修改了这个外观对象，相当于修改了整个项目中的外观
    UINavigationBar *bar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
    bar.translucent = NO;//去掉导航上的一层阴影
    [bar setBarTintColor:DMBSColor];
    
    // 3.设置导航栏文字的主题
    [bar setTitleTextAttributes:@{
                                  NSFontAttributeName:[UIFont systemFontOfSize:17],
                                  NSForegroundColorAttributeName:[UIColor whiteColor]
                                  }];
    //3. 添加右滑手势
    //[self addSwipeRecognizer];
}
//#pragma mark 添加右滑手势
//- (void)addSwipeRecognizer
//{
//    UIScreenEdgePanGestureRecognizer* screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(action:)];
//    screenEdgePan.edges = UIRectEdgeLeft;
//    [self.view addGestureRecognizer:screenEdgePan];
//}
//#pragma mark 返回上一级
//- (void)backshangyiji
//{
//    // 最低控制器无需返回
//    if (self.viewControllers.count <= 1) return;
//    // pop返回上一级
//    [self popViewControllerAnimated:YES];
//    
//}
//-(void)action:(UIScreenEdgePanGestureRecognizer*)sender{
//    if (sender.edges == UIRectEdgeLeft) {
//        NSLog(@"正在从左边滑动");
//        switch (sender.state) {
//            case UIGestureRecognizerStateBegan:
//                NSLog(@"手势开始");
//                break;
//            case UIGestureRecognizerStateChanged:
//                NSLog(@"手势进行中");
//                break;
//            case UIGestureRecognizerStateEnded:
//                [self backshangyiji];
//                break;
//                
//            default:
//                break;
//        }
//        
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
