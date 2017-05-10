//
//  TYSXSuccessRateCtr.m
//  tysx
//
//  Created by zwc on 14-9-4.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXSuccessRateCtr.h"
#import "DatabaseManager.h"

#define kNeedDateSpan 31

#define kBaseTableName @"SUCCESS_RATE"
#define kDateKey @"statTime"
#define kSuccessNumKey @"orderPassCt"
#define kAllNumKey @"orderSum"
#define kAAAFailKey @"aaaFail"

@implementation TYSXSuccessRateCtr {
    NSDate *lastDate;
    NSDate *willBeLastDate;
    NSString *beginUpdateDateStr;
    NSString *endUpdateDateStr;
    NSMutableArray *_successData;
    NSMutableArray *_failureData;
    NSMutableArray *_successRateData;
    NSMutableArray *_aaaFailureData;
    NSMutableArray *_allData;
    NSArray *responeData;
}

- (id)init {
    if (self = [super init]) {
        if (USER_DFT.lastSuccessRateTimestamp == 0) {
            USER_DFT.lastSuccessRateTimestamp = [[NSDate dateWithTimeIntervalSinceNow:-24 * 3600] timeIntervalSince1970];
        }
        lastDate = [NSDate dateWithTimeIntervalSince1970:USER_DFT.lastSuccessRateTimestamp];
        [self createTable];
        [self allocContainer];
    }
    return self;
}

- (void)dealloc {
    USER_DFT.lastSuccessRateTimestamp = [lastDate timeIntervalSince1970];
}

- (void)allocContainer {
    _successData = [NSMutableArray array];
    _failureData = [NSMutableArray array];
    _successRateData = [NSMutableArray array];
    _aaaFailureData = [NSMutableArray array];
    _allData = [NSMutableArray array];
}

- (void)cleanContainer {
    [_successRateData removeAllObjects];
    [_failureData removeAllObjects];
    [_successRateData removeAllObjects];
    [_aaaFailureData removeAllObjects];
    [_allData removeAllObjects];
}

- (NeedOperateType)updateLastDate:(NSDate *)date {
    if (date == nil) {
        return NeedOperateType_None;
    }
    
    NeedOperateType type = NeedOperateType_None;
    if ([date compare:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)]] == NSOrderedDescending) {
        type = NeedOperateType_OverDate;
    }
    else if ([self needUpdateDataWithLastDate:date]) {
        type = NeedOperateType_Update;
    }
    else {
        type = NeedOperateType_Reload;
        lastDate = date;
    }
    return type;
}

- (BOOL)needUpdateDataWithLastDate:(NSDate *)date {
    
    willBeLastDate = date;
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    beginUpdateDateStr = nil;
    endUpdateDateStr = nil;
    
    for (int i = 0; i < kNeedDateSpan; i++) {
        NSString *dateStr = stringWithDate([NSDate dateWithTimeIntervalSince1970:timeInterval - 3600 * 24 * i]);
        if (![self hasLocalDataWithDateStr:dateStr]) {
            if (endUpdateDateStr == nil) {
                endUpdateDateStr = dateStr;
            }
            beginUpdateDateStr = dateStr;
        }
    }
    
    if (beginUpdateDateStr == nil && endUpdateDateStr == nil) {
        return NO;
    }
    
    return YES;
}

#pragma mark read only

- (NSArray *)platIdList {
    return @[@"0", @"1", @"2", @"9", @"10", @"20", @"40", @"41", @"42", @"43", @"70", @"71", @"80", @"99", @"100"];
}

- (NSArray *)platNameList {
    return @[@"总量", @"WAP240", @"客户端(1.x,2.x)", @"客户端3", @"客户端4", @"客户端5", @"iPhone客户端", @"iPad客户端", @"winPhone客户端", @"爱看4G客户端", @"PC主站（网页）", @"PC客户端", @"互联网电视", @"独立客户端", @"未知"];
}

- (NSArray *)successData {
    return _successData;
}

- (NSArray *)failureData {
    return _failureData;
}

- (NSArray *)successRateData {
    return _successRateData;
}

- (NSString *)lastDateStr {
    return stringWithDate(lastDate);
}

- (NSArray *)dateList {
    NSMutableArray *ret = [NSMutableArray array];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    
    NSTimeInterval lastTimeInterval = [lastDate timeIntervalSince1970];
    for (int i = 0; i < kNeedDateSpan; i ++) {
        [ret insertObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:lastTimeInterval - 3600 * 24 * i]] atIndex:0];
    }
    return ret;
}

- (NSArray *)showDateStrs {
    NSMutableArray *ret = [NSMutableArray array];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    
    NSTimeInterval lastTimeInterval = [lastDate timeIntervalSince1970];
    for (int i = 0; i < kNeedDateSpan; i += 2) {
        [ret insertObject:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:lastTimeInterval - 3600 * 24 * i]] atIndex:0];
    }
    return ret;
}

#pragma mark database

- (void)reloadData {
    [self cleanContainer];
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        NSString *selectSql = nil;
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        NSString *dateString = nil;
        for (int i = 0; i < kNeedDateSpan; i++) {
            dateString = stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - 3600 * 24 * i]);
            selectSql = [NSString stringWithFormat:@"SELECT %@,%@,%@ FROM %@ WHERE %@='%@'", kAllNumKey, kSuccessNumKey, kAAAFailKey, kBaseTableName, kDateKey, dateString];
            FMResultSet *result = [database executeQuery:selectSql];
            long long failureNum = 0;
            long long successNum = 0;
            long long aaaFailureNum = 0;
            CGFloat successRateSum = 0.0f;
            long long allNum = 0;
            if (result.next) {
                successNum = [result longLongIntForColumn:kSuccessNumKey];
                allNum = [result longLongIntForColumn:kAllNumKey];
                failureNum =  allNum - successNum;
                aaaFailureNum = [result longLongIntForColumn:kAAAFailKey];
            }
            [_successData insertObject:[NSNumber numberWithLongLong:successNum] atIndex:0];
            [_failureData insertObject:[NSNumber numberWithLongLong:failureNum] atIndex:0];
            [_aaaFailureData insertObject:[NSNumber numberWithLongLong:aaaFailureNum] atIndex:0];
            [_allData insertObject:[NSNumber numberWithLongLong:allNum] atIndex:0];
            if (allNum != 0) {
                successRateSum = successNum * 1.0 / allNum;
            }
            [_successRateData insertObject:[NSNumber numberWithFloat:successRateSum] atIndex:0];
            
        }
        [database commit];
    }];
    
}

- (void)saveNetworkDataWithCompleteBlock:(dispatch_block_t) complete {
    if (responeData == nil || [responeData count] == 0) {
        return;
    }
    run_async_and_complete(^{
        [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
            [database beginTransaction];
            for (int i = 0; i < [responeData count]; i++) {
                NSDictionary *dic = [responeData objectAtIndex:i];
                NSString *insertSql = [NSString stringWithFormat:@"insert into %@ values('%@', %lld, %lld, %lld)", kBaseTableName, dic[kDateKey],
                                       [dic[kAllNumKey] longLongValue],
                                       [dic[kSuccessNumKey] longLongValue], [dic[kAAAFailKey] longLongValue]];
                [database executeUpdate:insertSql];
            }
            [database commit];
            
        }];
        
    }, ^{
        responeData = nil;
        if (complete != nil) {
            complete();
        }
    });
}

- (void)createTable {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(\
                               %@ varchar(20),\
                               %@ bigint,\
                               %@ bigint,\
                               %@ bigint,\
                               PRIMARY KEY (%@))", kBaseTableName,  kDateKey, kAllNumKey, kSuccessNumKey, kAAAFailKey, kDateKey];
        [database executeUpdate:createSql];
    }];
}

- (BOOL)hasAnyData {
    __block int totalCount = 0;
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *queryStr = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", kBaseTableName];
        FMResultSet *s = [database executeQuery:queryStr];
        if ([s next]) {
            totalCount = [s intForColumnIndex:0];
        }
    }];
    
    if (totalCount == 0) {
        endUpdateDateStr = self.lastDateStr;
        willBeLastDate = lastDate;
        
        NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[lastDate timeIntervalSince1970] - (kNeedDateSpan - 1) * 3600 * 24];
        
        beginUpdateDateStr = stringWithDate(beginDate);
        return NO;
    }
    return YES;
}

- (BOOL)hasLocalDataWithDateStr:(NSString *)dateStr {
    __block int totalCount = 0;
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        
        NSString *queryStr = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where %@ = '%@'",kBaseTableName, kDateKey, dateStr];
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

#pragma mark network overload

- (NSDictionary *)configParams {
    return @{@"dataType":[NSNumber numberWithInt:9],
             @"startDate":beginUpdateDateStr,
             @"endDate":endUpdateDateStr};
}

+ (NSString *)path {
    return  @"/app";
}

+ (CFStringEncodings)encodingType {
    return 0;
}

- (void)successWithResponse:(id)responseObject {
    _resultInfo = @"该天无网络数据";
    NSArray *response = (NSArray *)responseObject;
    if ([response isKindOfClass:[NSArray class]] && [response count] != 0) {
        lastDate = willBeLastDate;
        _result = NetworkBaseResult_Success;
        _resultInfo = @"成功获取网络数据";
        responeData = response;
    }
}

@end
