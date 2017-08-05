//
//  UIView+fram.h
//  DiamondBoss
//
//  Created by wendf on 2017/6/21.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView_fram : UIView
- (CGFloat)originX;
- (CGFloat)originY;
- (CGPoint)origin;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;

- (void)setOriginX:(CGFloat)x;
- (void)setOriginY:(CGFloat)y;
- (void)setOrigin:(CGPoint)origin;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setSize:(CGSize)size;

@end
