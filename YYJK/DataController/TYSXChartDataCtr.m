//
//  TYSXChartDataCtr.m
//  tysx
//
//  Created by zwc on 13-11-20.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "TYSXChartDataCtr.h"
#import "NSNumber+Format.h"
#import "MKNetworkKit.h"
#import "DatabaseManager.h"
#import "NSString+JSONCategory.h"
#import "GCD+EXPAND.h"
#import "FMDatabase.h"

#define kOrderKey @"or"
#define kUnsubscribeKey @"Un"
#define kFlowKey @"fl"

#define kShowVolumeAllKey @"times"
#define kShowVolumeNatureKey @"natureTimes"
#define kShowVolumeExtendKey @"noNatureTimes"

#define kProductTableName @"ProductData"
#define kPlatTableName @"PlatData"

#define kPlatIdKey @"platId"
#define kPlatNameKey @"platName"

#define kProductKey @"product"
#define kPlatKey @"plat"

#define kDateSpan 14

@interface TYSXChartDataCtr()

@end

@implementation TYSXChartDataCtr {
    NSString *startDateStr;
    NSString *endDateStr;
    NSMutableDictionary *productListDic;
    NSDate *lastDate;
    NSDate *willShowDate;
    NSMutableArray *orderDataArr;
    NSMutableArray *unsubscribeDataArr;
    NSMutableArray *flowDataArr;
    NSArray *responeData;
    NSMutableDictionary *platIdAndNameDic;
}

@synthesize currentTypeId;
@synthesize currentProductId;

- (id)init {
    if (self = [super init]) {
        
        [self createDataDb];
        [self createProductListDb];
        
        
        self.currentProductId = @"all";
        
        [self allocContainer];
        
        
        if (USER_DFT.lastProductDateTimestamp == 0) {
            lastDate = [NSDate dateWithTimeIntervalSinceNow:-24 * 3600];
        }
        else {
           lastDate = [NSDate dateWithTimeIntervalSince1970:USER_DFT.lastProductDateTimestamp];
        }
    }
    return self;
}

- (void)allocContainer {
    productListDic = [NSMutableDictionary dictionary];
    orderDataArr = [NSMutableArray array];
    unsubscribeDataArr = [NSMutableArray array];
    flowDataArr = [NSMutableArray array];
    platIdAndNameDic = [NSMutableDictionary dictionary];
}

- (void)clearContainer {
    [productListDic removeAllObjects];
    [orderDataArr removeAllObjects];
    [unsubscribeDataArr removeAllObjects];
    [flowDataArr removeAllObjects];
}


- (void)dealloc {
    USER_DFT.lastProductDateTimestamp = [lastDate timeIntervalSince1970];
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

- (BOOL)needUpdateDataWithLastDate:(NSDate *)date {
    endDateStr = nil;
    startDateStr = nil;
    
    NSTimeInterval lastTime = [date timeIntervalSince1970];
    for (int i = 0; i < kDateSpan; i++) {
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
        NSString *queryStr = [NSString stringWithFormat:@"SELECT COUNT(*) FROM ProductData where date='%@'", dateStr];
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

- (void)createDataDb {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                               date varchar(20),\
                               ProductId varchar(50),\
                               %@ bigint,\
                               %@ bigint,\
                               %@ bigint,\
                               type int,\
                               PRIMARY KEY (date, ProductId, type)\
                               )", kProductTableName,kShowVolumeAllKey, kShowVolumeNatureKey, kShowVolumeExtendKey];
        [database executeUpdate:createSql];
        
        createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                     date varchar(20),\
                     %@ varchar(50),\
                     %@ varchar(50),\
                     %@ bigint,\
                     %@ bigint,\
                     %@ bigint,\
                     type int,\
                     PRIMARY KEY (date, %@, type)\
                     )", kPlatTableName, kPlatIdKey, kPlatNameKey, kShowVolumeAllKey, kShowVolumeNatureKey, kShowVolumeExtendKey, kPlatIdKey];
        [database executeUpdate:createSql];
    }];
}

- (void)createProductListDb {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *createSql = @"CREATE TABLE IF NOT EXISTS ProductList(\
        ProductId varchar(50),\
        ProductName varchar(100),\
        PRIMARY KEY (ProductId))";
        [database executeUpdate:createSql];
    }];
}

- (void)saveNetworkDataWithCompleteBlock:(dispatch_block_t) complete {
    if (responeData == nil || [responeData count] == 0) {
        return;
    }
    run_async_and_complete(^{
        [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
            [database beginTransaction];
            NSArray *productData = responeData[0][@"product"];
            for (int i = 0; i < [productData count]; i++) {
                NSDictionary *dic = [productData objectAtIndex:i];
                NSString *insertSql = [NSString stringWithFormat:@"insert into %@ values('%@', '%@', %lld, %lld, %lld, %d)",
                                       kProductTableName,
                                       [dic objectForKey:@"statisticsTime"],
                                       [dic objectForKey:@"productId"],
                                       [[dic objectForKey:kShowVolumeAllKey] longLongValue],
                                       [[dic objectForKey:kShowVolumeNatureKey] longLongValue],
                                       [[dic objectForKey:kShowVolumeExtendKey] longLongValue],
                                       [[dic objectForKey:@"type"] intValue]];
                [database executeUpdate:insertSql];
                
                insertSql = [NSString stringWithFormat:@"replace into ProductList values('%@', '%@')",
                             [dic objectForKey:@"productId"],
                             [dic objectForKey:@"productName"]];
                [database executeUpdate:insertSql];
            }
            
            NSArray *platData = responeData[0][@"plat"];
            for (int i = 0; i < [platData count]; i++) {
                NSDictionary *dic = [platData objectAtIndex:i];
                NSString *insertSql = [NSString stringWithFormat:@"insert into %@ values('%@', '%@','%@', %lld, %lld, %lld, %d)",
                                       kPlatTableName,
                                       [dic objectForKey:@"statisticsTime"],
                                       [dic objectForKey:kPlatIdKey],
                                       [dic objectForKey:kPlatNameKey],
                                       [[dic objectForKey:kShowVolumeAllKey] longLongValue],
                                       [[dic objectForKey:kShowVolumeNatureKey] longLongValue],
                                       [[dic objectForKey:kShowVolumeExtendKey] longLongValue],
                                       [[dic objectForKey:@"type"] intValue]];
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

- (void)saveDate:(NSArray *)data {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        for (int i = 0; i < [data count]; i++) {
            NSDictionary *dic = [data objectAtIndex:i];
            NSString *insertSql = [NSString stringWithFormat:@"insert into ProductData values('%@', '%@', %lld, %lld, %lld, %d)",
                                   [dic objectForKey:@"statisticsTime"],
                                   [dic objectForKey:@"productId"],
                                   [[dic objectForKey:kShowVolumeAllKey] longLongValue],
                                   [[dic objectForKey:kShowVolumeNatureKey] longLongValue],
                                   [[dic objectForKey:kShowVolumeExtendKey] longLongValue],
                                   [[dic objectForKey:@"type"] intValue]];
            [database executeUpdate:insertSql];
            
            insertSql = [NSString stringWithFormat:@"replace into ProductList values('%@', '%@')",
                         [dic objectForKey:@"productId"],
                         [dic objectForKey:@"productName"]];
            [database executeUpdate:insertSql];
        }
        [database commit];

    }];
}

- (BOOL)hasAnyData {
    __block int totalCount = 0;
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *queryStr = @"SELECT COUNT(*) FROM ProductData";
        FMResultSet *s = [database executeQuery:queryStr];
        if ([s next]) {
            totalCount = [s intForColumnIndex:0];
        }
    }];
    
    if (totalCount == 0) {
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
        endDateStr = stringWithDate(yesterday);
        startDateStr = stringWithDate([yesterday dateByAddingTimeInterval:- 24 * 60 * 60 * 13]);
        willShowDate = yesterday;
        return NO;
    }
    return YES;
}

- (NSString *) productNameWithId:(NSString *)productId {
    return [productListDic objectForKey:productId];
}

- (void)reloadData {
    [self clearContainer];
    
    for (int i = 0;i<14 ;i++){
        [orderDataArr addObject:[NSNumber numberWithInt:arc4random() % 10000]];
        [unsubscribeDataArr addObject:[NSNumber numberWithInt:arc4random() % 10000]];
        [flowDataArr addObject:[NSNumber numberWithInt:arc4random() % 10000]];
        
    }
    return;
    
    if (self.currentProductId.length == 0) {
        return;
    }
    
    [productListDic setObject:@"总量" forKey:@"all"];
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        
        NSString *selectSql = nil;
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        
        if (self.dimensionType == DimensionType_Product) {
            for (int i = 0; i < kDateSpan; i++) {
                for (int type = 0; type < 3; type++) {
                    long long value = 0;
                    selectSql = [NSString stringWithFormat:@"SELECT %@ FROM ProductData WHERE productId = '%@' AND date = '%@' AND type=%d",[self timesKey], self.currentProductId , stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (kDateSpan - i - 1) * 3600 * 24]), type];
                    FMResultSet *result = [database executeQuery:selectSql];
                    if ([result next]) {
                        value = [result longLongIntForColumn:[self timesKey]];
                    }
                    switch (type) {
                        case 0:
                            [orderDataArr addObject:[NSNumber numberWithLongLong:value]];
                            break;
                        case 1:
                            [unsubscribeDataArr addObject:[NSNumber numberWithLongLong:value]];
                            break;
                        case 2:
                            [flowDataArr addObject:[NSNumber numberWithLongLong:value]];
                            break;
                            
                        default:
                            break;
                    }
                }
            }

        }
        else if (self.dimensionType == DimensionType_All) {
            for (int i = 0; i < kDateSpan; i++) {
                for (int type = 0; type < 3; type++) {
                    long long value = 0;
                    selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE date = '%@' AND type=%d",kShowVolumeAllKey ,kProductTableName , stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (kDateSpan - i - 1) * 3600 * 24]), type];
                    FMResultSet *result = [database executeQuery:selectSql];
                    while ([result next]) {
                       value += [result longLongIntForColumn:kShowVolumeAllKey];
                    }
                    switch (type) {
                        case 0:
                            if (isGuest()) {
                                value = arc4random() % 5000;
                            }
                            [orderDataArr addObject:[NSNumber numberWithLongLong:value]];
                            break;
                        case 1:
                            if (isGuest()) {
                                value = arc4random() % 200;
                            }
                            [unsubscribeDataArr addObject:[NSNumber numberWithLongLong:value]];
                            break;
                        case 2:
                            if (isGuest()) {
                                value = arc4random() % 1000000000;
                            }
                            [flowDataArr addObject:[NSNumber numberWithLongLong:value]];
                            break;
                            
                        default:
                            break;
                    }
                }
            }

        }
        else if (self.dimensionType == DimensionType_Plat) {
            for (int i = 0; i < kDateSpan; i++) {
                for (int type = 0; type < 3; type++) {
                    long long value = 0;
                    selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@' AND date = '%@' AND type=%d",[self timesKey], kPlatTableName, kPlatIdKey,                     self.platIds[self.currentPlatIndex], stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (kDateSpan - i - 1) * 3600 * 24]), type];
                    FMResultSet *result = [database executeQuery:selectSql];
                    if ([result next]) {
                        value = [result longLongIntForColumn:[self timesKey]];
                    }
                    switch (type) {
                        case 0:
                            if (isGuest()) {
                                value = arc4random() % 5000;
                            }
                            [orderDataArr addObject:[NSNumber numberWithLongLong:value]];
                            break;
                        case 1:
                            if (isGuest()) {
                                value = arc4random() % 200;
                            }
                            [unsubscribeDataArr addObject:[NSNumber numberWithLongLong:value]];
                            break;
                        case 2:
                            if (isGuest()) {
                                 value = arc4random() % 1000000000;
                            }
                            [flowDataArr addObject:[NSNumber numberWithLongLong:value]];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
            
        }
        
        selectSql = @"SELECT * FROM productList";
       FMResultSet *result = [database executeQuery:selectSql];
        while ([result next]) {
            [productListDic setObject:[result stringForColumn:@"productName"] forKey:[result stringForColumn:@"productId"]];
        }
        
        selectSql = [NSString stringWithFormat:@"SELECT DISTINCT %@,%@ FROM %@", kPlatIdKey, kPlatNameKey, kPlatTableName];
        FMResultSet *platIdAndName = [database executeQuery:selectSql];
        while (platIdAndName.next) {
            [platIdAndNameDic setValue:[platIdAndName stringForColumn:kPlatNameKey] forKey:[platIdAndName stringForColumn:kPlatIdKey]];
        }
        
        [database commit];
    }];
}

#pragma mark read only

- (NSString *)currentDimensionName {
    if (self.dimensionType == DimensionType_Plat) {
        return [self platNameWithId:self.platIds[self.currentPlatIndex]];
    }
    else {
        return [self productNameWithId:self.currentProductId];
        
    }
}

- (NSArray *)platIds {
    return [platIdAndNameDic allKeys];
}

- (NSString *)platNameWithId:(NSString *)platId{
   return [platIdAndNameDic objectForKey:platId];
}

- (NSString *)timesKey {
    NSString *ret = nil;
    switch (self.showType) {
        case 0:
            ret = kShowVolumeAllKey;
            break;
        case 1:
            ret = kShowVolumeNatureKey;
            break;
        case 2:
            ret = kShowVolumeExtendKey;
            break;
        default:
            break;
    }
    return ret;
}

- (NSString *)unitStr {
    NSString *ret = nil;
    if (self.currentTypeId <= 1) {
        ret = @"次";
    }
    else if (self.currentTypeId == 2) {
        ret = @"GB";
    }
    return ret;
}

- (NSString *)currentTypeName {
    NSString *ret = nil;
    switch (self.currentTypeId) {
        case 0:
            ret = @"订购同环比";
            break;
        case 1:
            ret = @"退订同环比";
            break;
        case 2:
            ret = @"流量同环比";
            break;
            
        default:
            break;
    }
    return ret;
}

- (NSArray *)dateStrs {
    NSMutableArray *ret = [NSMutableArray array];
    int timestamp = [lastDate timeIntervalSince1970];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    for (int i = 0; i < kDateSpan; i++) {
        [ret addObject:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp - (kDateSpan - 1 - i) * 3600 * 24]]];
    }
    return ret;
}

- (long long)minValue {
    NSArray *originArr = nil;
    
        switch (self.currentTypeId) {
            case 0:
                originArr = self.orderDatas;
                break;
            case 1:
                originArr = self.unsubscribeDatas;
                break;
            case 2:
                originArr = self.flowDatas;
                break;
            default:
                break;
        }
    
    NSArray *sortArr = [originArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 longLongValue] > [obj2 longLongValue]) {
            return  NSOrderedAscending;
        }
        else {
            return  NSOrderedDescending;
        }
        
    }];

    return [[sortArr lastObject] longLongValue];
}

- (long long)maxValue {
    NSArray *originArr = nil;
    switch (self.currentTypeId) {
        case 0:
            originArr = self.orderDatas;
            break;
        case 1:
            originArr = self.unsubscribeDatas;
            break;
        case 2:
            originArr = self.flowDatas;
            break;
        default:
            break;
    }
    
    NSArray *sortArr = [originArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 longLongValue] > [obj2 longLongValue]) {
            return  NSOrderedAscending;
        }
        else {
            return  NSOrderedDescending;
        }
        
    }];
    return [[sortArr firstObject] longLongValue];
}

- (long long)dayCompareValueWith:(int)type {
    long long ret = 0;
    switch (type) {
        case 0:
            ret = [[self.orderDatas objectAtIndex:kDateSpan - 2] longLongValue];
            break;
        case 1:
            ret = [[self.unsubscribeDatas objectAtIndex:kDateSpan - 2] longLongValue];
            break;
        case 2:
            ret = [[self.flowDatas objectAtIndex:kDateSpan - 2] longLongValue];
            break;
        default:
            break;
    }
    return ret;

}


- (long long)weakCompareValueWith:(int)type {
    long long ret = 0;
    switch (type) {
        case 0:
            ret = [[self.orderDatas objectAtIndex:6] longLongValue];
            break;
        case 1:
            ret = [[self.unsubscribeDatas objectAtIndex:6] longLongValue];
            break;
        case 2:
            ret = [[self.flowDatas objectAtIndex:6] longLongValue];
            break;
        default:
            break;
    }
    return ret;

}

- (long long)compareValueWith:(int)type {
    long long ret = 0;
    switch (type) {
        case 0:
            ret = [[self.orderDatas objectAtIndex:6] longLongValue];
            break;
        case 1:
            ret = [[self.orderDatas objectAtIndex:kDateSpan - 2] longLongValue];
            break;
        case 2:
            ret = [[self.unsubscribeDatas objectAtIndex:6] longLongValue];
            break;
        case 3:
            ret = [[self.unsubscribeDatas objectAtIndex:kDateSpan - 2] longLongValue];
            break;
        case 4:
            ret = [[self.flowDatas objectAtIndex:6] longLongValue];
            break;
        case 5:
            ret = [[self.flowDatas objectAtIndex:kDateSpan - 2] longLongValue];
            break;
        default:
            break;
    }
    return ret;
}

- (long long)currentValueWith:(int)type {
    long long ret = 0;
    switch (type) {
        case 0:
           ret = [[self.orderDatas lastObject] longLongValue];
            break;
        case 1:
           ret = [[self.unsubscribeDatas lastObject] longLongValue];
            break;
        case 2:
           ret = [[self.flowDatas lastObject] longLongValue];
            break;
        default:
            break;
    }
    return ret;
}

- (NSArray *)productIds {
    
    NSMutableArray *ret = [NSMutableArray array];
    [ret addObject:@"all"];
    [ret addObjectsFromArray:[productListDic allKeys]];
    
    return ret;
}

- (NSArray *)orderDatas {
    return  orderDataArr;
}

- (NSArray *)unsubscribeDatas {
    return unsubscribeDataArr;
}

- (NSArray *)flowDatas {
    return flowDataArr;
}

- (BOOL)isCompareWeek {
    return (self.currentTypeId % 2 == 0);
}

- (NSString *)currentDayStr {
    return stringWithDate(lastDate);
}


- (BOOL)needUpdateData {
    return YES;
}

#pragma overload

- (NSDictionary *)configParams {
    return @{@"dataType":[NSNumber numberWithInt:0],
             @"startDate":startDateStr,
             @"endDate":endDateStr};
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
    NSDictionary *dataContent = (NSDictionary *)response[0];
    NSArray *plats = dataContent[kPlatKey];
    NSArray *products = dataContent[kProductKey];
    if ([response isKindOfClass:[NSArray class]] && ([products count] != 0 || [plats count] != 0)) {
        lastDate = willShowDate;
        _result = NetworkBaseResult_Success;
        _resultInfo = @"成功获取网络数据";
        responeData = response;
    }
}

@end
