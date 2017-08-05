//
//  UIView+Frame.h
//  navigationBar渐变
//
//  Created by 李小光 on 16/8/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;
@property (nonatomic, assign)CGSize size;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable UIColor *borderColor;
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 *  水平居中
 */
- (void)alignHorizontal;
/**
 *  垂直居中
 */
- (void)alignVertical;
/**
 *  判断是否显示在主窗口上面
 *
 *  @return 是否
 */
- (BOOL)isShowOnWindow;
- (UIViewController *)parentController;

//
//宽度
-(CGFloat)current_w;

//高度
-(CGFloat)current_h;

//当前view.frame的x、y、x+宽、y+高

-(CGFloat)current_x;
-(CGFloat)current_y;
-(CGFloat)current_x_w;
-(CGFloat)current_y_h;

@end
