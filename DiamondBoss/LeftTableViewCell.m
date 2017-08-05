//
//  LeftTableViewCell.m
//  DiamondBoss
//
//  Created by edz on 2017/5/11.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headimg.layer.masksToBounds = YES;
    self.headimg.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
