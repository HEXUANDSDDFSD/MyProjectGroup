//
//  TYSXPlatLoginPlayCtr.h
//  tysx
//
//  Created by zwc on 14/12/30.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "OSSCachePlotCtr.h"

@interface TYSXPlatLoginPlayCtr : OSSCachePlotCtr

@property (nonatomic, readonly) NSArray *loginData;
@property (nonatomic, readonly) NSArray *playData;
@property (nonatomic, readonly) NSArray *conversionRateData;
@property (nonatomic, readonly) NSDictionary *provinceData;
@property (nonatomic, readonly) NSArray *zhiboData;
@property (nonatomic, readonly) NSArray *dianboData;
@property (nonatomic, readonly) NSArray *huikanData;
@property (nonatomic, readonly) NSArray *xiazaiData;
@property (nonatomic, readonly) NSArray *fujiaData;
@property (nonatomic, readonly) NSArray *averageData;

@property (nonatomic, assign) NSInteger selectedProvinceType;
@property (nonatomic, assign) NSInteger selectedAppendType;
@property (nonatomic, assign) NSInteger selectedProvinceDateIndex;

@end
