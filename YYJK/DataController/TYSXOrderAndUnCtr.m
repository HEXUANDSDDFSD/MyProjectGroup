//
//  TYSXOrderAndUnCtr.m
//  tysx
//
//  Created by zwc on 14/12/31.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXOrderAndUnCtr.h"

#define kMainTableName @"tysx_order_unsubscribe_main"
#define kProvinceTableName @"tysx_order_unsubscribe_province"
#define kAppendTableName @"tysx_order_unsubscribe_append"

#define kOrderKey @"ord"
#define kUnsubscribeKey @"unsubscribe"
#define kConversionRateKey @"conversion"
#define kCRMOrderKey @"crm_or"
#define kCRMUnKey @"crm_un"
#define kCRMConversionRateKey @"crm_conversion"
#define kTimesKey @"times"
#define kTingjiKey @"tingji"
#define kFujiKey @"fuji"
#define kBaoyueKey @"baoyue"
#define kAnciKey @"anci"

#define kProvinceNameKey @"province_name"
#define kProvinceValueKey @"province_value"

#define kAppendKey @"append"
#define kYunyingKey @"运营部"
#define kYingxiaoKey @"新产品事业部"
#define kChanpinKey @"产品部"
#define kOtherKey @"其它"

#define kTypeKey @"type"
#define kValueKey @"value"


@implementation TYSXOrderAndUnCtr {
    NSMutableArray *orderArray;
    NSMutableArray *unsubscribeArray;
    NSMutableArray *conversionRateArray;
    NSMutableArray *timesArray;
    NSMutableDictionary *provinceDic;
    NSMutableArray *yunyingArray;
    NSMutableArray *yingxiaoArray;
    NSMutableArray *chanpinArray;
    NSMutableArray *otherArray;
    NSMutableArray *tingjiArray;
    NSMutableArray *fujiArray;
    NSMutableArray *baoyueArray;
    NSMutableArray *anciArray;
    
    NSInteger _selectedProvinceDateIndex;
    NSInteger _selectedProvinceType;
    NSInteger _selectedMainType;
}

+ (NSString *)path {
    return @"/chartsAction!getData.ds";
}

- (id)initWithCacheType:(CacheType)cacheType {
    if (self = [super initWithCacheType:cacheType]) {
        _selectedProvinceDateIndex = 13;
    }
    return self;
}

- (NSString *)databaseTableName {
    return kMainTableName;
}

- (void)setSelectedProvinceDateIndex:(NSInteger)selectedProvinceDateIndex {
    if (_selectedProvinceDateIndex != selectedProvinceDateIndex) {
        _selectedProvinceDateIndex = selectedProvinceDateIndex;
        [self reloadProvinceData];
    }
}

- (void)setSelectedProvinceType:(NSInteger)selectedProvinceType {
    if (_selectedProvinceType != selectedProvinceType) {
        _selectedProvinceType = selectedProvinceType;
        [self reloadProvinceData];
    }
}

- (void)setSelectedMainType:(NSInteger)selectedMainType {
    if (_selectedMainType != selectedMainType) {
        _selectedMainType = selectedMainType;
        [self reloadMainData];
    }
}

- (void)allocDataContainer {
    orderArray = [NSMutableArray array];
    unsubscribeArray = [NSMutableArray array];
    conversionRateArray = [NSMutableArray array];
    timesArray = [NSMutableArray array];
    provinceDic = [NSMutableDictionary dictionary];
    yunyingArray = [NSMutableArray array];
    yingxiaoArray = [NSMutableArray array];
    chanpinArray = [NSMutableArray array];
    otherArray = [NSMutableArray array];
    tingjiArray = [NSMutableArray array];
    fujiArray = [NSMutableArray array];
    baoyueArray = [NSMutableArray array];
    anciArray = [NSMutableArray array];
}

- (void)createDatabase {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                               %@ varchar(20),\
                               %@ double,\
                               %@ double,\
                               %@ double,\
                               %@ double,\
                               %@ double,\
                               %@ double,\
                               %@ int,\
                               %@ int,\
                               %@ double,\
                               %@ double,\
                               PRIMARY KEY (%@)\
                               )", kMainTableName, kDateKey, kConversionRateKey, kOrderKey,kUnsubscribeKey,kCRMOrderKey,kCRMUnKey, kTimesKey, kTingjiKey,kFujiKey,kBaoyueKey,kAnciKey, kDateKey];
        [database executeUpdate:createSql];
        createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                     %@ varchar(20),\
                     %@ varchar(20),\
                     %@ int,\
                     %@ int,\
                     PRIMARY KEY (%@, %@, %@)\
                     )", kProvinceTableName, kDateKey, kProvinceNameKey,kProvinceValueKey, kTypeKey, kDateKey, kProvinceNameKey, kTypeKey];
        [database executeUpdate:createSql];
        createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                     %@ varchar(20),\
                     %@ varchar(20),\
                     %@ int,\
                     PRIMARY KEY (%@, %@)\
                     )", kAppendTableName, kDateKey, kAppendKey, kValueKey, kDateKey, kAppendKey];
        [database executeUpdate:createSql];
    }];
}

- (NSArray *)orderData {
    if (kNeedVirtualData) {
        switch (_selectedMainType) {
            case 0:
                return @[@2.3, @3.3, @5.2, @1.3, @5.2, @10.3, @1.1, @1.4, @9.3, @5.3, @7.3, @4.3, @8.3, @6.2];
                break;
            case 1:
                return @[@8.3, @9.5, @1.3, @7.3, @1.3, @5.3, @2.3, @9.3, @6.3, @5.3, @5.3, @8.3, @1.3, @1.3];
                break;
                
            default:
                break;
        }
    }
    return orderArray;
}

- (NSArray *)unsubscribeData {
    if (kNeedVirtualData) {
        switch (_selectedMainType) {
            case 0:
                return @[@8.3, @9.5, @1.3, @7.3, @1.3, @5.3, @2.3, @9.3, @6.3, @5.3, @5.3, @8.3, @1.3, @1.3];
                break;
            case 1:
                return @[@2.3, @3.3, @5.2, @1.3, @5.2, @10.3, @1.1, @1.4, @9.3, @5.3, @7.3, @4.3, @8.3, @6.2];
                break;
                
            default:
                break;
        }
    }
    return unsubscribeArray;
}

- (NSArray *)conversionRateData {
    if (kNeedVirtualData) {
        return @[@0.3, @0.9, @5.2, @1.3, @5.2, @0.3, @1.1, @1.4, @2.3, @5.3, @7.3, @0.7, @0.9, @0.3];
    }
    return conversionRateArray;
}

- (NSArray *)timesData {
    if (kNeedVirtualData) {
        return @[@0.3, @0.9, @5.2, @1.3, @5.2, @0.3, @1.1, @1.4, @2.3, @5.3, @7.3, @0.7, @0.9, @0.3];
    }
    return timesArray;
}

- (NSDictionary *)provinceData {
    return provinceDic;
}

- (NSArray *)yunyingData {
    if (kNeedVirtualData) {
        return @[@65, @208, @245, @20, @126, @67, @144, @65, @208, @245, @20, @126, @67, @144];
    }
    return yunyingArray;
}

- (NSArray *)yingxiaoData {
    if (kNeedVirtualData) {
       return @[@103, @253, @59, @126, @220, @33, @41,@103, @253, @59, @126, @220, @33, @41];
    }
    return yingxiaoArray;
}

- (NSArray *)chanpinData {
    if (kNeedVirtualData) {
        return @[@99, @160, @270, @75, @169, @61, @268, @99, @160, @270, @75, @169, @61, @268];
    }
    return chanpinArray;
}

- (NSArray *)otherData {
    if (kNeedVirtualData) {
        return @[@287, @133, @91, @62, @231, @77, @103, @287, @133, @91, @62, @231, @77, @103];
    }
    return otherArray;
}

- (NSArray *)tingjiData {
    if (kNeedVirtualData) {
        return @[@38, @97, @264, @66, @143, @139, @61,@38, @97, @264, @66, @143, @139, @61];
    }
    return tingjiArray;
}

- (NSArray *)fujiData {
    if (kNeedVirtualData) {
        return @[@281, @25, @48, @44, @232, @104, @65, @281, @25, @48, @44, @232, @104, @65];
    }
    return fujiArray;
}

- (NSArray *)baoyueData {
    if (kNeedVirtualData) {
        return @[@9.200000, @29.200000, @28.300000, @26.400000, @26.000000, @7.500000, @29.900000, @9.200000, @29.200000, @28.300000, @26.400000, @26.000000, @7.500000, @29.900000];
    }
    return baoyueArray;
}

- (NSArray *)anciData {
    if (kNeedVirtualData) {
        return @[@10.500000, @27.400000, @15.100000, @21.400000, @17.600000, @22.100000, @10.600000, @10.500000, @27.400000, @15.100000, @21.400000, @17.600000, @22.100000, @10.600000];
    }
    return anciArray;
}

- (void)reloadData {
    [self reloadMainData];
    [self reloadProvinceData];
    [self reloadAppendData];
}

- (void)reloadMainData {
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        [database beginTransaction];
        switch (_selectedMainType) {
            case 0:
                [orderArray removeAllObjects];
                [unsubscribeArray removeAllObjects];
                [conversionRateArray removeAllObjects];
                for (int i = 0; i < 14; i++) {
                    NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@,%@ FROM %@ WHERE %@ = '%@'", kOrderKey, kUnsubscribeKey, kConversionRateKey,kMainTableName, kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - ([self dateSpan] - i - 1) * 3600 * 24])];
                    FMResultSet *result = [database executeQuery:selectSql];
                    CGFloat orderValue = 0.0;
                    CGFloat unValue = 0.0;
                    CGFloat conversionRateValue = 0.0;
                    if ([result next]) {
                        orderValue = [result doubleForColumn:kOrderKey];
                        unValue = [result doubleForColumn:kUnsubscribeKey];
                        conversionRateValue = [result doubleForColumn:kConversionRateKey];
                    }
                    [orderArray addObject:[NSNumber numberWithFloat:orderValue]];
                    [unsubscribeArray addObject:[NSNumber numberWithFloat:unValue]];
                    [conversionRateArray addObject:[NSNumber numberWithFloat:conversionRateValue]];
                }
                
                break;
            case 1:
                [orderArray removeAllObjects];
                [unsubscribeArray removeAllObjects];
                [conversionRateArray removeAllObjects];
                for (int i = 0; i < 14; i++) {
                    NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@ FROM %@ WHERE %@ = '%@'", kCRMOrderKey, kCRMUnKey,kMainTableName, kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - ([self dateSpan] - i - 1) * 3600 * 24])];
                    FMResultSet *result = [database executeQuery:selectSql];
                    CGFloat orderValue = 0.0;
                    CGFloat unValue = 0.0;
                    CGFloat conversionRateValue = 0.0;
                    if ([result next]) {
                        orderValue = [result doubleForColumn:kCRMOrderKey];
                        unValue = [result doubleForColumn:kCRMUnKey];
//                        conversionRateValue = [result doubleForColumn:kCRMConversionRateKey];
                    }
                    [orderArray addObject:[NSNumber numberWithFloat:orderValue]];
                    [unsubscribeArray addObject:[NSNumber numberWithFloat:unValue]];
                    [conversionRateArray addObject:[NSNumber numberWithFloat:conversionRateValue]];
                }
                break;
            case 2:
                [timesArray removeAllObjects];
                for (int i = 0; i < 14; i++) {
                    NSString *selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", kTimesKey,kMainTableName, kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - ([self dateSpan] - i - 1) * 3600 * 24])];
                    FMResultSet *result = [database executeQuery:selectSql];
                    CGFloat timeValue = 0.0;
                    if ([result next]) {
                        timeValue = [result doubleForColumn:kTimesKey];
                    }
                    [timesArray addObject:[NSNumber numberWithFloat:timeValue]];
                }
                
                break;
                
            default:
                break;
        }
        [database commit];
    }];
}

- (void)reloadProvinceData {
    [provinceDic removeAllObjects];
    if (kNeedVirtualData) {
        NSDictionary *provinceInfoDic = [NSMutableDictionary dictionary];
        [provinceInfoDic setValue:@"云南" forKey:@"1001"];
        [provinceInfoDic setValue:@"内蒙古" forKey:@"1002"];
        [provinceInfoDic setValue:@"山西" forKey:@"1003"];
        [provinceInfoDic setValue:@"陕西" forKey:@"1004"];
        [provinceInfoDic setValue:@"上海" forKey:@"1005"];
        [provinceInfoDic setValue:@"北京" forKey:@"1006"];
        [provinceInfoDic setValue:@"吉林" forKey:@"1007"];
        [provinceInfoDic setValue:@"四川" forKey:@"1008"];
        [provinceInfoDic setValue:@"天津" forKey:@"1009"];
        [provinceInfoDic setValue:@"宁夏" forKey:@"1010"];
        [provinceInfoDic setValue:@"安徽" forKey:@"1011"];
        [provinceInfoDic setValue:@"山东" forKey:@"1012"];
        [provinceInfoDic setValue:@"广东" forKey:@"1013"];
        [provinceInfoDic setValue:@"广西" forKey:@"1014"];
        [provinceInfoDic setValue:@"新疆" forKey:@"1015"];
        [provinceInfoDic setValue:@"江苏" forKey:@"1016"];
        [provinceInfoDic setValue:@"江西" forKey:@"1017"];
        [provinceInfoDic setValue:@"河北" forKey:@"1018"];
        [provinceInfoDic setValue:@"河南" forKey:@"1019"];
        [provinceInfoDic setValue:@"浙江" forKey:@"1020"];
        [provinceInfoDic setValue:@"海南" forKey:@"1021"];
        [provinceInfoDic setValue:@"湖北" forKey:@"1022"];
        [provinceInfoDic setValue:@"湖南" forKey:@"1023"];
        [provinceInfoDic setValue:@"甘肃" forKey:@"1024"];
        [provinceInfoDic setValue:@"福建" forKey:@"1025"];
        [provinceInfoDic setValue:@"西藏" forKey:@"1026"];
        [provinceInfoDic setValue:@"贵州" forKey:@"1027"];
        [provinceInfoDic setValue:@"辽宁" forKey:@"1028"];
        [provinceInfoDic setValue:@"重庆" forKey:@"1029"];
        [provinceInfoDic setValue:@"青海" forKey:@"1030"];
        [provinceInfoDic setValue:@"黑龙江" forKey:@"1031"];
        for (NSString *key in [provinceInfoDic allValues]) {
            [provinceDic setValue:[NSNumber numberWithInt:arc4random() % 500] forKey:key];
        }
        return;
    }
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@ FROM %@ WHERE %@ = '%@' AND %@=%ld", kProvinceNameKey, kProvinceValueKey, kProvinceTableName , kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (14 - _selectedProvinceDateIndex - 1) * 3600 * 24]), kTypeKey, (long)_selectedProvinceType];
        FMResultSet *result = [database executeQuery:selectSql];
        while ([result next]) {
            [provinceDic setValue:[NSNumber numberWithInt:[result intForColumn:kProvinceValueKey]] forKey:[result stringForColumn:kProvinceNameKey]];
        }
        [database commit];
    }];
}

- (void)reloadAppendData {
    [yunyingArray removeAllObjects];
    [chanpinArray removeAllObjects];
    [yingxiaoArray removeAllObjects];
    [otherArray removeAllObjects];
    [tingjiArray removeAllObjects];
    [fujiArray removeAllObjects];
    [baoyueArray removeAllObjects];
    [anciArray removeAllObjects];
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        for (int i = 0; i < 14; i++) {
            NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@ FROM %@ WHERE %@ = '%@'", kTingjiKey, kFujiKey, kBaoyueKey, kAnciKey,kMainTableName, kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (14 - i - 1) * 3600 * 24])];
            FMResultSet *result = [database executeQuery:selectSql];
            int tingjiValue = 0;
            int fujiValue = 0;
            CGFloat baoyueValue = 0.0;
            CGFloat anciValue = 0.0;
            if ([result next]) {
                tingjiValue = [result intForColumn:kTingjiKey];
                fujiValue = [result intForColumn:kFujiKey];
                baoyueValue = [result longLongIntForColumn:kBaoyueKey];
                anciValue = [result longLongIntForColumn:kAnciKey];
            }
            [tingjiArray addObject:[NSNumber numberWithInt:tingjiValue]];
            [fujiArray addObject:[NSNumber numberWithInt:fujiValue]];
            [baoyueArray addObject:[NSNumber numberWithFloat:baoyueValue]];
            [anciArray addObject:[NSNumber numberWithFloat:anciValue]];
            
            
            selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@' AND %@='%@'", kValueKey, kAppendTableName, kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (14 - i - 1) * 3600 * 24]), kAppendKey, kYunyingKey];
            result = [database executeQuery:selectSql];
            int yunyingValue = 0;
            if ([result next]) {
                yunyingValue = [result intForColumn:kValueKey];
            }
            [yunyingArray addObject:[NSNumber numberWithInt:yunyingValue]];
            
            selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@' AND %@='%@'", kValueKey, kAppendTableName, kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (14 - i - 1) * 3600 * 24]), kAppendKey,  kYingxiaoKey];
            result = [database executeQuery:selectSql];
            int yingxiaoValue = 0;
            if ([result next]) {
                yingxiaoValue = [result intForColumn:kValueKey];
            }
            [yingxiaoArray addObject:[NSNumber numberWithInt:yingxiaoValue]];
            
            selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@' AND %@='%@'", kValueKey, kAppendTableName, kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (14 - i - 1) * 3600 * 24]), kAppendKey, kChanpinKey];
            result = [database executeQuery:selectSql];
            int chanpinValue = 0;
            if ([result next]) {
                chanpinValue = [result intForColumn:kValueKey];
            }
            [chanpinArray addObject:[NSNumber numberWithInt:chanpinValue]];
            
            selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@' AND %@='%@'", kValueKey, kAppendTableName, kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (14 - i - 1) * 3600 * 24]), kAppendKey, kOtherKey];
            result = [database executeQuery:selectSql];
            int otherValue = 0;
            if ([result next]) {
                yunyingValue = [result intForColumn:kValueKey];
            }
            [otherArray addObject:[NSNumber numberWithInt:otherValue]];
        }
        [database commit];
    }];
}

- (void)saveNetworkData {
    NSDictionary *data = (NSDictionary *)responeData;
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        
        NSArray *topData = [data objectForKey:@"top"];
        
        NSString *insertSql = nil;
        for (int i = 0; i < [topData count]; i++) {
            NSArray *topCellData = topData[i];
            insertSql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@',%f,%f,%f,%f,%f,%f,%d,%d,%f,%f)", kMainTableName,topCellData[0], [topCellData[1] doubleValue],[topCellData[2] doubleValue],[topCellData[3] doubleValue],[topCellData[4] doubleValue],[topCellData[5] doubleValue],[topCellData[6] doubleValue],[topCellData[7] intValue],[topCellData[8] intValue],[topCellData[9] doubleValue],[topCellData[10] doubleValue]];
            [database executeUpdate:insertSql];
        }
        
        NSArray *provinceData = [data objectForKey:@"left"];
        for (int i = 0; i < [provinceData count]; i++) {
            NSArray *provinceCellData = provinceData[i];
            for (int j = 0; j < 5; j++) {
                insertSql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@','%@',%d,%d)", kProvinceTableName,provinceCellData[0], provinceCellData[1], [provinceCellData[2 + j] intValue], j];
                [database executeUpdate:insertSql];
            }
        }
        
        NSArray *appendData = [data objectForKey:@"right"];
        for (int i = 0; i < [appendData count]; i++) {
            NSArray *appendCellData = appendData[i];
                insertSql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@','%@',%d)", kAppendTableName,appendCellData[0], appendCellData[1], [appendCellData[2] intValue]];
                [database executeUpdate:insertSql];
        }
        [database commit];
    }];
}

- (void)successWithResponse:(id)responseObject {
    _resultInfo = @"该天无网络数据";
    NSDictionary *responseDic = (NSDictionary *)responseObject;
   // if ([responseArr count] != 0) {
        lastDate = willShowDate;
        _result = NetworkBaseResult_Success;
        _resultInfo = @"成功获取网络数据";
        responeData = responseDic;
    //}
}

- (NSInteger)dateSpan {
    return 14;
}

- (NSDictionary *)configParams {
    return @{@"dtype":@1,
             @"sdate":startDateStr,
             @"edate":endDateStr};
}


@end
