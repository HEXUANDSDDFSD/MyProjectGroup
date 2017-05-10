//
//  TYSXStreamMediaMonitorCtr.m
//  tysx
//
//  Created by zwc on 14/11/25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXStreamMediaMonitorCtr.h"

#define kDurationKey @"duration"
#define kSendBytesKey @"sentBytes"
#define kPlayTimesKey @"playTimes"

@implementation TYSXStreamMediaMonitorCtr {
    NSMutableArray *_sumTimesList;
    NSMutableArray *_currentTimesList;
    NSMutableArray *_productList;
    NSInteger _currentProductIndex;
    NSInteger _currentType;
}

- (void)setCurrentProductIndex:(NSInteger)currentProductIndex {
    if (currentProductIndex < 0 || currentProductIndex >= [self.productList count]) {
        return;
    }
    
    if (currentProductIndex != _currentProductIndex) {
        _currentProductIndex = currentProductIndex;
        [self reloadCurrentList];
    }
}

- (NSInteger)currentProductIndex {
    return _currentProductIndex;
}

- (void)setCurrentType:(NSInteger)currentType {
    if (_currentType != currentType) {
        _currentType = currentType;
        [self reloadData];
    }
}

- (NSInteger)currentType {
    return _currentType;
}


- (NSArray *)productList {
    return _productList;
}

- (NSArray *)sumTimesList {
    return _sumTimesList;
}

- (NSArray *)currentTimesList {
    return _currentTimesList;
}

// over loading function

- (void)createDatabase {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                               %@ varchar(20),\
                               %@ varchar(50),\
                               %@ bigint,\
                               %@ double,\
                               %@ double,\
                               %@ bigint,\
                               %@ bigint,\
                               %@ varchar(50),\
                               type int,\
                               PRIMARY KEY (%@, %@, type)\
                               )", [self databaseTableName], kDateKey, kProductNameKey, kValueKey, kTongbiKey, kHuanbiKey, kTongbiGapKey, kHuanbiGapKey, kLastUpdateTimeKey, kDateKey, kProductNameKey];
        [database executeUpdate:createSql];
    }];
}

- (NSString *)databaseTableName {
    return @"tysx_stream_media_monitor";
}

- (int)dataType {
    return 12;
}

- (void)successWithResponse:(id)responseObject {
    _resultInfo = @"该天无网络数据";
    NSArray *responseArr = (NSArray *)responseObject;
    if ([responseArr count] != 0) {
        responeData = responseArr[0];
        if ([responeData[kDurationKey] count] != 0) {
            lastDate = willShowDate;
            _result = NetworkBaseResult_Success;
            _resultInfo = @"成功获取网络数据";
        }
    }
}

- (void)saveNetworkData {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        
        NSArray *typeKeyList = @[kSendBytesKey, kPlayTimesKey, kDurationKey];
        for (int i = 0; i < 3; i++) {
            NSArray *productData = responeData[typeKeyList[i]];
            for (int j = 0; j < [productData count]; j++) {
                NSDictionary *dic = [productData objectAtIndex:j];
                NSString *insertSql = [NSString stringWithFormat:@"insert into %@ values('%@', '%@', %lld, %f, %f, %lld, %lld, '%@', %d)",
                                       [self databaseTableName],
                                       [dic objectForKey:@"statisticsTime"],
                                       [dic objectForKey:kProductNameKey],
                                       [[dic objectForKey:typeKeyList[i]] longLongValue],
                                       [[dic objectForKey:kTongbiKey] doubleValue],
                                       [[dic objectForKey:kHuanbiKey] doubleValue],
                                       [[dic objectForKey:kTongbiGapKey] longLongValue],
                                       [[dic objectForKey:kHuanbiGapKey] longLongValue],
                                       [dic objectForKey:kLastUpdateTimeKey],
                                       i];
                [database executeUpdate:insertSql];
            }
        }
        [database commit];
        
    }];
}

- (void)reloadCurrentList {
    [_currentTimesList removeAllObjects];
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        
        NSString *currentProductName = @"";
        if ([self.productList count] != 0) {
            currentProductName = [self.productList[self.currentProductIndex] objectForKey:kProductNameKey];
        }
        
        for (int i = 0; i < kDateSpan; i++) {;
            NSString *selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@='%@' AND %@='%@' AND type=%ld", kValueKey, [self databaseTableName], kDateKey,  stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (kDateSpan - i - 1) * 3600 * 24]), kProductNameKey, currentProductName, (long)self.currentType];
            FMResultSet *currentChannelList = [database executeQuery:selectSql];
            
            long long currentTimes = 0;
            if (currentChannelList.next) {
                currentTimes = [currentChannelList longLongIntForColumn:kValueKey];
            }
            [_currentTimesList addObject:[NSNumber numberWithLongLong:currentTimes]];
        }
        
        [database commit];
    }];
}

- (void)reloadData {
    [super reloadData];
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@,%@ FROM %@ WHERE %@='%@' AND type=%ld", kProductNameKey, kValueKey, kTongbiKey,kHuanbiKey,kTongbiGapKey,kHuanbiGapKey,kLastUpdateTimeKey, [self databaseTableName], kDateKey, self.lastDateStr, (long)self.currentType];
        FMResultSet *productList = [database executeQuery:selectSql];
        while (productList.next) {
            NSMutableDictionary *productDic = [NSMutableDictionary dictionary];
            [productDic setValue:[productList stringForColumn:kProductNameKey] forKey:kProductNameKey];
            [productDic setValue:[NSNumber numberWithLongLong:[productList longLongIntForColumn:kValueKey]] forKey:kValueKey];
            [productDic setValue:[NSNumber numberWithDouble:[productList doubleForColumn:kHuanbiKey]] forKey:kHuanbiKey];
            [productDic setValue:[NSNumber numberWithDouble:[productList doubleForColumn:kTongbiKey]] forKey:kTongbiKey];
            [productDic setValue:[NSNumber numberWithLongLong:[productList longLongIntForColumn:kTongbiGapKey]] forKey:kTongbiGapKey];
            [productDic setValue:[NSNumber numberWithLongLong:[productList longLongIntForColumn:kHuanbiGapKey]] forKey:kHuanbiGapKey];
            [productDic setValue:[productList stringForColumn:kLastUpdateTimeKey] forKey:kLastUpdateTimeKey];
            [_productList addObject:productDic];
        }
        
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        for (int i = 0; i < kDateSpan; i++) {;
            selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@='%@' AND type=%ld", kValueKey, [self databaseTableName], kDateKey,             stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (kDateSpan - i - 1) * 3600 * 24]), (long)self.currentType];
            FMResultSet *product = [database executeQuery:selectSql];
            long long sumTimes = 0;
            while (product.next) {
                sumTimes += [product longLongIntForColumn:kValueKey];
            }
            [_sumTimesList addObject:[NSNumber numberWithLongLong:sumTimes]];
        }
        
        [database commit];
    }];
    [self reloadCurrentList];
}

- (void)allocDataContainer {
    _productList = [NSMutableArray array];
    _currentTimesList = [NSMutableArray array];
    _sumTimesList = [NSMutableArray array];
}

- (void)clearDataContainer {
    [_productList removeAllObjects];
    [_currentTimesList removeAllObjects];
    [_sumTimesList removeAllObjects];
}

@end
