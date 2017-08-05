//
//  AppointmentViewController.h
//  DiamondBoss
//
//  Created by wendf on 2017/7/20.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentViewController : UIViewController

@property (nonatomic, copy) NSString *panterId;//指定合伙人id
@property (nonatomic, copy) NSString *panterName;//指定合伙人id
@property (nonatomic) NSInteger ISAppoint;//是否制定合伙人
//@property (nonatomic , strong) NSDictionary *dateDic;
@property (nonatomic) NSInteger ISBreed;//是否品种

//@property (nonatomic , strong) NSDictionary *animalKindDict;
@property (nonatomic , strong) NSString *animalKindStr;

@end
