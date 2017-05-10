//
//  HXProvinceDataCtr.h
//  tysx
//
//  Created by zwc on 13-11-29.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkBase.h"

typedef enum{
    UpdateDataType_None,
    UpdateDataType_Day,
    UpdateDataType_Date
}UpdateDataType;

typedef enum{
    ShowDataType_All,
    ShowDataType_Natural,
    ShowDataType_Extend
} ShowDataType;


@interface TYSXProvinceDataCtr : NetworkBase

@property (nonatomic, readonly) NSString *currentProvinceName;
@property (nonatomic, assign) int currentProvinceId;

@property (nonatomic, assign) UpdateDataType updateDataType;

@property (nonatomic, readonly) NSString *currentDateStr;
@property (nonatomic, readonly) NSArray *orderRank;
@property (nonatomic, readonly) NSArray *unsubscribeRank;
@property (nonatomic, readonly) NSArray *flowRank;
@property (nonatomic, readonly) NSNumber *currentOrderValue;
@property (nonatomic, readonly) NSNumber *currentUnsubscribeValue;
@property (nonatomic, readonly) NSNumber *currentFlowValue;
@property (nonatomic, copy) RefreshViewAction refreshAction;
@property (nonatomic, assign) ShowDataType showDataType;

@property (nonatomic, strong) NSDate *needUpdateDate;
@property (nonatomic, readonly) BOOL hasNetWorkData;

@property (nonatomic, readonly) NSArray *orderValueList;
@property (nonatomic, readonly) NSArray *unsubscribeValueList;
@property (nonatomic, readonly) NSArray *flowValueList;
@property (nonatomic, readonly) NSArray *dateList;
@property (nonatomic, readonly) long long minValue;
@property (nonatomic, readonly) long long maxValue;
@property (nonatomic, assign) int currentTypeId;


- (BOOL)hasAnyData;
- (BOOL)needNetworkData;
- (void)reloadProvinceData;
- (BOOL)isOverDate:(NSDate *)date;

- (void)reloadDateProvinceData;

@end
