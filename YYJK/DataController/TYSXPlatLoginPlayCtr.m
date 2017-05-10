//
//  TYSXPlatLoginPlayCtr.m
//  tysx
//
//  Created by zwc on 14/12/30.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXPlatLoginPlayCtr.h"

#define kMainTableName @"tysx_plat_login_play_main"
#define kProvinceTableName @"tysx_plat_login_play_province"
#define kAppendTableName @"tysx_plat_login_play_append"

#define kTypeKey @"type"
#define kLoginKey @"l"
#define kPlayKey @"p"
#define kConversionRateKey @"ddd"
#define kProvinceNameKey @"provin"
#define kProvinceValueKey @"dddd"
#define kZhiboKey @"dd"
#define kDianboKey @"dianbo"
#define kHuikanKey @"huidian"
#define kXiazaiKey @"xiazai"
#define kFujiaKey @"fujia"
#define kAverageKey @"averageKey"

@implementation TYSXPlatLoginPlayCtr {
    NSMutableArray *loginArray;
    NSMutableArray *playArray;
    NSMutableArray *conversionRateArray;
    NSMutableDictionary *provinceDic;
    NSMutableArray *zhiboArray;
    NSMutableArray *dianboArray;
    NSMutableArray *huikanArray;
    NSMutableArray *xiazaiArray;
    NSMutableArray *fujiaArray;
    NSMutableArray *averageArray;
    NSInteger _selectedProvinceType;
    NSInteger _selectedAppendType;
    NSInteger _selectedProvinceDateIndex;
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

- (void)setSelectedAppendType:(NSInteger)selectedAppendType {
    if (_selectedAppendType != selectedAppendType) {
        _selectedAppendType = selectedAppendType;
        [self reloadAppendData];
    }
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

- (void)reloadData {
    [self reloadMainData];
    [self reloadProvinceData];
    [self reloadAppendData];
}

- (void)allocDataContainer {
    loginArray = [NSMutableArray array];
    playArray = [NSMutableArray array];
    conversionRateArray = [NSMutableArray array];
    provinceDic = [NSMutableDictionary dictionary];
    zhiboArray = [NSMutableArray array];
    dianboArray = [NSMutableArray array];
    huikanArray = [NSMutableArray array];
    xiazaiArray = [NSMutableArray array];
    fujiaArray = [NSMutableArray array];
    averageArray = [NSMutableArray array];
}

- (void)createDatabase {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                               %@ varchar(20),\
                               %@ double,\
                               %@ double,\
                               %@ double,\
                               PRIMARY KEY (%@)\
                               )", kMainTableName, kDateKey,kConversionRateKey, kLoginKey, kPlayKey, kDateKey];
        [database executeUpdate:createSql];
        createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                     %@ varchar(20),\
                     %@ varchar(20),\
                     %@ double,\
                     %@ int,\
                     PRIMARY KEY (%@, %@, %@)\
                     )", kProvinceTableName, kDateKey, kProvinceNameKey,kProvinceValueKey, kTypeKey, kDateKey, kProvinceNameKey, kTypeKey];
        [database executeUpdate:createSql];
        createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                     %@ varchar(20),\
                     %@ double,\
                     %@ double,\
                     %@ double,\
                     %@ double,\
                     %@ double,\
                     %@ double,\
                     %@ int,\
                     PRIMARY KEY (%@, %@)\
                     )", kAppendTableName, kDateKey, kAverageKey, kZhiboKey, kDianboKey, kHuikanKey, kXiazaiKey, kFujiaKey, kTypeKey, kDateKey, kTypeKey];
        [database executeUpdate:createSql];
    }];
}

- (NSDictionary *)provinceData {
    return provinceDic;
}

- (NSArray *)playData {
    if (kNeedVirtualData) {
        return @[@8.3, @9.5, @1.3, @7.3, @1.3, @5.3, @2.3, @9.3, @6.3, @5.3, @5.3, @8.3, @1.3, @1.3];
    }
    return playArray;
}

- (NSArray *)loginData {
    if (kNeedVirtualData) {
        return @[@2.3, @3.3, @5.2, @1.3, @5.2, @10.3, @1.1, @1.4, @9.3, @5.3, @7.3, @4.3, @8.3, @6.2];
    }
    return playArray;
}

- (NSArray *)conversionRateData {
    if (kNeedVirtualData) {
        return @[@0.3, @1.2, @1.4, @1.3, @5.2, @1.3, @1.1, @1.4, @5.3, @3.3, @2.2, @4.3, @4.1, @4.2];
    }
    return conversionRateArray;
}

- (NSArray *)zhiboData {
    if (kNeedVirtualData) {
        switch (_selectedAppendType) {
            case 0:
                return  @[@1.970000, @1.330000, @2.150000, @2.550000, @0.740000, @2.800000, @2.020000, @1.970000, @1.330000, @2.150000, @2.550000, @0.740000, @2.800000, @2.020000];
                break;
            case 1:
                return   @[@1.010000, @0.600000, @2.990000, @0.010000, @2.380000, @2.910000, @2.310000, @1.010000, @0.600000, @2.990000, @0.010000, @2.380000, @2.910000, @2.310000];
                break;
            case 2:
                return  @[@0.190000, @1.950000, @2.440000, @0.040000, @2.230000, @2.180000, @0.540000, @0.190000, @1.950000, @2.440000, @0.040000, @2.230000, @2.180000, @0.540000];
                break;
                
            default:
                break;
        }
    }
    return zhiboArray;
}

- (NSArray *)dianboData {
    if (kNeedVirtualData) {
        switch (_selectedAppendType) {
            case 0:
                return   @[@1.250000, @2.640000, @1.910000, @1.720000, @0.360000, @0.660000, @0.360000, @1.250000, @2.640000, @1.910000, @1.720000, @0.360000, @0.660000, @0.360000];
                break;
            case 1:
                return  @[@2.820000, @0.500000, @2.200000, @1.440000, @1.950000, @0.450000, @2.810000, @2.820000, @0.500000, @2.200000, @1.440000, @1.950000, @0.450000, @2.810000];
                break;
            case 2:
                return  @[@2.460000, @2.090000, @0.230000, @2.380000, @2.600000, @2.710000, @0.700000, @2.460000, @2.090000, @0.230000, @2.380000, @2.600000, @2.710000, @0.700000];
                break;
                
            default:
                break;
        }
    }
    return dianboArray;
}

- (NSArray *)huikanData {
    if (kNeedVirtualData) {
        switch (_selectedAppendType) {
            case 0:
                return  @[@0.590000, @0.780000, @1.890000, @2.560000, @1.420000, @1.820000, @1.230000, @0.590000, @0.780000, @1.890000, @2.560000, @1.420000, @1.820000, @1.230000];
                break;
            case 1:
                return @[@0.420000, @2.640000, @0.300000, @2.740000, @1.400000, @0.280000, @0.350000, @0.420000, @2.640000, @0.300000, @2.740000, @1.400000, @0.280000, @0.350000];
                break;
            case 2:
                return @[@1.510000, @1.330000, @0.340000, @0.630000, @1.000000, @2.100000, @0.040000, @1.510000, @1.330000, @0.340000, @0.630000, @1.000000, @2.100000, @0.040000];
                break;
                
            default:
                break;
        }
    }
    return huikanArray;
}

- (NSArray *)xiazaiData {
    if (kNeedVirtualData) {
        switch (_selectedAppendType) {
            case 0:
                return  @[@2.350000, @2.620000, @2.270000, @2.610000, @1.540000, @2.840000, @0.420000, @2.350000, @2.620000, @2.270000, @2.610000, @1.540000, @2.840000, @0.420000];
                break;
            case 1:
                return  @[@0.950000, @0.580000, @2.400000, @2.300000, @1.630000, @2.340000, @0.160000, @0.950000, @0.580000, @2.400000, @2.300000, @1.630000, @2.340000, @0.160000];
                break;
            case 2:
                return  @[@1.180000, @0.970000, @2.740000, @0.590000, @1.090000, @1.850000, @2.180000, @1.180000, @0.970000, @2.740000, @0.590000, @1.090000, @1.850000, @2.180000];
                break;
                
            default:
                break;
        }
    }
    return xiazaiArray;
}

- (NSArray *)fujiaData {
    if (kNeedVirtualData) {
        switch (_selectedAppendType) {
            case 0:
                return  @[@1.470000, @1.970000, @0.750000, @2.200000, @1.730000, @2.920000, @2.280000, @1.470000, @1.970000, @0.750000, @2.200000, @1.730000, @2.920000, @2.280000];
                break;
            case 1:
               return @[@1.350000, @2.830000, @0.650000, @1.370000, @0.580000, @2.400000, @1.570000, @1.350000, @2.830000, @0.650000, @1.370000, @0.580000, @2.400000, @1.570000];
                break;
            case 2:
                return  @[@2.860000, @0.210000, @2.260000, @0.920000, @1.580000, @0.020000, @1.380000, @2.860000, @0.210000, @2.260000, @0.920000, @1.580000, @0.020000, @1.380000];
                break;
                
            default:
                break;
        }
    }
    return fujiaArray;
}

- (NSArray *)averageData {
    if (kNeedVirtualData) {
        switch (_selectedAppendType) {
            case 0:
                return @[@9.166667, @7.333333, @3.766667, @3.766667, @6.100000, @4.866667, @3.033333, @9.166667, @7.333333, @3.766667, @3.766667, @6.100000, @4.866667, @3.033333];
                break;
            case 1:
                return @[@7.533333, @7.366667, @5.500000, @3.066667, @5.600000, @7.966667, @2.466667, @7.533333, @7.366667, @5.500000, @3.066667, @5.600000, @7.966667, @2.466667];
                break;
            case 2:
                return @[@7.400000, @8.933333, @8.366667, @2.100000, @3.466667, @7.866667, @0.066667, @7.400000, @8.933333, @8.366667, @2.100000, @3.466667, @7.866667, @0.066667];
                break;
                
            default:
                break;
        }
    }
    return averageArray;
}

- (void)reloadMainData {
    [playArray removeAllObjects];
    [loginArray removeAllObjects];
    [conversionRateArray removeAllObjects];
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        for (int i = 0; i < 14; i++) {
            NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@,%@ FROM %@ WHERE %@ = '%@'", kLoginKey, kPlayKey, kConversionRateKey,kMainTableName, kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - ([self dateSpan] - i - 1) * 3600 * 24])];
            FMResultSet *result = [database executeQuery:selectSql];
            CGFloat loginValue = 0.0;
            CGFloat playValue = 0.0;
            CGFloat conversionRateValue = 0.0;
            if ([result next]) {
                loginValue = [result doubleForColumn:kLoginKey];
                playValue = [result doubleForColumn:kPlayKey];
                conversionRateValue = [result doubleForColumn:kConversionRateKey];
            }
            [loginArray addObject:[NSNumber numberWithFloat:loginValue]];
            [playArray addObject:[NSNumber numberWithFloat:playValue]];
            [conversionRateArray addObject:[NSNumber numberWithFloat:conversionRateValue]];
        }
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
            [provinceDic setValue:[NSNumber numberWithFloat:arc4random() % 100 / 60.0] forKey:key];
        }
        return;
    }
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
            NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@ FROM %@ WHERE %@ = '%@' AND %@=%ld", kProvinceNameKey, kProvinceValueKey, kProvinceTableName , kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (14 - _selectedProvinceDateIndex - 1) * 3600 * 24]), kTypeKey, (long)_selectedProvinceType];
            FMResultSet *result = [database executeQuery:selectSql];
        while ([result next]) {
            [provinceDic setValue:[NSNumber numberWithDouble:[result doubleForColumn:kProvinceValueKey]] forKey:[result stringForColumn:kProvinceNameKey]];
        }
    }];
}

- (void)reloadAppendData {
    [zhiboArray removeAllObjects];
    [dianboArray removeAllObjects];
    [huikanArray removeAllObjects];
    [xiazaiArray removeAllObjects];
    [fujiaArray removeAllObjects];
    [averageArray removeAllObjects];
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        for (int i = 0; i < 14; i++) {
            NSString *selectSql = [NSString stringWithFormat:@"SELECT %@,%@,%@,%@,%@,%@ FROM %@ WHERE %@ = '%@' AND %@=%ld", kAverageKey,kZhiboKey, kDianboKey, kHuikanKey, kXiazaiKey, kFujiaKey,kAppendTableName, kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (14 - i - 1) * 3600 * 24]), kTypeKey, (long)_selectedAppendType];
            FMResultSet *result = [database executeQuery:selectSql];
            CGFloat dianboValue = 0.0;
            CGFloat zhiboValue = 0.0;
            CGFloat huikanValue = 0.0;
            CGFloat xiazaiValue = 0.0;
            CGFloat fujiaValue = 0.0;
            CGFloat averageValue = 0.0;
            if ([result next]) {
                dianboValue = [result doubleForColumn:kDianboKey];
                zhiboValue = [result doubleForColumn:kZhiboKey];
                huikanValue = [result doubleForColumn:kHuikanKey];
                xiazaiValue = [result doubleForColumn:kXiazaiKey];
                fujiaValue = [result doubleForColumn:kFujiaKey];
                averageValue = [result doubleForColumn:kAverageKey];
            }
            [zhiboArray addObject:[NSNumber numberWithFloat:zhiboValue]];
            [dianboArray addObject:[NSNumber numberWithFloat:dianboValue]];
            [huikanArray addObject:[NSNumber numberWithFloat:huikanValue]];
            [xiazaiArray addObject:[NSNumber numberWithFloat:xiazaiValue]];
            [fujiaArray addObject:[NSNumber numberWithFloat:fujiaValue]];
            [averageArray addObject:[NSNumber numberWithFloat:averageValue]];
        }
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
            insertSql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@',%f,%f,%f)", kMainTableName,topCellData[0], [topCellData[1] doubleValue],[topCellData[2] doubleValue],[topCellData[3] doubleValue]];
            [database executeUpdate:insertSql];
        }
        
        NSArray *provinceData = [data objectForKey:@"left"];
        for (int i = 0; i < [provinceData count]; i++) {
            NSArray *provinceCellData = provinceData[i];
            for (int j = 0; j < 2; j++) {
                insertSql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@','%@',%f,%d)", kProvinceTableName,provinceCellData[0], provinceCellData[1], [provinceCellData[2 + j] doubleValue], j];
                [database executeUpdate:insertSql];
            }
        }
        
        NSArray *appendData = [data objectForKey:@"right"];
        for (int i = 0; i < [appendData count]; i++) {
            NSArray *appendCellData = appendData[i];
            insertSql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@',%f,%f,%f,%f,%f,%f, 0)", kAppendTableName,appendCellData[0], [appendCellData[2] doubleValue], [appendCellData[3] doubleValue],[appendCellData[4] doubleValue],[appendCellData[5] doubleValue],[appendCellData[6] doubleValue],[appendCellData[7] doubleValue]];
            [database executeUpdate:insertSql];
            
            insertSql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@',%f,%f,%f,%f,%f, 0, 1)", kAppendTableName,appendCellData[0], [appendCellData[9] doubleValue], [appendCellData[10] doubleValue],[appendCellData[11] doubleValue],[appendCellData[12] doubleValue],[appendCellData[13] doubleValue]];
            [database executeUpdate:insertSql];
            
            insertSql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@',%f,%f,%f,%f,%f, 0, 2)", kAppendTableName,appendCellData[0], [appendCellData[15] doubleValue], [appendCellData[16] doubleValue],[appendCellData[17] doubleValue],[appendCellData[18] doubleValue],[appendCellData[19] doubleValue]];
            [database executeUpdate:insertSql];
        }
        [database commit];
    }];
}

- (NSInteger)dateSpan {
    return 14;
}

- (NSDictionary *)configParams {
        return @{@"dtype":@2,
                 @"sdate":startDateStr,
                 @"edate":endDateStr};
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

@end
