//
//  NSTimer+Addition.h
//  DiamondBoss
//
//  Created by wendf on 2017/6/18.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)
- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;
@end
