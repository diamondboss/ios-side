//
//  OnlinepayViewController.h
//  DiamondBoss
//
//  Created by wendf on 2017/6/24.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlinepayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *entureOnlineBtn;//确定支付按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseZhifubaoBtn;//支付宝Btn
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;//微信Btn
@property (weak, nonatomic) IBOutlet UILabel *TimeLbl;//支付剩余时间
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@property (nonatomic, copy) NSString *PanterId;//指定合伙人id
@property (nonatomic, copy) NSString *PanterName;
@property (nonatomic) NSInteger IsAppoint;//是否制定合伙人

@property (nonatomic, strong)NSMutableDictionary *MuTabdic;
@property (nonatomic,copy) NSString *Orderpricce;
@end
