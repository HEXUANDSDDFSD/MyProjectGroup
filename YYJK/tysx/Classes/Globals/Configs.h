//
//  Configs.h
//  tysx
//
//  Created by zwc on 13-6-27.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "UserDefaults.h"
#import <UIKit/UIKit.h>

#ifndef tysx_Configs_h
#define tysx_Configs_h

#define SCREEN_SIZE   [[UIScreen mainScreen] bounds].size
#define ISPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define ISPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen]currentMode].size) : NO)

#define VIEW_FRAME (ISPAD?CGRectMake(0,0,1024,768):(ISPHONE5?CGRectMake(0,0,568,320):CGRectMake(0,0,480,320)))

#define FILE_PRODUCTS @"products"

#define FOOTER_HEIGHT (ISPAD?80.:40.)
#define PAGECONTROL_ORIGN_Y (ISPAD?80:)

#define kScreenHeight ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)

#define KCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0]

#define kTYSXServerUrl @"192.168.39.141:8081"
//#define kTYSXServerUrl @"192.168.1.106:8088"

#define kTestServerUrl @"192.168.1.104:8088"

#define kDefaultServerUrl @"61.152.221.136:8085"

#define kNeedVirtualData 1

//#define kDatabasePath @"/Users/royal/Desktop/chart.data"
#define kDatabasePath   [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"chart.data"]
#define kVersionValue [[UIDevice currentDevice].systemVersion doubleValue]

// 测试使用
#define USE_SPLASH_VIEW (0)
#define USE_LOGIN_PWD (0)

#define kFreshGreenColor [UIColor colorWithRed:144 / 255.0 green:215 / 255.0 blue:13 / 255.0 alpha:1]
#define kFreshBlueColor [UIColor colorWithRed:104 / 255.0 green:184 / 255.0 blue:220 / 255.0 alpha:1]
#define kFreshYellowColor [UIColor colorWithRed:218 / 255.0 green:174 / 255.0 blue:41 / 255.0 alpha:1]

#define kDefaultTextColor [UIColor colorWithHexString:@"#F5F5F5"]

#define USER_DFT [UserDefaults sharedUserDefaults]

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define has_network 1

#endif
