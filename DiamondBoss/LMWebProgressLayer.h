//
//  LMWebProgressLayer.h
//  DiamondBoss
//
//  Created by wendf on 2017/6/18.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface LMWebProgressLayer : CAShapeLayer
- (void)finishedLoad;
- (void)startLoad;

- (void)closeTimer;
@end
