//
//  Define.h
//  DiamondBoss
//
//  Created by bonday012 on 17/4/7.
//  Copyright © 2017年 bonday012. All rights reserved.
//

#ifndef Define_h
#define Define_h

#import "NetInterface.h"

//获取屏幕大小
#define kScreenSize [UIScreen mainScreen].bounds.size
#define DEFAULTS [NSUserDefaults standardUserDefaults]

// 加载图片的宏（这种方式加载图片没有缓存）（推荐使用）
#define LOADIMAGE(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
// 这种方式加载图片会缓存图片
#define LOADIMAGE_NAME(name) [UIImage imageNamed:name]
//这里还可以定义全局方法
#define notNil(string) (string ? string : @"")
//调试代码
//#ifdef DEBUG
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...)
//#endif
#ifdef DEBUG
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif


//获取当前的系统的语言
#define CURR_LANG ([[NSLocale preferredLanguages] objectAtIndex:0])
#define LanguageIsEnglish ([CURR_LANG isEqualToString:@"en-US"] || [CURR_LANG isEqualToString:@"en-CA"] || [CURR_LANG isEqualToString:@"en-GB"] || [CURR_LANG isEqualToString:@"en-CN"] || [CURR_LANG isEqualToString:@"en"])


#pragma mark 获取当前屏幕的宽度、高度
//宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark 定义常用的颜色
#define  DMBSColor UIColorFromRGB(0x86C532)
#define  kCommenColor_whiteColor [UIColor whiteColor]
// 3.获得RGB颜色
#define UIColorRGB(r, g, b) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])
#define UIColorRGBT(r, g, b ,t) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:t])

// 4.二进制颜色(16进制－10进制)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark 字体相关
//字体
#define UIFont_size(size) [UIFont systemFontOfSize:size]
#define UIFont_bold_Size(size) [UIFont boldSystemFontOfSize:size]

#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#pragma mark - 通知名称
#pragma mark - 本地存储及移除
#define XGUserDefaultsSetValueForKey(value, key) [[NSUserDefaults standardUserDefaults] setValue:value forKey:key]
#define XGUserDefaultsRemoveValueForKey(key)     [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define XGUserDefaultsValueForKey(key)           [[NSUserDefaults standardUserDefaults] valueForKey:key]


#endif /* Define_h */
