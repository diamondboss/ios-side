//
//  LZMobilePayManager.h
//  GoldeneyeFrame
//
//  Created by goldeneye on 2017/6/6.
//  Copyright © 2017年 ZZgoldeneye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
//定义支付返回类型
typedef enum : NSUInteger {
    PaySuccessHandle, //支付成功
    PayFailedHandle,  //支付失败
    PayCancleHandle,  //取消支付
} PayCompltedHandle;

@interface LZMobilePayManager : NSObject
//单利
+ (LZMobilePayManager *)shareInstance;

/************ 微信支付 ****************/
/*
 * 微信支付
 * orderTitle 订单title
 * orderId    订单编号
 * orderPrice 订单价格
 * compltedHandle 操作完成回掉函数
 *
 */
- (void)wechatPayOrderTitle:(NSString *)orderTitle orderNumber:(NSString *)orderNumber orderPrice:(NSString *)orderPrice compltedHandle:(void (^)(PayCompltedHandle handel))compltedHandle;
//调用支付类回掉函数
@property(nonatomic,copy)void (^PayCompltedHandleBlock)(PayCompltedHandle handel);



@end
