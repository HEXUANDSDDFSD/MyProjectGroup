//
//  HXProvinceDataCtr.m
//  tysx
//
//  Created by zwc on 13-11-29.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "TYSXProvinceDataCtr.h"
#import "NSString+JSONCategory.h"
#import "DatabaseManager.h"
#import "OSSMemberCache.h"
#import "GCD+EXPAND.h"
#import "FMDatabase.h"
#import "MKNetworkEngine.h"

#define kShowVolumeAllName @"Volume_all"
#define kShowVolumeNaturalName @"Volume_natural"
#define kShowVolumeExtendName @"Volume_extend"


@implementation TYSXProvinceDataCtr {
    NSMutableDictionary *buttonTagAndName;
    NSDictionary *orderDictionary;
    NSDictionary *unsubscribeDictionary;
    NSDictionary *flowDictionary;
    NSMutableArray *_orderRank;
    NSMutableArray *_unsubscribeRank;
    NSMutableArray  *_flowRank;
    NSString *_currentDateStr;
    BOOL hasNetWorkData_;
    
    NSString *startDateStr;
    NSString *endDateStr;
    NSMutableArray *orderValues;
    NSMutableArray *unsubscribeValues;
    NSMutableArray *flowValues;
}
@synthesize refreshAction;
@synthesize needUpdateDate;

- (id)init {
    if (self = [super init]) {
        self.currentProvinceId = 1001;
        self.updateDataType = UpdateDataType_Day;
        
        _currentDateStr = USER_DFT.lastProvinceDateStr;
        if (_currentDateStr == nil) {
            _currentDateStr = stringWithDate([NSDate dateWithTimeIntervalSinceNow:-(24*60*60)]);
        }
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        self.needUpdateDate = [dateformatter dateFromString:_currentDateStr];
        
        NSArray *imgNameArr = [NSArray arrayWithObjects:@"yunnan", @"neimenggu", @"shanxi", @"sanxi", @"shanghai", @"beijing", @"jilin", @"sichuan", @"tianjin", @"ningxia", @"anhui", @"shandong", @"guangdong", @"guangxi", @"xinjiang", @"jiangsu", @"jiangxi", @"hebei", @"henan", @"zhejiang", @"hainan", @"hubei", @"hunan", @"gansu", @"fujian", @"xizang", @"guizhou", @"liaoning", @"chongqing", @"qinghai", @"heilongjiang",nil];
        NSArray *nameArr = [NSArray arrayWithObjects:@"云南", @"内蒙古", @"山西", @"陕西", @"上海", @"北京", @"吉林", @"四川", @"天津", @"宁夏", @"安徽", @"山东", @"广东", @"广西", @"新疆", @"江苏", @"江西", @"河北", @"河南", @"浙江", @"海南", @"湖北", @"湖南", @"甘肃", @"福建", @"西藏", @"贵州", @"辽宁", @"重庆", @"青海", @"黑龙江",nil];
        buttonTagAndName = [NSMutableDictionary dictionary];
        for (int i = 0; i < [imgNameArr count]; i++) {
            [buttonTagAndName setValue:[NSDictionary dictionaryWithObjectsAndKeys:[imgNameArr objectAtIndex:i],@"imgName",[nameArr objectAtIndex:i],@"name", nil] forKey:[NSString stringWithFormat:@"%d", i + 1001]];
        }
        
        [self createTable];
        [self allocContainer];
        [self reloadProvinceData];
    }
    return self;
}

- (NSDictionary *)tempDataWithType:(int)type {
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    for (int i = 0; i < [[self sourceData] count]; i++) {
        NSArray *array = [self sourceData][i];
        [ret setValue:array[type + 1] forKeyPath:array[0]];
    }
    
    NSArray *keys = [ret keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 doubleValue] < [obj2 doubleValue];
    }];
    
    NSMutableArray *randArray = nil;
    switch (type) {
        case 0:
            randArray = _orderRank;
            break;
        case 1:
            randArray = _unsubscribeRank;
            break;
        case 2:
            randArray = _flowRank;
            break;
            
        default:
            break;
    }
    
    for (int i = 0; i < 5; i++) {
        [randArray addObject:@{@"province": keys[i], @"volume": ret[keys[i]]}];
    }
    
    return ret;
}

- (NSArray *)sourceData {
   return @[
      @[@"天津", @14370.16	,@1413.15, @101688.85],
    @[@"北京", @19500.6, @2069.3, @94237.66],
    @[@"上海",	@21602.12, @2380.43, @90748.81],
      @[@"江苏", @59161.75, @7919.98 ,@74699.37],
    @[@"浙江", @37568.49	,@5477	,@68593.19],
    @[@"内蒙古",	@16832.38	,@2489.85	,@67603.99],
    @[@"辽宁",	@27077.7	,@4389	,@61694.46],
    @[@"广东",	@62163.97	,@10594	,@58678.47],
    @[@"福建",	@21759.64	,@3748	,@58056.67],
    @[@"山东",	@54684.3	,@9684.87	,@56463.64],
    @[@"吉林",	@12981.46	,@2761	,@47017.24],
    @[@"重庆",	@12656.69	,@2945	,@42976.88],
    @[@"陕西",	@16045.21	,@3753.09	,@42752],
    @[@"湖北",	@24668.49	,@5779	,@42686.43],
    @[@"宁夏",	@2600	,@647.19	,@40173.67],
    @[@"河北",	@28301.4	,@7287.51	,@38835.49],
    @[@"黑龙江",	@14800	,@3834	,@38601.98],
    @[@"新疆",	@8510	,@2232.78	,@38113.92],
    @[@"湖南",	@24501.7	,@6638.9	,@36906.26],
    @[@"青海",	@2101.05	,@573.17	,@36656.66],
    @[@"海南",	@3146.46	,@886.55	,@35491.06],
    @[@"山西",	@12602.2	,@3610.83	,@34901.12],
    @[@"河南",	@32155.86	,@9406	,@34186.54],
    @[@"四川",	@26260.77	,@8076.2	,@32516.25],
    @[@"江西",	@14338.5	,@4503.93	,@31835.53],
    @[@"安徽",	@19038.9	,@5988	,@31795.09],
    @[@"广西",	@14378	,@4682	,@30709.1],
    @[@"西藏",	@802	,@308	,@26038.96],
    @[@"云南",	@11720.91	,@4659	,@25157.57],
    @[@"甘肃",	@6300	,@2553.9	,@24668.15],
      @[@"贵州",	@8006.79	,@3484	,@22981.6]];
}

- (void)allocContainer {
    _orderRank = [NSMutableArray array];
    _unsubscribeRank = [NSMutableArray array];
    _flowRank = [NSMutableArray array];
    orderValues = [NSMutableArray array];
    unsubscribeValues = [NSMutableArray array];
    flowValues = [NSMutableArray array];
}

- (void)cleanContainer {
    if (self.updateDataType == UpdateDataType_Day) {
        [_orderRank removeAllObjects];
        [_unsubscribeRank removeAllObjects];
        [_flowRank removeAllObjects];
    }
    else if (self.updateDataType == UpdateDataType_Date) {
        [orderValues removeAllObjects];
        [unsubscribeValues removeAllObjects];
        [flowValues removeAllObjects];
    }
}

- (void)dealloc {
    USER_DFT.lastProvinceDateStr = self.currentDateStr;
}

- (NSString *)volumeName {
    NSString *ret = nil;
    switch (self.showDataType) {
        case 0:
            ret = kShowVolumeAllName;
            break;
        case 1:
            ret = kShowVolumeNaturalName;
            break;
        case 2:
            ret = kShowVolumeExtendName;
            break;
        default:
            break;
    }
    return ret;
}

#pragma mark readonly

- (long long)minValue {
    NSArray *originArr = nil;
    switch (self.currentTypeId) {
        case 0:
            originArr = self.orderValueList;
            break;
        case 1:
            originArr = self.unsubscribeValueList;
            break;
        case 2:
            originArr = self.flowValueList;
            break;
        default:
            break;
    }
    
    NSArray *sortArr = [originArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 longLongValue] <= [obj2 longLongValue]) {
            return  NSOrderedAscending;
        }
        else {
            return  NSOrderedDescending;
        }
        
    }];
    
    return [[sortArr firstObject] longLongValue];
}

- (long long)maxValue {
    NSArray *originArr = nil;
    switch (self.currentTypeId) {
        case 0:
            originArr = self.orderValueList;
            break;
        case 1:
            originArr = self.unsubscribeValueList;
            break;
        case 2:
            originArr = self.flowValueList;
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

- (NSArray *)dateList {
    NSMutableArray *ret = [NSMutableArray array];
    int timeInterval = [self.needUpdateDate timeIntervalSince1970];
    for (int i = 0; i < 30; i++){
        [ret insertObject:stringWithDate([NSDate dateWithTimeIntervalSince1970:timeInterval - 3600 * 24 * i]) atIndex:0];
    }
    return ret;
}

- (NSArray *)orderValueList {
    return orderValues;
}

- (NSArray *)unsubscribeValueList {
    return unsubscribeValues;
}

- (NSArray *)flowValueList {
    return flowValues;
}

- (BOOL)hasNetWorkData {
    return hasNetWorkData_;
}

- (NSString *)currentDateStr {
    return _currentDateStr;
}

- (NSString *)currentProvinceName {
    NSDictionary *dic = [buttonTagAndName objectForKey:[NSString stringWithFormat:@"%d", self.currentProvinceId]];
    return [dic objectForKey:@"name"];
}

- (NSNumber *)currentFlowValue {
    return [flowDictionary objectForKey:self.currentProvinceName];
}

- (NSNumber *)currentOrderValue {
    return [orderDictionary objectForKey:self.currentProvinceName];
}

- (NSNumber *)currentUnsubscribeValue {
    return [unsubscribeDictionary objectForKey:self.currentProvinceName];
}

- (NSArray *)orderRank {
    return _orderRank;
}

- (NSArray *)unsubscribeRank {
    return _unsubscribeRank;
}

- (NSArray *)flowRank {
    return _flowRank;
}

- (void)reloadProvinceData {
    [self cleanContainer];
    if (/* DISABLES CODE */ (1) || [OSSMemberCache shareCache].organizationType == OrganizationType_Guest ||
        [OSSMemberCache shareCache].organizationType == OrganizationType_HUANGJIA) {
        orderDictionary = [self tempDataWithType:0];
        unsubscribeDictionary = [self tempDataWithType:1];
        flowDictionary = [self tempDataWithType:2];
    }
    else if (self.updateDataType == UpdateDataType_Day) {
        orderDictionary = [self dicWithType:0];
        unsubscribeDictionary = [self dicWithType:1];
        flowDictionary = [self dicWithType:2];
    }
    else if (self.updateDataType == UpdateDataType_Date){
        [self reloadDateProvinceData];
    }
}

- (void)reloadDateProvinceData {
    [orderValues removeAllObjects];
    [unsubscribeValues removeAllObjects];
    [flowValues removeAllObjects];
    int timeInterval = [self.needUpdateDate timeIntervalSince1970];
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
    
    for (int i = 0; i < 30; i++) {
        for (int type = 0; type < 3; type++) {
            long long value = 0;
          NSString *selectSql = [NSString stringWithFormat:@"SELECT %@ FROM ProvinceData WHERE Province = '%@' AND date = '%@' AND type=%d",[self volumeName], self.currentProvinceName , stringWithDate([NSDate dateWithTimeIntervalSince1970:timeInterval - 3600 * 24 * (29 - i)]), type];
            FMResultSet *result = [database executeQuery:selectSql];
            if ([result next]) {
                value = [result longLongIntForColumn:[self volumeName]];
            }
            switch (type) {
                case 0:
                    [orderValues addObject:[NSNumber numberWithLongLong:value]];
                    break;
                case 1:
                    [unsubscribeValues addObject:[NSNumber numberWithLongLong:value]];
                    break;
                case 2:
                    [flowValues addObject:[NSNumber numberWithLongLong:value]];
                    break;
                    
                default:
                break;
            }
        }
    }
    }];
}

- (BOOL)isOverDate:(NSDate *)date {
    if ([date compare:[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)]] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

#pragma mark database

- (NSDictionary *)dicWithType:(int)type {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        NSString *selectStr = [NSString stringWithFormat:@"select Province,%@ from ProvinceData where date='%@' AND type=%d order by %@ desc",[self volumeName], [self currentDateStr], type, [self volumeName]];
        FMResultSet *result = [database executeQuery:selectStr];
        int i = 0;
        while ([result next]) {
            if (i < 5) {
                NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:[result longLongIntForColumn:[self volumeName]]],@"volume",[result stringForColumn:@"Province"],@"province", nil];
                switch (type) {
                    case 0:
                        [_orderRank addObject:tempDic];
                        break;
                    case 1:
                        [_unsubscribeRank addObject:tempDic];
                        break;
                    case 2:
                        [_flowRank addObject:tempDic];
                        break;
                    default:
                        break;
                }
                i++;
            }
            
            [dic setValue:[NSNumber numberWithLongLong:[result longLongIntForColumn:[self volumeName]]] forKey:[result stringForColumn:@"Province"]];
        }
        [database commit];
    }];
    
    return dic;
}

- (void)createTable {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS ProvinceData(\
                               date varchar(20),\
                               Province varchar(20),\
                               %@ bigint,\
                               %@ bigint,\
                               %@ bigint,\
                               type int,\
                               PRIMARY KEY (date,Province,type))", kShowVolumeAllName, kShowVolumeNaturalName, kShowVolumeExtendName];
//        NSString *createSql = @"CREATE TABLE IF NOT EXISTS ProvinceData(\
//        date varchar(20),\
//        Province varchar(20),\
//        Volume bigint,\
//        type int,\
//        PRIMARY KEY (date,Province,type))";
        [database executeUpdate:createSql];
    }];
}

- (BOOL)hasAnyData {
   __block int totalCount = 0;
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *queryStr = @"SELECT COUNT(*) FROM ProvinceData";
        FMResultSet *s = [database executeQuery:queryStr];
        if ([s next]) {
            totalCount = [s intForColumnIndex:0];
        }
    }];
    
    if (totalCount == 0) {
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
        self.needUpdateDate = yesterday;
        return NO;
    }
    return YES;
}

- (void)saveData:(NSDictionary *)dic {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        for (NSString *key in [dic allKeys]) {
            NSArray *entityArr = [dic objectForKey:key];
            int type = 0;
            if ([key isEqualToString:@"list"]) {
                type = 0;
            }
            else if ([key isEqualToString:@"list2"]) {
                type = 1;
            }
            else if ([key isEqualToString:@"list3"]) {
                type = 2;
            }
            for (int i = 1; i < [entityArr count]; i++) {
                NSString *dateStr = [[entityArr objectAtIndex:i] objectAtIndex:0];
                NSString *provinceName = [[entityArr objectAtIndex:i] objectAtIndex:1];
                long long volumn_all = [[[entityArr objectAtIndex:i] objectAtIndex:2] longLongValue];
                long long volumn_natural = [[[entityArr objectAtIndex:i] objectAtIndex:3] longLongValue];
                long long volumn_extend = [[[entityArr objectAtIndex:i] objectAtIndex:4] longLongValue];
                NSString *insertStr = [NSString stringWithFormat:@"INSERT INTO ProvinceData VALUES('%@', '%@',%lld,%lld,%lld,%d)", dateStr, provinceName,volumn_all,volumn_natural,volumn_extend,type];
                if (![database executeUpdate:insertStr]) {
                    NSLog(@"error at %@", provinceName);
                }
            }
        }
        [database commit];
    }];
}

- (BOOL)needNetworkData {
    if (self.updateDataType == UpdateDataType_Day) {
        return [self needDayNetorkData];
    }
    else if (self.updateDataType == UpdateDataType_Date) {
        return [self needDateNetworkData];
    }
    return NO;
}

- (BOOL)needDayNetorkData {
    BOOL ret = ![self hasLocalDataWithDateStr:stringWithDate(self.needUpdateDate)];
    if (!ret) {
        _currentDateStr = stringWithDate(self.needUpdateDate);
    }
    return ret;
}

- (BOOL)needDateNetworkData {
    startDateStr = nil;
    endDateStr = nil;
    int timeInterval = [self.needUpdateDate timeIntervalSince1970];
    for (int i = 0; i < 30; i++) {
        NSString *dateStr = stringWithDate([NSDate dateWithTimeIntervalSince1970:timeInterval - 3600 * 24 * i]);
        if (![self hasLocalDataWithDateStr:dateStr]) {
            if (endDateStr == nil) {
                endDateStr = dateStr;
            }
            startDateStr = dateStr;
        }
    }
    
    if (endDateStr == nil) {
        return NO;
    }
    
    return YES;
}

- (BOOL)hasLocalDataWithDateStr:(NSString *)dateStr {
    __block int totalCount = 0;
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        
        NSString *queryStr = [NSString stringWithFormat:@"SELECT COUNT(*) FROM ProvinceData where date = '%@'", dateStr];
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

#pragma overload

- (NSDictionary *)configParams {
    NSDictionary *ret = nil;
    if (self.updateDataType == UpdateDataType_Day) {
        ret = @{@"dataType":[NSNumber numberWithInt:1],
                @"startDate":stringWithDate(self.needUpdateDate),
                @"endDate":stringWithDate(self.needUpdateDate)};
    }
    
    else {
       ret = @{@"dataType":[NSNumber numberWithInt:1],
          @"startDate":startDateStr,
          @"endDate":endDateStr};
    }
    return ret;
}

+ (NSString *)path {
    return  @"/app";
}

+ (CFStringEncodings)encodingType {
    return 0;
    //return kCFStringEncodingGB_18030_2000;
}

- (void)successWithResponse:(id)responseObject {
    NSDictionary *res = [responseObject objectAtIndex:0];
    if ([res allKeys] == 0) {
        _resultInfo = @"该天无网络数据";
        self.refreshAction = nil;
        return;
    }
    _resultInfo = @"成功获取网络数据";
    run_async_and_complete(^{
        //showStatusView(YES);
        [self saveData:res];
    }, ^{
        _currentDateStr = stringWithDate(self.needUpdateDate);
        [self reloadProvinceData];
        refreshAction();
        self.refreshAction = nil;
    });
}

@end
