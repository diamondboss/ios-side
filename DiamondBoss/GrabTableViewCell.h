//
//  GrabTableViewCell.h
//  DiamondBoss
//
//  Created by wendf on 2017/6/20.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrabTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *grablbl;//抢单状态
@property (weak, nonatomic) IBOutlet UILabel *OrderLbl;//订单编号
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLbl;//送宠时间
@property (weak, nonatomic) IBOutlet UILabel *OrderMoneylbl;//订单价格
@property (weak, nonatomic) IBOutlet UILabel *getTimeLbl;//接宠物时间
@property (weak, nonatomic) IBOutlet UILabel *downLbl;//下方派单人

@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;



@end
