//
//  TYSXClientCtr.h
//  tysx
//
//  Created by zwc on 15/1/4.
//  Copyright (c) 2015年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSSCachePlotCtr.h"

@interface TYSXClientCtr : OSSCachePlotCtr

@property (nonatomic, readonly) NSArray *loginData;
@property (nonatomic, readonly) NSArray *playData;
@property (nonatomic, readonly) NSArray *conversionRateData;
@property (nonatomic, readonly) NSArray *orderData;
@property (nonatomic, readonly) NSArray *realTodayData;
@property (nonatomic, readonly) NSArray *realYesterdayData;
@property (nonatomic, readonly) NSArray *topTenData;
@property (nonatomic, readonly) NSArray *topTenNameList;
@property (nonatomic, readonly) NSArray *playNumData;
@property (nonatomic, readonly) NSArray *playUserData;
@property (nonatomic, readonly) NSArray *chooseTitleList;

@property (nonatomic, assign) int selectedPlayType;
@property (nonatomic, assign) int selectedMainType;
@property (nonatomic, assign) int selectedTopTenType;
@property (nonatomic, assign) NSInteger selecteTopTenIndex;

@property (nonatomic, readonly) NSInteger maxHour;

@end
