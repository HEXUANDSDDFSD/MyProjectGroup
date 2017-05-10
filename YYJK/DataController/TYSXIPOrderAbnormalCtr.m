//
//  HXIPOrderAbnormalCtr.m
//  tysx
//
//  Created by zwc on 14-8-14.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXIPOrderAbnormalCtr.h"
#import "GCD+EXPAND.h"
#import "DatabaseManager.h"

#define kDataBaseTableName @"IPOrderAbnormal"

@implementation TYSXIPOrderAbnormalCtr {
    NSDate *lastDate;
    NSDate *willBeLastDate;
    NSArray *responeData;
    NSMutableArray *abnormalArray;
}

- (id)init {
    if (self = [super init]) {
        if (USER_DFT.lastIPOrderAbnormalTimestamp == 0) {
            USER_DFT.lastIPOrderAbnormalTimestamp = [[NSDate dateWithTimeIntervalSinceNow:-24 * 3600] timeIntervalSince1970];
        }
        lastDate = [NSDate dateWithTimeIntervalSince1970:USER_DFT.lastIPOrderAbnormalTimestamp];
        [self createTable];
        [self allocContainer];
    }
    return self;
}

- (void)dealloc {
    USER_DFT.lastIPOrderAbnormalTimestamp = [lastDate timeIntervalSince1970];
}

- (void)allocContainer {
    abnormalArray = [NSMutableArray array];
}

- (void)cleanContainer {
    [abnormalArray removeAllObjects];
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
    return ![self hasLocalDataWithDateStr:stringWithDate(date)];
}

#pragma mark read only

- (NSArray *)abnormalDatas {
    return abnormalArray;
}

- (NSString *)lastDateStr {
    return stringWithDate(lastDate);
}

#pragma mark database

- (void)reloadData {
    [self cleanContainer];
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        
        NSString *selectSql = [NSString stringWithFormat:@"SELECT * From %@ WHERE %@='%@' order by %@ desc", kDataBaseTableName, kDateKey,stringWithDate(lastDate), kOrderTimesKey];

      //  NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@ FROM %@ WHERE %@='%@'", kIpKey, kProductNameKey, kAddressKey, kOrderTimesKey, kDataBaseTableName, kOrderTimesKey, stringWithDate(lastDate)];
        FMResultSet *result = [database executeQuery:selectSql];
        while (result.next) {
            NSDictionary *dic = @{kIpKey:[result stringForColumn:kIpKey],
                                  kProductNameKey : [result stringForColumn:kProductNameKey],
                                  kAddressKey : [result stringForColumn:kAddressKey],
                                  kOrderTimesKey : [NSNumber numberWithLongLong:[result longLongIntForColumn:kOrderTimesKey]]};
            [abnormalArray addObject:dic];
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
                NSString *insertSql = [NSString stringWithFormat:@"insert into %@ values('%@', '%@', '%@', '%@', '%lld')",
                                       kDataBaseTableName, [dic objectForKey:kDateKey], [dic objectForKey:kIpKey], [dic objectForKey:kAddressKey], [dic objectForKey:kProductNameKey], [[dic objectForKey:kOrderTimesKey] longLongValue]];
                                       ;
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
                               %@ varchar(20),\
                               %@ varchar(100),\
                               %@ varchar(100),\
                               %@ bigint,\
                               PRIMARY KEY (%@, %@, %@))", kDataBaseTableName, kDateKey, kIpKey, kAddressKey, kProductNameKey,kOrderTimesKey, kDateKey, kIpKey, kProductNameKey];
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
    if (willBeLastDate == nil) {
        willBeLastDate = lastDate;
    }
    return @{@"dataType":[NSNumber numberWithInt:7],
             @"startDate":stringWithDate(willBeLastDate),
             @"endDate":stringWithDate(willBeLastDate)};
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
