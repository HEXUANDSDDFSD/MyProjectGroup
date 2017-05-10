//
//  TYSXSuccessRateCtr.h
//  tysx
//
//  Created by zwc on 14-9-4.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "NetworkBase.h"

@interface TYSXSuccessRateCtr : NetworkBase

@property (nonatomic, readonly) NSString *lastDateStr;
@property (nonatomic, readonly) NSArray *dateList;
@property (nonatomic, readonly) NSArray *successData;
@property (nonatomic, readonly) NSArray *failureData;
@property (nonatomic, readonly) NSArray *aaaFailureData;
@property (nonatomic, readonly) NSArray *allData;
@property (nonatomic, readonly) NSArray *successRateData;

- (NeedOperateType)updateLastDate:(NSDate *)date;
- (void)saveNetworkDataWithCompleteBlock:(dispatch_block_t) complete;
- (void)reloadData;
- (BOOL)hasAnyData;

@end
