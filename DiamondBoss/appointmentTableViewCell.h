//
//  appointmentTableViewCell.h
//  DiamondBoss
//
//  Created by wendf on 17/5/19.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface appointmentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headlabel;
@property (weak, nonatomic) IBOutlet UIImageView *isTureImg;


- (void)showDataAppointmentWithModel:(NSArray *)ary indexPath:(NSIndexPath *)indexPath;

@end
