//
//  MainTableViewCell2.m
//  DiamondBoss
//
//  Created by edz on 2017/5/10.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import "MainTableViewCell2.h"

@implementation MainTableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    //Initialization code
    self.enterReturnBtn.layer.masksToBounds = YES;
    self.enterReturnBtn.layer.cornerRadius = 2;
}
- (void)showUserMessageDataWithModel:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    self.geitimelbl.text = [NSString stringWithFormat:@"%@ --- %@",dic[@"receiveTime"],dic[@"returnTime"]];
    self.animallbl.text = dic[@"userName"];
    if ([dic[@"sex"] isEqualToString:@"0"]) {
        self.agelbl.text = [NSString stringWithFormat:@"%@/%@岁/母狗",dic[@"varieties"],dic[@"age"]];
    }else{
        self.agelbl.text = [NSString stringWithFormat:@"%@/%@岁/公狗",dic[@"varieties"],dic[@"age"]];
    }
    self.usenamelbl.text = dic[@"petName"];
    self.beizhu.text = dic[@"remark"];
    NSString *urlString = [KPictureUrl stringByAppendingString:KPictureUserUrl];
    [_PicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg",urlString,dic[@"userId"]]] placeholderImage:[UIImage imageNamed:@"IMAGe-2"] completed:nil];
    //4是未接宠
    if ([dic[@"orderStatus"] integerValue] == 4) {
        [_enterReturnBtn setTitle:@"确认接到" forState:UIControlStateNormal];
    }
    //5是已接到
    if ([dic[@"orderStatus"] integerValue] == 5) {
        [_enterReturnBtn setTitle:@"确认送还" forState:UIControlStateNormal];
        _enterReturnBtn.backgroundColor = UIColorFromRGB(0XF6A623);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
