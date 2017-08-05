//
//  EditPersonSexSheet.h
//  DiamondBoss
//
//  Created by wendf on 2017/7/18.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPersonSexSheet : UIActionSheet

@property (nonatomic, copy) void(^GetSelectDate)(NSString *dateStr);
@property (copy, nonatomic) NSString *sexStr; //选中日

@end
