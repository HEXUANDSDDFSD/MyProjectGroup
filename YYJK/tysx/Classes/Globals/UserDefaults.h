//
//  UserDefaults.h
//  tysx
//
//  Created by zwc on 14-4-2.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+ (UserDefaults*)sharedUserDefaults;

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *safeCode;
@property(nonatomic, copy) NSString *deviceToken;
@property(weak, nonatomic, readonly) NSString *password;
@property(nonatomic, weak, readwrite) NSString *lastProvinceDateStr;
@property(nonatomic, assign, readwrite) int lastProductDateTimestamp;
@property (nonatomic, assign) int lastTransformRateTimestamp;
@property (nonatomic, assign) int lastIPOrderAbnormalTimestamp;
@property (nonatomic, assign) int lastPlatDateTimestamp;
@property (nonatomic, assign) int lastSuccessRateTimestamp;

@property (assign, nonatomic) BOOL isRememberUserName;

@end
