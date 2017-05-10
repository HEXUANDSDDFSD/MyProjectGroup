//
//  TYSXMonitorCtr.m
//  tysx
//
//  Created by zwc on 14/11/29.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXMonitorCtr.h"

@implementation TYSXMonitorCtr {
    NSDictionary *_monitorInfo;
}

- (id)init {
    if (self = [super init]) {
        NSDate *lastDate = [NSDate dateWithTimeIntervalSinceNow:-24 * 3600];
        _monitorInfo = [NSDictionary dictionaryWithContentsOfFile:[self cachePath]];
        if (_monitorInfo == nil) {
            _monitorInfo = @{kDateKey: stringWithDate(lastDate),
                             kLoginKey:@{kStatusKey:@"normal", kTongbiNumKey:@0,kHuanbiNumKey:@0},
                             kUnSubScribeKey:@{kStatusKey:@"normal", kTongbiNumKey:@0,kHuanbiNumKey:@0},
                             kOrderKey:@{kStatusKey:@"normal", kTongbiNumKey:@0,kHuanbiNumKey:@0},
                             kChannelKey:@{kStatusKey:@"normal", kLoginTimesKey:@0},
                             kTrafficKey:@{kStatusKey:@"normal", kTongbiNumKey:@0,kHuanbiNumKey:@0}};
        }
    }
    return self;
}

- (NSDictionary *)monitorInfo {
    return _monitorInfo;
}

- (NSString *)cachePath {
    return [KCachePath stringByAppendingPathComponent:@"monitor_info"];
}

+ (NSString *)path {
    return @"/warnApp";
}

- (NSString *)lastDateStr {
      NSDate *lastDate = [NSDate dateWithTimeIntervalSinceNow:-24 * 3600];
    return stringWithDate(lastDate);
}

- (NSDictionary *)configParams {
    return @{@"date":[self lastDateStr], @"dataType":@20};
}

- (void)successWithResponse:(id)responseObject {
    if ([responseObject count] != 0){
        NSDictionary *warnInfo = responseObject[0];
        NSMutableDictionary *saveWarnInfo = [NSMutableDictionary dictionary];
        [saveWarnInfo setValue:[self lastDateStr] forKey:kDateKey];
        NSArray *keyList = @[kLoginKey, kChannelKey, kOrderKey, kUnSubScribeKey, kTrafficKey];
        for (int i = 0; i < [keyList count]; i++) {
            NSDictionary *keyInfo = warnInfo[keyList[i]][0];
            if (i == 1) {
                [saveWarnInfo setValue:@{kStatusKey:keyInfo[kStatusKey], kLoginTimesKey:keyInfo[kLoginTimesKey]} forKey:keyList[i]];
            }
            else {
                [saveWarnInfo setValue:@{kStatusKey:keyInfo[kStatusKey], kTongbiNumKey:keyInfo[kTongbiNumKey], kHuanbiNumKey:keyInfo[kHuanbiNumKey]} forKey:keyList[i]];
            }
        }
        _monitorInfo = [saveWarnInfo copy];
        [saveWarnInfo writeToFile:[self cachePath] atomically:YES];
    }
}

@end
