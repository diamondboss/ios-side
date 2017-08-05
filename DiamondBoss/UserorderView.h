//
//  UserorderView.h
//  DiamondBoss
//
//  Created by wendf on 2017/6/24.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserorderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *PetNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLbl;//送宠物时间
@property (weak, nonatomic) IBOutlet UILabel *getTimeLbl;//接宠物时间
@property (weak, nonatomic) IBOutlet UILabel *OrderNumLbl;//定单数
@property (weak, nonatomic) IBOutlet UIImageView *petImg;//
@property (weak, nonatomic) IBOutlet UIButton *cancalBtn;//取消订单
@property (weak, nonatomic) IBOutlet UIButton *CallBtn;//拨打电话
@property (weak, nonatomic) IBOutlet UIButton *moreOderBtn;//更多订单


@end
