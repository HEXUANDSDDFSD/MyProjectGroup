//
//  OSSCachePlotCtr.h
//  tysx
//
//  Created by zwc on 14/11/24.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "NetworkBase.h"
#import "DatabaseManager.h"

#define kDateKey @"date"
#define kDateSpan 31

typedef enum {
   CacheType_All,
    CacheType_Once
}CacheType;

@interface OSSCachePlotCtr : NetworkBase {
    id responeData;
    NSDate *willShowDate;
    NSDate *lastDate;
    NSString *endDateStr;
    NSString *startDateStr;
}

@property (nonatomic, readonly) BOOL hasAnyData;
@property (nonatomic, readonly) NSString *lastDateStr;
@property (nonatomic, readonly) CacheType cacheType;

- (id)initWithCacheType:(CacheType)cacheType;

- (void)saveNetworkDataWithCompleteBlock:(dispatch_block_t) complete;
- (NeedOperateType)changeLastDate:(NSDate *)date;

- (NSArray *)dataStrListWithDayNumber:(NSInteger)number;

- (NSString *)dateStringBeforeDayNumber:(NSInteger)num;
//choose overload

- (NSInteger)dateSpan;
+ (NSString *)path;

// must be overload
- (void)reloadData;
- (void)saveNetworkData;
- (void)createDatabase;
- (NSString *)databaseTableName;
- (void)allocDataContainer;
- (void)clearDataContainer;
- (int)dataType;

// - (void)successWithResponse:(id)responseObject

@end
