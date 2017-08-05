//
//  MessageTableViewCell.m
//  DiamondBoss
//
//  Created by wendf on 2017/5/22.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
