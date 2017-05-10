//
//  UserDefaults.m
//  tysx
//
//  Created by zwc on 14-4-2.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "UserDefaults.h"
#import "NSString+Encryption.h"
#import "SynthesizeSingleton.h"

#define kUserName @"kUserName"
#define kSafeCode @"kSafeCode"
#define kPassword @"kPassword"
#define kDeviceToken @"kDeviceToken"

#define kIsRememberUserName @"kIsRememberUserName"
#define kLastProvinceShowDateStr @"kLastProvinceShowDateStr"
#define kLastProductShowDateStr @"kLastProductShowDateStr"

#define kLastProductDateTimestamp @"LastProductDateTimestamp"
#define kLastTransformRateTimestamp @"kLastTransformRateTimestamp"
#define kLastIPOrderAbnormalTimestamp @"kLastIPOrderAbnormalTimestamp"
#define kLastPlatDateTimestamp @"kLastPlatDateTimestamp"
#define kLastSuccessRateTimestamp @"kLastSuccessRateTimestamp"

@implementation UserDefaults

SYNTHESIZE_SINGLETON_FOR_CLASS(UserDefaults);

BOOL getBoolValueForKey(NSString* key) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

void setBoolValueForKeyWithSyncFlag(BOOL flag, NSString *key, BOOL isSync) {
    if (![key isKindOfClass:[NSString class]] || key.length == 0) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:flag forKey:key];
    if (isSync) {
        [defaults synchronize];
    }
}

void setBoolValueForKey(BOOL flag, NSString *key) {
    setBoolValueForKeyWithSyncFlag(flag, key, NO);
}

NSString *getStringValueForKey(NSString* key) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:key];
}

void setStringValueForKeyWithSyncFlag(NSString* obj, NSString *key, BOOL isSync) {
    if (![key isKindOfClass:[NSString class]] || key.length == 0) {
        return;
    }
    obj = [obj copy];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (obj == nil) {
        [defaults removeObjectForKey:key];
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        if (obj.length == 0) {
            [defaults removeObjectForKey:key];
        } else {
            [defaults setObject:obj forKey:key];
        }
    }
    if (isSync) {
        [defaults synchronize];
    }
}

void setStringValueForKey(NSString* obj, NSString *key) {
    setStringValueForKeyWithSyncFlag(obj, key, NO);
}

int getIntValueForKey(NSString* key) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int ret = (int)[defaults integerForKey:key];
    return ret;
}

void setIntValueForKeyWithSyncFlag(int count, NSString *key, BOOL isSync) {
    if (![key isKindOfClass:[NSString class]] || key.length == 0) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:count forKey:key];
    if (isSync) {
        [defaults synchronize];
    }
}

- (void)setUserName:(NSString *)userName {
    setStringValueForKey(userName, kUserName);
}

- (NSString *)userName {
    return getStringValueForKey(kUserName);
}

- (void)setSafeCode:(NSString *)safeCode {
    setStringValueForKey(safeCode, kSafeCode);
}

- (NSString *)safeCode {
    return getStringValueForKey(kSafeCode);
}

- (NSString *)password {
    return [@"123456" md5String];
}

- (void)setIsRememberUserName:(BOOL)isRememberUserName {
    setBoolValueForKey(isRememberUserName, kIsRememberUserName);
}

- (BOOL)isRememberUserName {
    return getBoolValueForKey(kIsRememberUserName);
}

- (void)setLastProvinceDateStr:(NSString *)lastProvinceDateStr {
    setStringValueForKey(lastProvinceDateStr, kLastProvinceShowDateStr);
}

- (NSString *)lastProvinceDateStr {
   return getStringValueForKey(kLastProvinceShowDateStr);
}

- (void)setLastProductDateTimestamp:(int)lastProductDateTimestamp {
    setIntValueForKeyWithSyncFlag(lastProductDateTimestamp, kLastProductDateTimestamp, NO);
}

- (int)lastProductDateTimestamp {
    return getIntValueForKey(kLastProductDateTimestamp);
}

- (void)setLastTransformRateTimestamp:(int)lastTransformRateTimestamp {
    setIntValueForKeyWithSyncFlag(lastTransformRateTimestamp, kLastTransformRateTimestamp, NO);
}

- (int)lastTransformRateTimestamp {
    return getIntValueForKey(kLastTransformRateTimestamp);
}

- (void)setLastIPOrderAbnormalTimestamp:(int)lastIPOrderAbnormalTimestamp {
    setIntValueForKeyWithSyncFlag(lastIPOrderAbnormalTimestamp, kLastIPOrderAbnormalTimestamp, NO);
}

- (int)lastIPOrderAbnormalTimestamp {
    return getIntValueForKey(kLastIPOrderAbnormalTimestamp);
}

- (void)setLastPlatDateTimestamp:(int)lastPlatDateTimestamp {
    setIntValueForKeyWithSyncFlag(lastPlatDateTimestamp, kLastPlatDateTimestamp, NO);
}

- (int)lastPlatDateTimestamp {
    return getIntValueForKey(kLastPlatDateTimestamp);
}

- (void)setLastSuccessRateTimestamp:(int)lastSuccessRateTimestamp {
    setIntValueForKeyWithSyncFlag(lastSuccessRateTimestamp, kLastSuccessRateTimestamp, NO);
}

- (int)lastSuccessRateTimestamp {
    return getIntValueForKey(kLastSuccessRateTimestamp);
}

- (void)setDeviceToken:(NSString *)deviceToken {
    setStringValueForKey(deviceToken, kDeviceToken);
}

- (NSString *)deviceToken {
    return getStringValueForKey(kDeviceToken);
}

//- (void)setLastProductDateStr:(NSString *)lastProductDateStr{
//    setStringValueForKey(lastProductDateStr, kLastProductShowDateStr);
//}
//
//- (NSString *)lastProductDateStr {
//    return getStringValueForKey(kLastProductShowDateStr);
//}

@end
