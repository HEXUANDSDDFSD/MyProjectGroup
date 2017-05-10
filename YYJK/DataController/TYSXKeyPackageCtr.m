//
//  TYSXKeyPackageCtr.m
//  tysx
//
//  Created by zwc on 15/1/4.
//  Copyright (c) 2015年 huangjia. All rights reserved.
//

#import "TYSXKeyPackageCtr.h"
#import "NSDate+Normal.h"

#define kValueKey @"value"
#define kProductNameKey @"product_name"
#define kChannelNameKey @"channel_name"
#define kTypeKey @"type"

#define kSumNameKey @"总量"
#define kNaturalNameKey @"门户自然"
#define kExtendNameKey @"合作推广"

@implementation TYSXKeyPackageCtr {
    NSInteger _selectedType;
    NSMutableArray *sumOrderArray;
    NSMutableArray *naturalOrderArray;
    NSMutableArray *extendOrderArray;
    NSMutableArray *sumUnArray;
    NSMutableArray *naturalUnArray;
    NSMutableArray *extendUnArray;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSArray *)productNameList {
    if (kNeedVirtualData) {
        return @[@"项目一", @"项目二", @"项目三", @"项目四"];
    }
    return @[@"VIP会员", @"随心看·天翼视讯实惠包", @"TV189院线", @"股票老左精简版"];
}

- (void)allocDataContainer {
    sumOrderArray = [NSMutableArray array];
    naturalOrderArray = [NSMutableArray array];
    extendOrderArray = [NSMutableArray array];
    sumUnArray = [NSMutableArray array];
    naturalUnArray = [NSMutableArray array];
    extendUnArray = [NSMutableArray array];
}

- (void)clearDataContainer{
    [sumUnArray removeAllObjects];
    [naturalUnArray removeAllObjects];
    [extendUnArray removeAllObjects];
    [sumOrderArray removeAllObjects];
    [naturalOrderArray removeAllObjects];
    [extendOrderArray removeAllObjects];
}

- (void)setSelectedType:(NSInteger)selectedType {
    if (_selectedType != selectedType) {
        _selectedType = selectedType;
        [self reloadData];
    }
}

- (void)reloadData {
    [super reloadData];
    
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        NSArray *containerList = @[sumOrderArray, naturalOrderArray, extendOrderArray, sumUnArray, naturalUnArray, extendUnArray];
        NSArray *channelNameList = @[kSumNameKey, kNaturalNameKey, kExtendNameKey];
        
        NSTimeInterval lastTime = [lastDate timeIntervalSince1970];
        for (int j = 0; j < 6; j++) {
            NSMutableArray *container = containerList[j];
            NSString *channelName = channelNameList[j % 3];
            for (int i = 0; i < 8; i++) {
                NSString *selectSql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@='%@' AND %@ = '%@' AND %@='%@' AND %@=%d", kValueKey, [self databaseTableName], kChannelNameKey, channelName,kProductNameKey, [self productNameList][_selectedType], kDateKey, stringWithDate([NSDate dateWithTimeIntervalSince1970:lastTime - (7 - i) * 3600 * 24]), kTypeKey, j / 3];
                FMResultSet *result = [database executeQuery:selectSql];
                CGFloat value = 0.0;
                if ([result next]) {
                    value = [result intForColumn:kValueKey];
                }
                [container addObject:[NSNumber numberWithInt:value]];
            }
        }
        [database commit];
    }];
}

- (void)saveNetworkData {
    NSDictionary *data = (NSDictionary *)responeData;
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        [database beginTransaction];
        
        NSArray *orderData = [data objectForKey:@"dgProduct"];
        
        NSString *insertSql = nil;
        for (int i = 0; i < [orderData count]; i++) {
            NSArray *orderCellData = orderData[i];
            insertSql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@','%@','%@',%d,%d)", [self databaseTableName],orderCellData[0], orderCellData[1],orderCellData[2], [orderCellData[3] intValue], 0];
            [database executeUpdate:insertSql];
        }
        
        NSArray *unData = [data objectForKey:@"tdProduct"];
        for (int i = 0; i < [unData count]; i++) {
            NSArray *unCellData = unData[i];
            insertSql = [NSString stringWithFormat:@"INSERT INTO %@ VALUES('%@','%@','%@',%d,%d)", [self databaseTableName],unCellData[0], unCellData[1],unCellData[2], [unCellData[3] intValue], 1];
            [database executeUpdate:insertSql];
        }
        [database commit];
    }];
}

- (NSString *)databaseTableName {
    return @"tysx_key_product_pacakge";
}

- (void)createDatabase {
    [[DatabaseManager shareDatabase] synchronousOperate:^(FMDatabase *database) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
                               %@ varchar(20),\
                               %@ varchar(20),\
                               %@ varchar(20),\
                               %@ int,\
                               %@ int,\
                               PRIMARY KEY (%@,%@,%@,%@)\
                               )",[self databaseTableName], kDateKey, kProductNameKey, kChannelNameKey, kValueKey, kTypeKey, kDateKey, kProductNameKey, kChannelNameKey, kTypeKey];
        [database executeUpdate:createSql];
    }];
}

+ (NSString *)path {
    return @"/chartsAction!getData.ds";
}

- (NSInteger)dateSpan {
    return 8;
}


- (NSDictionary *)configParams {
    return @{@"dtype":@6,
             @"sdate":startDateStr,
             @"edate":endDateStr};
}

- (NSArray *)sumOrderData {
    if (kNeedVirtualData) {
        switch (_selectedType) {
            case 0:
                return @[@908, @724, @526, @231, @71, @57, @611, @77];
                break;
            case 1:
                return @[@446, @915, @135, @179, @779, @182, @157, @477];
                break;
            case 2:
                return @[@747, @75, @239, @19, @322, @112, @231, @831];
                break;
            case 3:
                return @[@29, @329, @119, @5, @789, @704, @734, @720];
                break;
            default:
                break;
        }
    }
    return sumOrderArray;
}

- (NSArray *)naturalOrderData {
    if (kNeedVirtualData) {
        switch (_selectedType) {
            case 0:
                return @[@777, @463, @928, @412, @30, @591, @981, @307];
                break;
            case 1:
                return @[@528, @645, @76, @221, @57, @77, @962, @219];
                break;
            case 2:
                return @[@121, @140, @18, @338, @345, @572, @255, @731];
                break;
            case 3:
                return @[@719, @630, @948, @676, @131, @922, @512, @309];
                break;
                
            default:
                break;
        }
    }
    return naturalOrderArray;
}

- (NSArray *)extendOrderData {
    if (kNeedVirtualData) {
        switch (_selectedType) {
            case 0:
                return @[@294, @618, @959, @448, @140, @476, @593, @850];
                break;
            case 1:
                return @[@521, @822, @567, @183, @307, @403, @300, @628];
                break;
            case 2:
                return @[@29, @197, @603, @472, @754, @161, @835, @605];
                break;
            case 3:
                return @[@73, @708, @734, @846, @190, @169, @593, @314];
                break;
                
            default:
                break;
        }
    }
    return extendOrderArray;
}

- (NSArray *)sumUnData {
    if (kNeedVirtualData) {
        switch (_selectedType) {
            case 0:
                return @[@266, @436, @75, @572, @664, @91, @88, @329];
                break;
            case 1:
                return @[@158, @354, @428, @652, @262, @140, @650, @679];
                break;
            case 2:
                return @[@922, @72, @860, @713, @255, @336, @572, @42];
                break;
            case 3:
                return @[@523, @2, @46, @153, @546, @966, @981, @735];
                break;
                
            default:
                break;
        }
    }
    return sumUnArray;
}

- (NSArray *)naturalUnData {
    if (kNeedVirtualData) {
        switch (_selectedType) {
            case 0:
                return @[@548, @955, @920, @630, @811, @664, @24, @344];
                break;
            case 1:
                return @[@987, @939, @412, @215, @323, @540, @981, @976];
                break;
            case 2:
                return @[@957, @934, @783, @89, @64, @182, @325, @590];
                break;
            case 3:
                return @[@715, @770, @217, @66, @564, @382, @890, @106];
                break;
                
            default:
                break;
        }
    }
    return naturalUnArray;
}

- (NSArray *)extendUnData {
    if (kNeedVirtualData) {
        switch (_selectedType) {
            case 0:
                return @[@59, @55, @714, @969, @867, @924, @151, @844];
                break;
            case 1:
                return @[@715, @308, @729, @58, @300, @837, @653, @49];
                break;
            case 2:
                return @[@521, @289, @860, @779, @772, @256, @879, @113];
                break;
            case 3:
                return @[@562, @813, @606, @936, @708, @916, @705, @308];
                break;
                
            default:
                break;
        }
    }
    return extendUnArray;
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
