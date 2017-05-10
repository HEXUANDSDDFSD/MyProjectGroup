//
//  LoginUserChannelCtr.m
//  tysx
//
//  Created by zwc on 14/11/26.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXLoginUserChannelCtr.h"
#import "DatabaseManager.h"

@implementation TYSXLoginUserChannelCtr {
    NSMutableArray *_channelList;
    NSMutableArray *_selectedChannelLoginTimes;
    NSMutableArray *_sumChannelLoginTimes;
    NSInteger _currentChannelIndex;
}

- (void)setCurrentChannelIndex:(NSInteger)currentChannelIndex {
    
    if (currentChannelIndex < 0 || currentChannelIndex >= [self.channelList count]) {
        return;
    }
    
    if (_currentChannelIndex != currentChannelIndex) {
        _currentChannelIndex = currentChannelIndex;
        [self reloadCurrentList];
    }
}

- (NSInteger)currentChannelIndex {
    return _currentChannelIndex;
}

- (NSArray *)channelList {
    return _channelList;
}

- (NSArray *)selectedChannelLoginTimes {
    return _selectedChannelLoginTimes;
}

- (NSArray *)sumChannelLoginTimes {
    return _sumChannelLoginTimes;
}

- (NSString *)databaseTableName {
    return @"tysx_login_user_channel";
}

- (int)dataType {
    return 14;
}

- (void)createDatabase {
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                               %@ varchar(20),\
                               %@ varchar(50),\
                               %@ varchar(100),\
                               %@ bigint,\
                               PRIMARY KEY (%@, %@)\
                               )", [self databaseTableName], kDateKey, kChannelIdKey, kChannelNameKey, kLoginTimesKey, kDateKey, kChannelIdKey];
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
        NSArray *channelData = (NSArray *)responeData;
        for (int i = 0; i < [channelData count]; i++) {
            NSDictionary *dic = [channelData objectAtIndex:i];
            NSString *insertSql = [NSString stringWithFormat:@"insert into %@ values('%@', '%@', '%@', %lld)",
                                   [self databaseTableName],
                                   [dic objectForKey:@"loginTime"],
                                   [dic objectForKey:kChannelIdKey],
                                   [dic objectForKey:kChannelNameKey],
                                   [[dic objectForKey:kLoginTimesKey] longLongValue]];
            [database executeUpdate:insertSql];
        }
    
        [database commit];
        
    }];
}

- (void)reloadCurrentList {
    [_selectedChannelLoginTimes removeAllObjects];
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        
        NSString *currentChannelId = @"";
        
        if ([self.channelList count] != 0) {
            currentChannelId   = [self.channelList[self.currentChannelIndex] objectForKey:kChannelIdKey];
        }
        
        for (int i = 0; i < kDateSpan; i++) {;
            NSString *selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@='%@' AND %@='%@'", kLoginTimesKey, [self databaseTableName], kDateKey,             stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (kDateSpan - i - 1) * 3600 * 24]), kChannelIdKey, currentChannelId];
            FMResultSet *currentChannelList = [database executeQuery:selectSql];
            
            long long currentTimes = 0;
            if (currentChannelList.next) {
                currentTimes = [currentChannelList longLongIntForColumn:kLoginTimesKey];
            }
            [_selectedChannelLoginTimes addObject:[NSNumber numberWithLongLong:currentTimes]];
        }
        
        [database commit];
    }];
}

- (void)reloadData {
    [super reloadData];
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
       NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@,%@ FROM %@ WHERE %@='%@'", kChannelIdKey, kChannelNameKey, kLoginTimesKey, [self databaseTableName], kDateKey, self.lastDateStr];
        FMResultSet *channelList = [database executeQuery:selectSql];
        while (channelList.next) {
            NSMutableDictionary *channelDic = [NSMutableDictionary dictionary];
            [channelDic setValue:[channelList stringForColumn:kChannelIdKey] forKey:kChannelIdKey];
            [channelDic setValue:[channelList stringForColumn:kChannelNameKey] forKey:kChannelNameKey];
            [channelDic setValue:[NSNumber numberWithLongLong:[channelList longLongIntForColumn:kLoginTimesKey]] forKey:kLoginTimesKey];
            [_channelList addObject:channelDic];
        }
        
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        for (int i = 0; i < kDateSpan; i++) {;
            selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@='%@'", kLoginTimesKey, [self databaseTableName], kDateKey,             stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (kDateSpan - i - 1) * 3600 * 24])];
            FMResultSet *channelList = [database executeQuery:selectSql];
            long long sumTimes = 0;
            while (channelList.next) {
                sumTimes += [channelList longLongIntForColumn:kLoginTimesKey];
            }
            [_sumChannelLoginTimes addObject:[NSNumber numberWithLongLong:sumTimes]];
        }
        
        [database commit];
    }];
    [self reloadCurrentList];
}

- (void)allocDataContainer {
    _channelList = [NSMutableArray array];
    _selectedChannelLoginTimes = [NSMutableArray array];
    _sumChannelLoginTimes = [NSMutableArray array];
}

- (void)clearDataContainer {
    [_channelList removeAllObjects];
    [_selectedChannelLoginTimes removeAllObjects];
    [_sumChannelLoginTimes removeAllObjects];
}

@end
