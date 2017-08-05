//
//  WithDrawViewController.h
//  DiamondBoss
//
//  Created by wendf on 2017/7/31.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithDrawViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *moneyLbl;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic,copy)NSString *priceStr;
@end
