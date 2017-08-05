//
//  EditAnimalAgeSheet.h
//  DiamondBoss
//
//  Created by wendf on 2017/7/18.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAnimalAgeSheet : UIActionSheet

@property (nonatomic, copy) void(^GetSelectDate)(NSString *dateStr);
@property (copy, nonatomic) NSString *AnimalAgeStr; //选中日
@property (nonatomic) NSInteger IsChoose;//是否需要请求

@end
