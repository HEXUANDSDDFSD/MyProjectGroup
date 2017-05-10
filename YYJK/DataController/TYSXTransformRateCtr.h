//
//  TYSXTransformRateCtr.h
//  tysx
//
//  Created by zwc on 14-7-14.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "NetworkBase.h"

@interface TYSXTransformRateCtr : NetworkBase

@property (nonatomic, readonly) NSString *lastDateStr;
@property (nonatomic, readonly) NSArray *allData;
@property (nonatomic, readonly) NSArray *natureData;
@property (nonatomic, readonly) NSArray *extendData;
@property (nonatomic, readonly) NSArray *showDateStrs;
@property (nonatomic, readonly) NSArray *allDateStrs;

@property (nonatomic, readonly) NSArray *platIdList;
@property (nonatomic, readonly) NSArray *platNameList;

@property (nonatomic, assign) NSInteger currentPlatIndex;

- (NeedOperateType)updateLastDate:(NSDate *)date;
- (void)saveNetworkDataWithCompleteBlock:(dispatch_block_t) complete;
- (void)reloadData;
- (BOOL)hasAnyData;

@end
