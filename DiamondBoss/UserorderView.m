//
//  UserorderView.m
//  DiamondBoss
//
//  Created by wendf on 2017/6/24.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "UserorderView.h"

@implementation UserorderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.petImg.layer.masksToBounds = YES;
    self.petImg.layer.cornerRadius = 30;
}
@end
