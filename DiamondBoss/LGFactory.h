//
//  LGFactory.h
//  UITest
//
//  Created by bonday012 on 16/9/6.
//  Copyright © 2016年 bonday012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LGFactory : NSObject
//UIButton
+(UIButton *)btnWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor bColor:(UIColor *)bColor titlefont:(CGFloat)titlefont target:(id)target sel:(SEL)sel;
+(UIButton *)btnWithtitle:(NSString *)title titleColor:(UIColor *)titleColor bColor:(UIColor *)bColor titlefont:(CGFloat)titlefont target:(id)target sel:(SEL)sel;
//UILabel
+(UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor labelfont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment;
+(UILabel *)labelWithtitle:(NSString *)title textColor:(UIColor *)textColor labelfont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment;
//UIImageView
+(UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName bColor:(UIColor *)bColor contentMode:(UIViewContentMode)contentMode cornerRadius:(CGFloat)cornerRadius userInteractionEnabled:(BOOL)userInteractionEnabled target:(id)target sel:(SEL)sel;
+(UIImageView *)imageViewWithimageName:(NSString *)imageName bColor:(UIColor *)bColor contentMode:(UIViewContentMode)contentMode cornerRadius:(CGFloat)cornerRadius userInteractionEnabled:(BOOL)userInteractionEnabled target:(id)target sel:(SEL)sel;
//UITextField
+(UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder textColor:(UIColor *)textColor bColor:(UIColor *)bColor keyboardType:(UIKeyboardType)keyboardType textfont:(CGFloat)textfont;
+(UITextField *)textFieldWithplaceholder:(NSString *)placeholder textColor:(UIColor *)textColor bColor:(UIColor *)bColor keyboardType:(UIKeyboardType)keyboardType textfont:(CGFloat)textfont;


@end
