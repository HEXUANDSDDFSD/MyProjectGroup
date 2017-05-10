//
//  TYSXPlatformCtr.m
//  tysx
//
//  Created by zwc on 14-7-28.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXPlatformCtr.h"
#import "DatabaseManager.h"

#define kNeedDateSpan 31

#define kDataBaseTableName @"plat_data"
#define kPlatIdKey @"platId"
#define kPlatNameKey @"platName"
#define kDateKey @"statisticsTime"
#define kTimesKey @"times"

@implementation TYSXPlatformCtr {
    NSDate *lastDate;
    NSString *endUpdateDateStr;
    NSString *beginUpdateDateStr;
    NSDate *willBeLastDate;
    NSArray *responeData;
    NSMutableArray *_accessData;
    NSMutableArray *_loginData;
    NSMutableArray *_playbackData;
    NSMutableArray *_loginTransData;
    NSMutableArray *_playbackTransData;
    NSMutableDictionary *platIdAndNameDic;
    NSInteger _currentPlatIndex;
}

- (id)init {
    if (self = [super init]) {
        if (USER_DFT.lastPlatDateTimestamp == 0) {
            USER_DFT.lastPlatDateTimestamp = [[NSDate dateWithTimeIntervalSinceNow:-24 * 3600] timeIntervalSince1970];
        }
        lastDate = [NSDate dateWithTimeIntervalSince1970:USER_DFT.lastPlatDateTimestamp];
        [self createTable];
        [self allocContainer];
    }
    return self;
}

- (void)dealloc {
    USER_DFT.lastPlatDateTimestamp = [lastDate timeIntervalSince1970];
}

- (void)setCurrentPlatIndex:(NSInteger)currentPlatIndex {
    if (_currentPlatIndex != currentPlatIndex) {
        _currentPlatIndex = currentPlatIndex;
        [self reloadData];
    }
}

- (NSInteger)currentPlatIndex {
    return _currentPlatIndex;
}

- (void)allocContainer {
    _accessData = [NSMutableArray array];
    _loginData = [NSMutableArray array];
    _playbackData = [NSMutableArray array];
    _loginTransData = [NSMutableArray array];
    _playbackTransData = [NSMutableArray array];
    platIdAndNameDic = [NSMutableDictionary dictionary];
}

- (void)cleanContainer {
    [_accessData removeAllObjects];
    [_loginData removeAllObjects];
    [_playbackData removeAllObjects];
    [_loginTransData removeAllObjects];
    [_playbackTransData removeAllObjects];
    [platIdAndNameDic removeAllObjects];
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
    return [[platIdAndNameDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        return [str1 compare:str2];
    }];
}

- (NSString *)platNameWithPlatId:(NSString *)platId {
    return platIdAndNameDic[platId];
}

- (NSArray *)loginTransData {
    return _loginTransData;
}

- (NSArray *)playbackTransData {
    return _playbackTransData;
}

- (NSArray *)accessData {
    return _accessData;
}

- (NSArray *)loginData {
    return _loginData;
}

- (NSArray *)playbackData {
    return _playbackData;
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

#pragma mark database

- (void)reloadData {
    [self cleanContainer];
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        
        NSString *selectSql = nil;
        
        selectSql = [NSString stringWithFormat:@"SELECT DISTINCT %@,%@ FROM %@", kPlatIdKey, kPlatNameKey, kDataBaseTableName];
        FMResultSet *platIdAndName = [database executeQuery:selectSql];
        while (platIdAndName.next) {
            [platIdAndNameDic setValue:[platIdAndName stringForColumn:kPlatNameKey] forKeyPath:[platIdAndName stringForColumn:kPlatIdKey]];
        }
        
        NSString *currentPlatId = nil;
        
        if ([self.platIdList count] != 0) {
            currentPlatId = self.platIdList[_currentPlatIndex];
        }
        
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        NSString *dateString = nil;
        for (int i = 0; i < kNeedDateSpan; i++) {
            dateString = stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - 3600 * 24 * i]);
            for (int j = 0; j < 3; j++) {
                selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@='%@' AND %@='%@' AND %@=%d", kTimesKey, kDataBaseTableName, kDateKey, dateString, kPlatIdKey, currentPlatId, @"type", j];
                FMResultSet *result = [database executeQuery:selectSql];
                long long times = 0;
                if (result.next) {
                    times = [result longLongIntForColumn:kTimesKey];
                }
                switch (j) {
                    case 0:
                        [_accessData insertObject:[NSNumber numberWithLongLong:times] atIndex:0];
                        break;
                    case 1:
                        [_loginData insertObject:[NSNumber numberWithLongLong:times] atIndex:0];
                        break;
                    case 2:
                        [_playbackData insertObject:[NSNumber numberWithLongLong:times] atIndex:0];
                        break;
                    default:
                        break;
                }
            }
        }
        [database commit];
        for (int i = 0; i < kNeedDateSpan; i++) {
            CGFloat transData = 0;
            if ([self.accessData[i] longLongValue] != 0) {
                transData = [self.loginData[i] longLongValue] * 1.0 / [self.accessData[i]longLongValue];
            }
            [_loginTransData addObject:[NSNumber numberWithFloat:transData]];
            
            if ([self.loginData[i] longLongValue] != 0) {
                transData = [self.playbackData[i] longLongValue] * 1.0 / [self.loginData[i]longLongValue];
            }
            [_playbackTransData addObject:[NSNumber numberWithFloat:transData]];
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
                NSString *insertSql = [NSString stringWithFormat:@"insert into %@ values('%@', '%@', '%@', %lld, %d)",
                                       kDataBaseTableName,
                                       [dic objectForKey:kDateKey],
                                       [dic objectForKey:kPlatIdKey],
                                       [dic objectForKey:kPlatNameKey],
                                       [[dic objectForKey:kTimesKey] longLongValue], [[dic objectForKey:@"type"] intValue]];
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
                               %@ varchar(50),\
                               %@ varchar(50),\
                               %@ bigint,\
                               type int,\
                               PRIMARY KEY (%@, %@, type))", kDataBaseTableName, kDateKey, kPlatIdKey, kPlatNameKey, kTimesKey, kDateKey, kPlatIdKey];
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
        
        NSString *queryStr = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where %@ = '%@'",kDataBaseTableName, kDateKey, dateStr];
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
    return @{@"dataType":[NSNumber numberWithInt:8],
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
