//
//  OSSCachePlotCtr.m
//  tysx
//
//  Created by zwc on 14/11/24.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "OSSCachePlotCtr.h"

@implementation OSSCachePlotCtr {
    CacheType cacheType;
}

- (id)initWithCacheType:(CacheType)cacheType_ {
    if (self = [super init]) {
        cacheType = cacheType_;
        if (cacheType_ == CacheType_All) {
            [self createDatabase];
        }
        
        if (cacheType == CacheType_Once) {
            responeData = [NSDictionary dictionaryWithContentsOfFile:[self onceCachePath]];
        }
        
        int lastDateTimestamp = [[[NSUserDefaults standardUserDefaults] valueForKey:[self lastDateTimestampKey]] intValue];
        
        if (lastDateTimestamp == 0) {
            lastDate = [NSDate dateWithTimeIntervalSinceNow:-24 * 3600];
        }
        else {
            lastDate = [NSDate dateWithTimeIntervalSince1970:lastDateTimestamp];
        }
        [self allocDataContainer];
    }
    return self;
}

- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[lastDate timeIntervalSince1970]] forKey:[self lastDateTimestampKey]];
}

- (NSArray *)dataStrListWithDayNumber:(NSInteger)number {
    NSMutableArray *ret = [NSMutableArray array];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    for (int i = 0; i < number; i++) {
        NSDate *date = [NSDate dateWithTimeInterval:-24 * 3600 * i sinceDate:lastDate];
        [ret insertObject:[format stringFromDate:date] atIndex:0];
    }
    return ret;
}

- (NSString *)lastDateTimestampKey{
    return [NSString stringWithFormat:@"lastDateTimestamp_%@", NSStringFromClass([self class])];
}

- (NeedOperateType)changeLastDate:(NSDate *)date {
    
    if (date == nil) {
        return NeedOperateType_None;
    }
    
    willShowDate = date;
    
    NeedOperateType type = NeedOperateType_None;
    if ([date compare:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)]] == NSOrderedDescending) {
        type = NeedOperateType_OverDate;
    }
    else if ([self needUpdateDataWithLastDate:date]) {
        type = NeedOperateType_Update;
    }
    else {
        type = NeedOperateType_Reload;
        lastDate = willShowDate;
    }
    return type;
}

- (CacheType)cacheType {
    return cacheType;
}

- (void)createDatabase {
    NSMutableArray *fieldList = [NSMutableArray array];
    [fieldList addObject:[DBField dbFieldWithName:@"name" type:@"varchar(20)" isPri:YES]];
    [fieldList addObject:[DBField dbFieldWithName:@"sex" type:@"varchar(20)" isPri:NO]];
    [[DatabaseManager shareDatabase] createDBTableWith:@"tableNam" fieldList:fieldList];
}

- (void)saveNetworkDataWithCompleteBlock:(dispatch_block_t) complete {
    run_async_and_complete(^{
        [self saveNetworkData];
    }, ^{
        if (cacheType == CacheType_All) {
            responeData = nil;
        }
        if (complete != nil) {
            complete();
        }
    });
}

- (NSString *)onceCachePath {
    return [KCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", NSStringFromClass([self class])]];
}

- (void)saveNetworkData {
    if (cacheType == CacheType_Once) {
        [responeData writeToFile:[self onceCachePath] atomically:YES];
    }
}

- (void)reloadData {
    [self clearDataContainer];
}

- (BOOL)needUpdateDataWithLastDate:(NSDate *)date {
    endDateStr = nil;
    startDateStr = nil;
    
    NSTimeInterval lastTime = [date timeIntervalSince1970];
    for (int i = 0; i < [self dateSpan]; i++) {
        NSString *dateStr = stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - 3600 * 24 * i]);
        if (![self hasDataWithDateStr:dateStr]) {
            if (endDateStr == nil) {
                endDateStr = dateStr;
            }
            startDateStr = dateStr;
        }
    }
    
    if (startDateStr != nil) {
        return YES;
    }
    
    return NO;
}

- (BOOL)hasDataWithDateStr:(NSString *)dateStr {
    __block int totalCount = 0;
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *queryStr = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where date='%@'", [self databaseTableName], dateStr];
        FMResultSet *s = [database executeQuery:queryStr];
        if ([s next]) {
            totalCount = [s intForColumnIndex:0];
        }
    }];
    
    if (totalCount == 0) {
        return NO;
    }
    
    return YES;
}

- (NSString *)dateStringBeforeDayNumber:(NSInteger)num {
    return stringWithDate([NSDate dateWithTimeIntervalSince1970:[lastDate timeIntervalSince1970] - 24 * 3600 * num]);
}

- (int)dataType {
    return 0;
}

- (void)allocDataContainer {
}

- (void)clearDataContainer {
}

- (NSString *)databaseTableName {
    return @"";
}

- (NSString *)lastDateStr {
    return stringWithDate(lastDate);
}

- (BOOL)hasAnyData {
    if (cacheType == CacheType_All) {
        __block int totalCount = 0;
        
        [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
            NSString *queryStr = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", [self databaseTableName]];        FMResultSet *s = [database executeQuery:queryStr];
            if ([s next]) {
                totalCount = [s intForColumnIndex:0];
            }
        }];
        if (totalCount == 0) {
            endDateStr = self.lastDateStr;
            willShowDate = lastDate;
            
            NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[lastDate timeIntervalSince1970] - ([self dateSpan] - 1) * 3600 * 24];
            
            startDateStr = stringWithDate(beginDate);
            return NO;
        }
        
        return YES;
    }
    else {
        return responeData != nil;
    }
}

- (NSInteger)dateSpan {
    return kDateSpan;
}

#pragma overload

- (NSDictionary *)configParams {
    return @{@"dataType":[NSNumber numberWithInt:[self dataType]],
             @"startDate":startDateStr,
             @"endDate":endDateStr};
}

+ (NSString *)path {
    return  @"/app";
}

- (void)successWithResponse:(id)responseObject {
    
    _resultInfo = @"该天无网络数据";
//    NSArray *response = (NSArray *)responseObject;
//    NSDictionary *dataContent = (NSDictionary *)response[0];
//    NSArray *plats = dataContent[kPlatKey];
//    NSArray *products = dataContent[kProductKey];
//    if ([response isKindOfClass:[NSArray class]] && ([products count] != 0 || [plats count] != 0)) {
//        lastDate = willShowDate;
//        _result = NetworkBaseResult_Success;
//        _resultInfo = @"成功获取网络数据";
//        responeData = response;
//    }
}

@end
