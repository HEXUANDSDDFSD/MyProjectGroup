//
//  TYSXPlatformCtr.h
//  tysx
//
//  Created by zwc on 14-7-28.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "NetworkBase.h"

@interface TYSXPlatformCtr : NetworkBase

@property (nonatomic, readonly) NSString *lastDateStr;
@property (nonatomic, readonly) NSArray *accessData;
@property (nonatomic, readonly) NSArray *loginData;
@property (nonatomic, readonly) NSArray *playbackData;
@property (nonatomic, readonly) NSArray *loginTransData;
@property (nonatomic, readonly) NSArray *playbackTransData;
@property (nonatomic, readonly) NSArray *dateList;

@property (nonatomic, readonly) NSArray *platIdList;
@property (nonatomic, assign) NSInteger currentPlatIndex;
@property (nonatomic, assign) NSInteger currentDimensionIndex;

- (NSString *)platNameWithPlatId:(NSString *)platId;
- (NeedOperateType)updateLastDate:(NSDate *)date;
- (void)saveNetworkDataWithCompleteBlock:(dispatch_block_t) complete;
- (void)reloadData;
- (BOOL)hasAnyData;

@end
