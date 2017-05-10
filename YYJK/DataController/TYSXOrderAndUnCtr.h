//
//  TYSXOrderAndUnCtr.h
//  tysx
//
//  Created by zwc on 14/12/31.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "OSSCachePlotCtr.h"

@interface TYSXOrderAndUnCtr : OSSCachePlotCtr

@property (nonatomic, readonly) NSArray *orderData;
@property (nonatomic, readonly) NSArray *unsubscribeData;
@property (nonatomic, readonly) NSArray *conversionRateData;
@property (nonatomic, readonly) NSArray *timesData;
@property (nonatomic, readonly) NSDictionary *provinceData;
@property (nonatomic, readonly) NSArray *yunyingData;
@property (nonatomic, readonly) NSArray *yingxiaoData;
@property (nonatomic, readonly) NSArray *chanpinData;
@property (nonatomic, readonly) NSArray *otherData;
@property (nonatomic, readonly) NSArray *tingjiData;
@property (nonatomic, readonly) NSArray *fujiData;
@property (nonatomic, readonly) NSArray *baoyueData;
@property (nonatomic, readonly) NSArray *anciData;

@property (nonatomic, assign) NSInteger selectedMainType;
@property (nonatomic, assign) NSInteger selectedProvinceType;
@property (nonatomic, assign) NSInteger selectedProvinceDateIndex;

@end
