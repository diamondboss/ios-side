//
//  pantermessageView.h
//  DiamondBoss
//
//  Created by wendf on 2017/6/23.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pantermessageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *panterNamelbl;//合伙人姓名
@property (weak, nonatomic) IBOutlet UILabel *TGnumLbl;//托管位置
@property (weak, nonatomic) IBOutlet UILabel *JDNumLbl;//接单数量
@property (weak, nonatomic) IBOutlet UIButton *OrderBtn;//预约
@property (weak, nonatomic) IBOutlet UIButton *CallBtn;//打电话

@property (weak, nonatomic) IBOutlet UIImageView *userImg;

@end
