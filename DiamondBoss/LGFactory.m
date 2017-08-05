//
//  LGFactory.m
//  UITest
//
//  Created by bonday012 on 16/9/6.
//  Copyright © 2016年 bonday012. All rights reserved.
//

#import "LGFactory.h"

@implementation LGFactory
#pragma mark - button
+(UIButton *)btnWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor bColor:(UIColor *)bColor titlefont:(CGFloat)titlefont target:(id)target sel:(SEL)sel{
    //创建一个btn
    UIButton * oneBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    oneBtn.frame=frame;
    [oneBtn setTitle:title forState:UIControlStateNormal];
    [oneBtn setTitleColor:titleColor forState:UIControlStateNormal];
    oneBtn.backgroundColor=bColor;
    oneBtn.titleLabel.font = [UIFont systemFontOfSize:titlefont];
    [oneBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return oneBtn;
}
+(UIButton *)btnWithtitle:(NSString *)title titleColor:(UIColor *)titleColor bColor:(UIColor *)bColor titlefont:(CGFloat)titlefont target:(id)target sel:(SEL)sel{
    //创建一个btn
    UIButton * oneBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [oneBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [oneBtn setTitle:title forState:UIControlStateNormal];
    oneBtn.backgroundColor=bColor;
    oneBtn.titleLabel.font = [UIFont systemFontOfSize:titlefont];
    [oneBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return oneBtn;
}
#pragma mark - Uilabel
+(UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor labelfont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment{
    UILabel *oneLabel = [[UILabel alloc]initWithFrame:frame];
    oneLabel.text = title;
    oneLabel.textColor = textColor;
    oneLabel.font = [UIFont systemFontOfSize:font];
    oneLabel.textAlignment = textAlignment;
    return oneLabel;
}
+(UILabel *)labelWithtitle:(NSString *)title textColor:(UIColor *)textColor labelfont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment{
    UILabel *oneLabel = [[UILabel alloc]init];
    oneLabel.text = title;
    oneLabel.textColor = textColor;
    oneLabel.font = [UIFont systemFontOfSize:font];
    oneLabel.textAlignment = textAlignment;
    return oneLabel;
}
#pragma mark - UIImageView
+(UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName bColor:(UIColor *)bColor contentMode:(UIViewContentMode)contentMode cornerRadius:(CGFloat)cornerRadius userInteractionEnabled:(BOOL)userInteractionEnabled target:(id)target sel:(SEL)sel{
    UIImageView *oneImageView = [[UIImageView alloc]initWithFrame:frame];
    oneImageView.image = [UIImage imageNamed:imageName];
    oneImageView.backgroundColor = bColor;
    oneImageView.contentMode = contentMode;
    oneImageView.layer.masksToBounds = YES;
    oneImageView.layer.cornerRadius = cornerRadius;
    oneImageView.userInteractionEnabled = userInteractionEnabled;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:sel];
    [oneImageView addGestureRecognizer:gesture];
    return oneImageView;
}
+(UIImageView *)imageViewWithimageName:(NSString *)imageName bColor:(UIColor *)bColor contentMode:(UIViewContentMode)contentMode cornerRadius:(CGFloat)cornerRadius userInteractionEnabled:(BOOL)userInteractionEnabled target:(id)target sel:(SEL)sel{
    UIImageView *oneImageView = [[UIImageView alloc]init];
    oneImageView.image = [UIImage imageNamed:imageName];
    oneImageView.backgroundColor = bColor;
    oneImageView.contentMode = contentMode;
    oneImageView.layer.masksToBounds = YES;
    oneImageView.layer.cornerRadius = cornerRadius;
    oneImageView.userInteractionEnabled = userInteractionEnabled;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:sel];
    [oneImageView addGestureRecognizer:gesture];
    return oneImageView;
}
#pragma mark -UITextField
/*
 UIKeyboardTypeDecimalPad //数字键盘
 UIKeyboardTypeEmailAddress  //邮箱键盘
 UIKeyboardTypeNumbersAndPunctuation//系统的数字键盘
 UIKeyboardTypeURL //url键盘
 
 */
+(UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder textColor:(UIColor *)textColor bColor:(UIColor *)bColor keyboardType:(UIKeyboardType)keyboardType textfont:(CGFloat)textfont{
    UITextField *oneTextField = [[UITextField alloc]initWithFrame:frame];
    oneTextField.placeholder = placeholder;
    oneTextField.textColor = textColor;
    oneTextField.backgroundColor = bColor;
    oneTextField.keyboardType = keyboardType;
    oneTextField.font = [UIFont systemFontOfSize:textfont];
    return oneTextField;
}
+(UITextField *)textFieldWithplaceholder:(NSString *)placeholder textColor:(UIColor *)textColor bColor:(UIColor *)bColor keyboardType:(UIKeyboardType)keyboardType textfont:(CGFloat)textfont{
    UITextField *oneTextField = [[UITextField alloc]init];
    oneTextField.placeholder = placeholder;
    oneTextField.textColor = textColor;
    oneTextField.backgroundColor = bColor;
    oneTextField.keyboardType = keyboardType;
    oneTextField.font = [UIFont systemFontOfSize:textfont];
    return oneTextField;
}

@end
