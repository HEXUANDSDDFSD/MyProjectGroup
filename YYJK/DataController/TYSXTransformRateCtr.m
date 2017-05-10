//
//  TYSXTransformRateCtr.m
//  tysx
//
//  Created by zwc on 14-7-14.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXTransformRateCtr.h"
#import "GCD+EXPAND.h"
#import "DatabaseManager.h"

#define kShowVolumeNatureKey @"naurePercent"
#define kShowVolumeExtendKey @"noNaturePercent"
#define kDataBaseTableName @"TransFormData"
#define kPlatKey @"plat"

#define kNeedDateSpan 31

@implementation TYSXTransformRateCtr {
    NSDate *lastDate;
    NSString *endUpdateDateStr;
    NSString *beginUpdateDateStr;
    NSDate *willBeLastDate;
    NSArray *responeData;
    NSMutableArray *_allData;
    NSMutableArray *_natureData;
    NSMutableArray *_extendData;
    NSInteger _currentPlatIndex;
}

- (id)init {
    if (self = [super init]) {
        if (USER_DFT.lastTransformRateTimestamp == 0) {
            USER_DFT.lastTransformRateTimestamp = [[NSDate dateWithTimeIntervalSinceNow:-24 * 3600] timeIntervalSince1970];
        }
        lastDate = [NSDate dateWithTimeIntervalSince1970:USER_DFT.lastTransformRateTimestamp];
        [self createTable];
        [self allocContainer];
    }
    return self;
}

- (void)dealloc {
    USER_DFT.lastTransformRateTimestamp = [lastDate timeIntervalSince1970];
}

- (void)setCurrentPlatIndex:(NSInteger)currentPlatIndex {
    if (currentPlatIndex != _currentPlatIndex) {
        _currentPlatIndex = currentPlatIndex;
        [self reloadData];
    }
}

- (NSInteger)currentPlatIndex {
    return _currentPlatIndex;
}

- (void)allocContainer {
    _allData = [NSMutableArray array];
    _extendData = [NSMutableArray array];
    _natureData = [NSMutableArray array];
}

- (void)cleanContainer {
    [_allData removeAllObjects];
    [_natureData removeAllObjects];
    [_extendData removeAllObjects];
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

- (NSArray *)allData {
    return _allData;
}

- (NSArray *)natureData {
    return _natureData;
}

- (NSArray *)extendData {
    return _extendData;
}

- (NSString *)lastDateStr {
    return stringWithDate(lastDate);
}

- (NSArray *)allDateStrs {
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
        //[database beginTransaction];
        
        NSString *selectSql = nil;
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        NSString *dateString = nil;
        for (int i = 0; i < kNeedDateSpan; i++) {
            dateString = stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - 3600 * 24 * i]);
            selectSql = [NSString stringWithFormat:@"SELECT %@,%@ FROM %@ WHERE DATE='%@' AND %@='%@'", kShowVolumeNatureKey, kShowVolumeExtendKey, kDataBaseTableName, dateString, kPlatKey, self.platIdList[_currentPlatIndex]];
            FMResultSet *result = [database executeQuery:selectSql];
            CGFloat natureValue = 0.0;
            CGFloat extendValue = 0.0;
            if (result.next) {
                natureValue = [result doubleForColumn:kShowVolumeNatureKey];
                extendValue = [result doubleForColumn:kShowVolumeExtendKey];
            }
            [_allData insertObject:[NSNumber numberWithFloat:natureValue + extendValue] atIndex:0];
            [_natureData insertObject:[NSNumber numberWithFloat:natureValue] atIndex:0];
            [_extendData insertObject:[NSNumber numberWithFloat:extendValue] atIndex:0];
        }
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
                NSString *insertSql = [NSString stringWithFormat:@"insert into %@ values('%@', %f, %f, %@)",
                                       kDataBaseTableName,
                                       [dic objectForKey:@"staticTicsTime"],
                                       [[dic objectForKey:kShowVolumeNatureKey] floatValue],
                                       [[dic objectForKey:kShowVolumeExtendKey] floatValue], [dic objectForKey:kPlatKey]];
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
                               date varchar(20),\
                               %@ double,\
                               %@ double,\
                               %@ varchar(6),\
                               PRIMARY KEY (date, %@))", kDataBaseTableName,  kShowVolumeNatureKey, kShowVolumeExtendKey, kPlatKey, kPlatKey];
        [database executeUpdate:createSql];
    }];
}

- (BOOL)hasAnyData {
    __block int totalCount = 0;
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *queryStr = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", kDataBaseTableName];        FMResultSet *s = [database executeQuery:queryStr];
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
        
        NSString *queryStr = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where date = '%@'",kDataBaseTableName, dateStr];
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
    return @{@"dataType":[NSNumber numberWithInt:6],
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
