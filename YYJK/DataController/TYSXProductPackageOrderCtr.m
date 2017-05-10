//
//  TYSXProductPackageOrderCtr.m
//  tysx
//
//  Created by zwc on 14/11/26.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXProductPackageOrderCtr.h"

@implementation TYSXProductPackageOrderCtr {
    NSMutableArray *_productList;
    NSMutableArray *_sumTimesList;
    NSMutableArray *_currentTimesList;
    NSInteger _currentProductIndex;
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

- (NSArray *)productList {
    return _productList;
}

- (NSArray *)sumTimesList {
    return _sumTimesList;
}

- (NSArray *)currentTimesList {
    return _currentTimesList;
}


- (NSString *)databaseTableName {
    return @"tysx_product_package_order";
}

- (int)dataType {
    return 13;
}

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
                               PRIMARY KEY (%@, %@)\
                               )", [self databaseTableName], kDateKey, kProductNameKey, kOrderKey, kTongbiKey, kHuanbiKey, kTongbiGapKey, kHuanbiGapKey, kLastUpdateTimeKey, kDateKey, kProductNameKey];
        [database executeUpdate:createSql];
    }];
}

- (void)successWithResponse:(id)responseObject {
    _resultInfo = @"该天无网络数据";
    NSArray *responseArr = (NSArray *)responseObject;
    if ([responseArr count] != 0) {
        lastDate = willShowDate;
        _result = NetworkBaseResult_Success;
        _resultInfo = @"成功获取网络数据";
        responeData = responseArr;
    }
}

- (void)saveNetworkData {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        NSArray *productData = (NSArray *)responeData;
        for (int i = 0; i < [productData count]; i++) {
            NSDictionary *dic = [productData objectAtIndex:i];
            NSString *insertSql = [NSString stringWithFormat:@"insert into %@ values('%@', '%@', %lld, %f, %f, %lld, %lld, '%@')",
                                   [self databaseTableName],
                                   [dic objectForKey:@"statisticsTime"],
                                   [dic objectForKey:kProductNameKey],
                                   [[dic objectForKey:kOrderKey] longLongValue],
                                   [[dic objectForKey:kTongbiKey] doubleValue],
                                   [[dic objectForKey:kHuanbiKey] doubleValue],
                                   [[dic objectForKey:kTongbiGapKey] longLongValue],
                                   [[dic objectForKey:kHuanbiGapKey] longLongValue],
                                   [dic objectForKey:kLastUpdateTimeKey]];
            [database executeUpdate:insertSql];
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
            NSString *selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@='%@' AND %@='%@'", kOrderKey, [self databaseTableName], kDateKey,  stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (kDateSpan - i - 1) * 3600 * 24]), kProductNameKey, currentProductName];
            FMResultSet *currentChannelList = [database executeQuery:selectSql];
            
            long long currentTimes = 0;
            if (currentChannelList.next) {
                currentTimes = [currentChannelList longLongIntForColumn:kOrderKey];
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
        NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@,%@ FROM %@ WHERE %@='%@'", kProductNameKey, kOrderKey, kTongbiKey,kHuanbiKey,kTongbiGapKey,kHuanbiGapKey,kLastUpdateTimeKey, [self databaseTableName], kDateKey, self.lastDateStr];
        FMResultSet *productList = [database executeQuery:selectSql];
        while (productList.next) {
            NSMutableDictionary *productDic = [NSMutableDictionary dictionary];
            [productDic setValue:[productList stringForColumn:kProductNameKey] forKey:kProductNameKey];
            [productDic setValue:[NSNumber numberWithLongLong:[productList longLongIntForColumn:kOrderKey]] forKey:kOrderKey];
            [productDic setValue:[NSNumber numberWithDouble:[productList doubleForColumn:kHuanbiKey]] forKey:kHuanbiKey];
            [productDic setValue:[NSNumber numberWithDouble:[productList doubleForColumn:kTongbiKey]] forKey:kTongbiKey];
            [productDic setValue:[NSNumber numberWithLongLong:[productList longLongIntForColumn:kTongbiGapKey]] forKey:kTongbiGapKey];
            [productDic setValue:[NSNumber numberWithLongLong:[productList longLongIntForColumn:kHuanbiGapKey]] forKey:kHuanbiGapKey];
            [productDic setValue:[productList stringForColumn:kLastUpdateTimeKey] forKey:kLastUpdateTimeKey];
            [_productList addObject:productDic];
        }
        
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        for (int i = 0; i < kDateSpan; i++) {;
            selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@='%@'", kOrderKey, [self databaseTableName], kDateKey,             stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (kDateSpan - i - 1) * 3600 * 24])];
            FMResultSet *product = [database executeQuery:selectSql];
            long long sumTimes = 0;
            while (product.next) {
                sumTimes += [product longLongIntForColumn:kOrderKey];
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
