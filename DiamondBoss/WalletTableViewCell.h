//
//  WalletTableViewCell.h
//  DiamondBoss
//
//  Created by wendf on 2017/5/23.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftlbl;//时间
@property (weak, nonatomic) IBOutlet UILabel *rightlbl;//钱
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;//状态
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;//时间
@property (weak, nonatomic) IBOutlet UILabel *gatarylbl;//申请提现



@end
