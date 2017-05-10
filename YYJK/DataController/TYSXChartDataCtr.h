//
//  TYSXChartDataCtr.h
//  tysx
//
//  Created by zwc on 13-11-20.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkBase.h"

typedef enum{
    DimensionType_None,
    DimensionType_Product,
    DimensionType_Plat,
    DimensionType_All
}DimensionType;

typedef enum{
    ShowDataType_All,
    ShowDataType_Natural,
    ShowDataType_Extend
} ShowDataType;

@interface TYSXChartDataCtr : NetworkBase

//@property (nonatomic, readonly) NSArray *productIdList;
@property (nonatomic, readonly) NSString *currentDayStr;
@property (nonatomic, readonly) BOOL isCompareWeek;
@property (nonatomic, assign) int currentTypeId;
@property (nonatomic, assign) ShowDataType showType;
@property (nonatomic, assign) DimensionType dimensionType;
@property (nonatomic, assign) NSInteger currentPlatIndex;

//new

@property (nonatomic, copy) NSString *currentProductId;
@property (nonatomic, copy) NSString *currentPlatId;

@property (nonatomic, readonly) NSString *currentTypeName;
@property (nonatomic, readonly) NSArray *productIds;
@property (nonatomic, readonly) NSArray *platIds;
@property (nonatomic, readonly) NSArray *dateStrs;

@property (nonatomic, readonly) NSString *currentDimensionName;

@property (nonatomic, readonly) NSArray *orderDatas;
@property (nonatomic, readonly) NSArray *unsubscribeDatas;
@property (nonatomic, readonly) NSArray *flowDatas;

@property (nonatomic, readonly) long long minValue;
@property (nonatomic, readonly) long long maxValue;
@property (nonatomic, readonly) NSArray *dateStr;
@property (nonatomic, readonly) NSString *unitStr;

- (long long)currentValueWith:(int)type;
- (long long)compareValueWith:(int)type;
- (long long)dayCompareValueWith:(int)type;
- (long long)weakCompareValueWith:(int)type;

- (NSString *)productNameWithId:(NSString *)productId;
- (NSString *)platNameWithId:(NSString *)platId;

- (NeedOperateType)changeLastDate:(NSDate *)date;
- (void)reloadData;
- (BOOL)hasAnyData;
- (void)saveNetworkDataWithCompleteBlock:(dispatch_block_t) complete;

@end
