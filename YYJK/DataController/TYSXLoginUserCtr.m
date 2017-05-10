//
//  TYSXLoginUserCtr.m
//  tysx
//
//  Created by zwc on 14/11/25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXLoginUserCtr.h"

#define kClientTypeKey @"clientType"
#define kOldLoginTimesKey @"countctld2"
#define kNewLoginTimesKey @"countctld3"
#define kOldOrderTimesKey @"oldOrderTimes"
#define kNewOrderTimesKey @"newOrderTimes"
#define kOldPlayTimesKey @"oldplaytimes"
#define kNewPlayTimesKey @"newplaytimes"

@implementation TYSXLoginUserCtr {
    NSMutableArray *_clientList;
    NSMutableArray *_loginUserNumList;
    NSMutableArray *_loginList;
    NSMutableArray *_playList;
    NSMutableArray *_orderList;
}

- (void)setSelectedPlatIndex:(NSInteger)selectedPlatIndex {
    if (selectedPlatIndex != _selectedPlatIndex) {
        _selectedPlatIndex = selectedPlatIndex;
        [self reloadCurrentClientList];
    }
}

- (NSArray *)clientInfoList {
    if  (kNeedVirtualData) {
        return @[@{kClientTypeKey:@1, kClientNameKey:@"平台1"},
                 @{kClientTypeKey:@2, kClientNameKey:@"平台2"},
                 @{kClientTypeKey:@9, kClientNameKey:@"平台3"},
                 @{kClientTypeKey:@10, kClientNameKey:@"平台4"},
                 @{kClientTypeKey:@20, kClientNameKey:@"平台5"},
                 @{kClientTypeKey:@99, kClientNameKey:@"平台6"}];
    }
    return @[@{kClientTypeKey:@1, kClientNameKey:@"WAP"},
             @{kClientTypeKey:@2, kClientNameKey:@"1.x 2.x"},
             @{kClientTypeKey:@9, kClientNameKey:@"3.x"},
             @{kClientTypeKey:@10, kClientNameKey:@"4.x"},
             @{kClientTypeKey:@20, kClientNameKey:@"5.x"},
             @{kClientTypeKey:@99, kClientNameKey:@"其他平台"}];
}

- (NSArray *)loginList {
    return _loginList;
}

- (NSArray *)loginUserNumList {
    return _loginUserNumList;
}

- (NSArray *)playList {
    return _playList;
}

- (NSArray *)orderList {
    return _orderList;
}

- (NSString *)databaseTableName {
    return @"tysx_login_user";
}

- (void)createDatabase {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                               %@ varchar(20),\
                               %@ int,\
                               %@ bigint,\
                               %@ bigint,\
                               %@ bigint,\
                               %@ bigint,\
                               %@ bigint,\
                               %@ bigint,\
                               %@ bigint,\
                               %@ double,\
                               %@ double,\
                               PRIMARY KEY (%@, %@)\
                               )", [self databaseTableName], kDateKey, kClientTypeKey, kSumLoginKey, kOldLoginTimesKey, kNewLoginTimesKey, kOldOrderTimesKey, kNewOrderTimesKey, kOldPlayTimesKey, kNewPlayTimesKey, kTongbiKey, kHuanbiKey, kDateKey, kClientTypeKey];
        [database executeUpdate:createSql];
    }];
}

- (int)dataType {
    return 11;
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
            NSString *insertSql = [NSString stringWithFormat:@"insert into %@ values('%@', %d, %lld, %lld, %lld, %lld, %lld, %lld, %lld, %f, %f)",
                                   [self databaseTableName],
                                   [dic objectForKey:@"loginDate"],
                                   [[dic objectForKey:kClientTypeKey] intValue],
                                   [[dic objectForKey:kSumLoginKey] longLongValue],
                                   [[dic objectForKey:kOldLoginTimesKey] longLongValue],
                                   [[dic objectForKey:kNewLoginTimesKey] longLongValue],
                                   [[dic objectForKey:kOldOrderTimesKey] longLongValue],
                                   [[dic objectForKey:kNewLoginTimesKey] longLongValue],
                                   [[dic objectForKey:kOldPlayTimesKey] longLongValue],
                                   [[dic objectForKey:kNewPlayTimesKey] longLongValue],
                                   [[dic objectForKey:kTongbiKey] doubleValue],
                                   [[dic objectForKey:kHuanbiKey] doubleValue]];
            [database executeUpdate:insertSql];
        }
        
        [database commit];
        
    }];
}

- (void)reloadData {
    [super reloadData];
    
    if (kNeedVirtualData) {
        for (int i = 0; i < [[self clientInfoList] count]; i++) {
            NSMutableDictionary *clientDic = [NSMutableDictionary dictionary];
            [clientDic setValue:[self clientInfoList][i][kClientNameKey] forKey:kClientNameKey];
            [clientDic setValue:[NSNumber numberWithLongLong:arc4random() % 100000] forKey:kSumLoginKey];
            [clientDic setValue:[NSNumber numberWithDouble:arc4random() % 100 / 50.0] forKey:kTongbiKey];
            [clientDic setValue:[NSNumber numberWithDouble:arc4random() % 100 / 50.0] forKey:kHuanbiKey];
            [_clientList addObject:clientDic];
        }
            [self reloadCurrentClientList];
        return;
    }
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        
        NSString *selectSql = nil;
        
        for (int i = 0; i < [[self clientInfoList] count]; i++) {
            NSMutableDictionary *clientDic = [NSMutableDictionary dictionary];
            selectSql = [NSString stringWithFormat:@"SELECT %@,%@,%@ FROM %@ WHERE %@='%@' AND %@=%d", kSumLoginKey, kTongbiKey, kHuanbiKey, [self databaseTableName], kDateKey, self.lastDateStr, kClientTypeKey, [[self clientInfoList][i][kClientTypeKey] intValue]];
            [clientDic setValue:[self clientInfoList][i][kClientNameKey] forKey:kClientNameKey];
            long long sumValue = 0;
            double tongbi = 0;
            double huanbi = 0;
            FMResultSet *clientInfo = [database executeQuery:selectSql];
            if (clientInfo.next) {
                sumValue = [clientInfo longLongIntForColumn:kSumLoginKey];
                tongbi = [clientInfo doubleForColumnIndex:kTongbiKey];
                huanbi = [clientInfo doubleForColumnIndex:kHuanbiKey];
            }
            [clientDic setValue:[NSNumber numberWithLongLong:sumValue] forKey:kSumLoginKey];
            [clientDic setValue:[NSNumber numberWithDouble:tongbi] forKey:kTongbiKey];
            [clientDic setValue:[NSNumber numberWithDouble:huanbi] forKey:kHuanbiKey];
            [_clientList addObject:clientDic];
        }
        
        [database commit];
    }];
    [self reloadCurrentClientList];
}

- (void)reloadCurrentClientList {
    [_loginList removeAllObjects];
    [_orderList removeAllObjects];
    [_loginUserNumList removeAllObjects];
    [_playList removeAllObjects];
    
    if (kNeedVirtualData) {
        for (int i = 0; i < kDateSpan; i++) {
            [_loginUserNumList addObject:@(arc4random() % 100 + 100)];
            [_orderList addObject:@{kOldKey:@(arc4random() % 100),kNewKey:@(arc4random() % 100)}];
            [_loginList addObject:@{kOldKey:@(arc4random() % 100),kNewKey:@(arc4random() % 100)}];
            [_playList addObject:@{kOldKey:@(arc4random() % 100),kNewKey:@(arc4random() % 100)}];
        }
        return;
    }
    
    int currentType = [[self clientInfoList][_selectedPlatIndex][kClientTypeKey] intValue];
    NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        for (int i = 0; i < kDateSpan; i++) {
            NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@,%@ FROM %@ WHERE %@='%@' AND %@=%d", kSumLoginKey, kOldLoginTimesKey, kNewLoginTimesKey, kOldOrderTimesKey, kNewOrderTimesKey, kOldPlayTimesKey, kNewPlayTimesKey, [self databaseTableName], kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (kDateSpan - i - 1) * 3600 * 24]), kClientTypeKey, currentType];
            FMResultSet *clientInfo = [database executeQuery:selectSql];
            long long sumValue = 0;
            long long oldPlayValue = 0;
            long long newPlayValue = 0;
            long long oldOrderValue = 0;
            long long newOrderValue = 0;
            long long oldLoginValue = 0;
            long long newLoginValue = 0;
            if (clientInfo.next) {
                sumValue = [clientInfo longLongIntForColumn:kSumLoginKey];
                oldPlayValue = [clientInfo longLongIntForColumn:kOldPlayTimesKey];
                newPlayValue = [clientInfo longLongIntForColumn:kNewPlayTimesKey];
                oldOrderValue = [clientInfo longLongIntForColumn:kOldOrderTimesKey];
                newOrderValue = [clientInfo longLongIntForColumn:kNewOrderTimesKey];
                oldLoginValue = [clientInfo longLongIntForColumn:kOldLoginTimesKey];
                newLoginValue = [clientInfo longLongIntForColumn:kNewLoginTimesKey];
            }
            [_loginUserNumList addObject:[NSNumber numberWithLongLong:sumValue]];
            [_orderList addObject:@{kNewKey:[NSNumber numberWithLongLong:newOrderValue], kOldKey:[NSNumber numberWithLongLong:oldOrderValue]}];
            [_playList addObject:@{kNewKey:[NSNumber numberWithLongLong:newPlayValue], kOldKey:[NSNumber numberWithLongLong:oldPlayValue]}];
            [_loginList addObject:@{kNewKey:[NSNumber numberWithLongLong:newLoginValue], kOldKey:[NSNumber numberWithLongLong:oldLoginValue]}];
        }
//        NSLog(@"%@", _loginUserNumList);
//        NSLog(@"%@", _orderList);
//        NSLog(@"%@", _playList);
//        NSLog(@"%@", _loginList);
        [database commit];
    }];
}

- (void)allocDataContainer {
    _clientList = [NSMutableArray array];
    _loginList = [NSMutableArray array];
    _loginUserNumList = [NSMutableArray array];
    _playList = [NSMutableArray array];
    _orderList = [NSMutableArray array];
}

- (void)clearDataContainer {
    [_clientList removeAllObjects];
    [_loginUserNumList removeAllObjects];
    [_loginList removeAllObjects];
    [_playList removeAllObjects];
    [_orderList removeAllObjects];}

@end
