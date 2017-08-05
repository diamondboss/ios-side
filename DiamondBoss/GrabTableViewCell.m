
//
//  GrabTableViewCell.m
//  DiamondBoss
//
//  Created by wendf on 2017/6/20.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "GrabTableViewCell.h"

@implementation GrabTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backImg.layer.masksToBounds = YES;
    self.backImg.layer.cornerRadius = 5;
    
    self.backview.layer.masksToBounds = YES;
    self.backview.layer.cornerRadius = 5;

    
    self.grablbl.layer.masksToBounds = YES;
//    self.grablbl.layer.cornerRadius = 5;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.grablbl.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = self.grablbl.bounds;
    layer.path = maskPath.CGPath;
    self.grablbl.layer.mask = layer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
