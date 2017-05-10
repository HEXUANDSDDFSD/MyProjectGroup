//
//  TYSXStreamMediaMonitorCtr.h
//  tysx
//
//  Created by zwc on 14/11/25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "OSSCachePlotCtr.h"

#define kProductNameKey @"productName"
#define kValueKey @"value"
#define kTongbiKey @"tongBi"
#define kHuanbiKey @"huanBi"
#define kTongbiGapKey @"tbMinusV"
#define kHuanbiGapKey @"hbMinusV"
#define kLastUpdateTimeKey @"lastUpdate"

@interface TYSXStreamMediaMonitorCtr : OSSCachePlotCtr

@property (nonatomic, assign) NSInteger currentProductIndex;
@property (nonatomic, assign) NSInteger currentType;
@property (nonatomic, readonly) NSArray *productList;
@property (nonatomic, readonly) NSArray *sumTimesList;
@property (nonatomic, readonly) NSArray *currentTimesList;

@end
