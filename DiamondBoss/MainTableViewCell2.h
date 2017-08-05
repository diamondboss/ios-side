//
//  MainTableViewCell2.h
//  DiamondBoss
//
//  Created by edz on 2017/5/10.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *callphoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *geitimelbl;//接收时间
@property (weak, nonatomic) IBOutlet UIImageView *PicImage;//用户头像
@property (weak, nonatomic) IBOutlet UILabel *animallbl;//用户姓名
@property (weak, nonatomic) IBOutlet UILabel *usenamelbl;//宠物姓名
@property (weak, nonatomic) IBOutlet UILabel *beizhu;//备注
@property (weak, nonatomic) IBOutlet UILabel *agelbl;//宠物品种年龄公
@property (weak, nonatomic) IBOutlet UIButton *enterReturnBtn;//确认接收送还按钮

- (void)showUserMessageDataWithModel:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath;


@end
