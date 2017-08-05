//
//  THDatePickerView.h
//  rongyp-company
//
//  Created by Apple on 2016/11/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THDatePickerViewDelegate <NSObject>

/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer;

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate;

@end

@interface THDatePickerView : UIView

@property (copy, nonatomic) NSString *title;
@property (weak, nonatomic) id <THDatePickerViewDelegate> delegate;

/// 显示
- (void)show;

@property (nonatomic,strong) UIButton *cancleBtn;//取消
@property (nonatomic,strong) UIButton *nextBtn;//下一步

@property (strong, nonatomic) UILabel *sendTimeLbl; // 送出时间
@property (strong, nonatomic) UILabel *getTimeLbl; // 接回时间
@property (copy, nonatomic) NSString *orderTime;//订单时间
@property (copy, nonatomic) NSString *returnTime;//订单时间
@property (copy, nonatomic) NSString *orderhour;//订单时间
@property (copy, nonatomic) NSString *returnhour;//订单时间

@end
