//
//  TYSXCRMDataCtr.h
//  tysx
//
//  Created by zwc on 14-2-21.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYSXCRMDataCtr : NSObject

@property (nonatomic, readonly) NSArray *orderAndCancelData;
@property (nonatomic, readonly) NSArray *dates;
@property (nonatomic, readonly) NSArray *provinces;
@property (nonatomic, readonly) NSArray *orderAndCancelChartData;
@property (nonatomic, readonly) NSArray *orderByProvinceData;
@property (nonatomic, readonly) NSArray *cemChartData;
@property (nonatomic, readonly) NSArray *crmDetails;
@property (nonatomic, readonly) NSArray *crmProvinceTableData;
@property (nonatomic, readonly) NSString *orderAndCancelStr;

@end
