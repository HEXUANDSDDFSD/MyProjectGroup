//
//  TYSXMonitorCtr.h
//  tysx
//
//  Created by zwc on 14/11/29.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "NetworkBase.h"

#define kDateKey @"date"
#define kTrafficKey @"traffic"
#define kOrderKey @"order"
#define kUnSubScribeKey @"unSubScribe"
#define kChannelKey @"channel"
#define kLoginKey @"login"
#define kLoginTimesKey @"loginTimes"
#define kTongbiNumKey @"tongBiN"
#define kHuanbiNumKey @"huanBiN"
#define kStatusKey @"status"

@interface TYSXMonitorCtr : NetworkBase

@property (nonatomic, readonly) NSDictionary *monitorInfo;

@end
