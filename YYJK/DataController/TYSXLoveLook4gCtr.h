//
//  TYSXLoveLook4gCtr.h
//  tysx
//
//  Created by zwc on 15/1/4.
//  Copyright (c) 2015年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSSCachePlotCtr.h"

@interface TYSXLoveLook4gCtr : OSSCachePlotCtr

@property (nonatomic, readonly) NSArray *loginData;
@property (nonatomic, readonly) NSArray *playData;
@property (nonatomic, readonly) NSArray *conversionRateData;
@property (nonatomic, readonly) NSArray *orderData;
@property (nonatomic, readonly) NSArray *realTimeTodayData;
@property (nonatomic, readonly) NSArray *realTimeYesterdayData;
@property (nonatomic, readonly) NSArray *topTenNameList;
@property (nonatomic, readonly) NSArray *topTenData;

@property (nonatomic, assign) int selectedMainType;
@property (nonatomic, assign) int selectedTopTenType;
@property (nonatomic, readonly) NSArray *topTenTypeNameList;

@property (nonatomic, readonly) NSInteger maxHour;

@property (nonatomic, assign) NSInteger selecteTopTenIndex;

@end
