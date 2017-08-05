//
//  ChooseKindViewController.h
//  DiamondBoss
//
//  Created by wendf on 2017/7/20.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseKindViewController : UIViewController

@property (nonatomic, copy) void(^GetSelectKind)(NSString *dateStr);
@property (nonatomic, copy) void(^GetSelectDict)(NSDictionary *animalDict);
@property (nonatomic, copy) void(^GetSelectdataDict)(NSArray *ary);

@property (nonatomic, copy) NSString *panterId;//指定合伙人id
@property (nonatomic, copy) NSString *panterName;//指定合伙人id
@property (nonatomic) NSInteger ISAppoint;//是否制定合伙人

@property (nonatomic,strong) NSDictionary *dic;

@property (nonatomic) NSInteger IsChoose;//是否需要请求

@end
