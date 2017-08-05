//
//  NetInterface.h
//  DiamondBoss
//
//  Created by bonday012 on 17/4/7.
//  Copyright © 2017年 bonday012. All rights reserved.


#ifndef NetInterface_h
#define NetInterface_h
//0 合伙人   1 用户   2 没登录  3 预约成功
#define PHONENUBER @"PHONENUBER"

//根URL  生产环境
#define KDmbsBaseUrl  @"http://182.92.82.60:8080/pet"
//根URL  测试环境
//#define KDmbsBaseUrl  @"http://182.92.149.119:8080/pet"

//根URL  博文本地
//#define KDmbsBaseUrl  @"http://192.168.2.141:8080/pet"
//根URL  志方本地
//#define KDmbsBaseUrl  @"http://192.168.2.232:8080/pet"
//根URL  志方小米本地
//#define KDmbsBaseUrl  @"http://192.168.2.234:8080/pet"
//24小时都可以用
//#define KDmbsBaseUrl  @"http://182.92.149.119:8080/pet"

//OSS服务器Url
#define KPictureUrl @"http://zfxue-test.oss-cn-shanghai.aliyuncs.com"
//OSS服务器  合伙人  id
#define KPicturePartner @"/partner/avatar/"
//OSS服务器  用户  id
#define KPictureUserUrl @"/user/avatar/"

//获取融云Token
#define KLogin_RongToken @"/rongyun/smsSendOfToken"
//获取验证码   参数：phone
#define KMain_Login @"/login/sendVerify"
//首页下方用户弹框
#define KMain_LoginInit @"/login/userLoginInit"
//查询合伙人接单信息   参数：partnerId
#define KMain_PartnerOrder @"/queryOrder/PartnerOrder"
//首页-根据小区名字查询该小区所有的合伙人
#define KMain_QueryPartnerOfCommunityList @"/partner/queryPartnerOfCommunityList"

//查询用户资料 userId 用户Id
#define KMain_LeftQueryInfo @"/userInfo/queryInfo"
//查询宠物资料 userId 用户Id
#define KMain_LeftQueryPetInfo @"/petInfo/queryPetInfo"
//修改用户资料
#define KMain_LeftUpdateInfo @"/userInfo/updateInfo"
//修改宠物资料
#define KMain_LeftUpdatePetInfo @"/petInfo/updatePetInfo"
//用户反馈 userId 用户Id   phoneNum  context 反馈内容
#define KMain_LeftuserFeedBack @"/userOther/userFeedBack"
//用户订单 userId 用户Id
#define KMain_LeftUserOrderList @"/queryOrder/userOrderList"
//用户下单-指定合伙人
#define KMain_Appoint @"/placeOrder/appoint"
//用户下单支付宝-不指定合伙人
#define KMain_Random @"/placeOrder/random"
//用户下单支付宝-传后台支付宝接口
#define KMain_CheckAliPayResult @"/app/ali/checkAliPayResult"
//用户下单微信-不指定合伙人
#define KMain_RandomWXPay @"/placeOrder/randomWXPay"
//用户下单微信-指定合伙人
#define KMain_AppointWXPay @"/placeOrder/appointWXPay"
//微信-后台查询接口  参数：outTradeNo
#define KMain_CheckWXPayResult @"/app/wxPay/checkWXPayResult"

//根据小区名字查id   communityName
#define KMain_QueryCommunityId @"/community/queryCommunityId"


//查询合伙人资料  partnerId
#define KMain_LeftPartnerQueryInfo @"/partner/queryInfo"
//合伙人抢单查询接口  partnerId
#define KMain_panterqueryOrder @"/grabOrder/queryOrder"
//合伙人抢单接口  partnerId
#define KMain_PanterGrabOrder @"/grabOrder/grabOrder"
//合伙人订单 partnerId
#define KMain_LeftPartnerOrderList @"/queryOrder/partnerOrderList"
//合伙人首页信息     partnerId
#define KMain_PanterMessage @"/queryOrder/partnerHomePage"
//合伙人首页钱包余额 partnerId
#define KMain_PartnerWallet @"/partnerWithdrawals/querySummaryInfo"
//合伙人首页确认接收 partnerId  userId  outTradeNo
#define KMain_Receive @"/confirmOrder/receive"
//合伙人首页确认送达 partnerId  userId  outTradeNo
#define KMain_GiveBack @"/confirmOrder/giveBack"

//钱包提现记录（3个）查询   partnerId
#define KLeft_QueryDetailed @"/partnerWithdrawals/queryDetailed"
//钱包提现金额查询   partnerId
#define KLeft_QuerySummaryInfo @"/partnerWithdrawals/querySummaryInfo"
//钱包历史查询   partnerId
#define KLeft_QueryTotalDetailed @"/partnerWithdrawals/queryTotalDetailed"
//钱包提现   partnerId     value
#define KLeft_Withdrawals @"/partnerWithdrawals/withdrawals"


//首页合伙人，预约未知数量-- 参数：communityId  ：3000003
#define KMain_ParterNum @"/queryOrder/queryInfo"
//首页立即预、。约 --- 参数;  petId   100001
#define KMain_Reservation @"/submitOrder/queryOrder"
//首页地图图片返回 ---- 参数：communityId  ：3000003
//#define KMain_MapImg @"/queryOrder/queryCommMap"
//首页选择小区
#define KMain_CommunityMessage @"/community/queryCommunity"

//预约成功，订单实时查询 userId=1  orderDate=2016-06-06
#define KMain_UserOrder @"/queryOrder/userOrder"
//登录接口  retnCode 是 0 是登录成功，跳转主界面   phoneNumber 17602120056 是合伙人
#define KLogin @"/login/login"

//左控制器 编辑查询按钮 参数：手机号
#define KLeft_EditSearch @"/userBase/query";
//phoneNum 电话号
//name 昵称
//====以下非必须传，可以穿空字符串
//age 年龄
//sex 性别
//address 地址
//remark 备注
//年龄 只能为2位数字
//性别 只能是 男/女
#define KLeft_EditMessage @"/userBase/edit"


#endif /* NetInterface_h */
