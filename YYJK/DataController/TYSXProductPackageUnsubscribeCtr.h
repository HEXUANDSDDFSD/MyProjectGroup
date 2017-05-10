//
//  TYSXProductPackageUnsubscribeCtr.h
//  tysx
//
//  Created by zwc on 14/11/26.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "OSSCachePlotCtr.h"

#define kProductNameKey @"productName"
#define kUnsubscribeTimesKey @"unsubscribeTimes"
#define kTongbiKey @"tongBi"
#define kHuanbiKey @"huanBi"
#define kTongbiGapKey @"tbMinusV"
#define kHuanbiGapKey @"hbMinusV"
#define kLastUpdateTimeKey @"lastUpdate"

@interface TYSXProductPackageUnsubscribeCtr : OSSCachePlotCtr

@property (nonatomic, assign) NSInteger currentProductIndex;
@property (nonatomic, readonly) NSArray *productList;
@property (nonatomic, readonly) NSArray *sumTimesList;
@property (nonatomic, readonly) NSArray *currentTimesList;

@end
