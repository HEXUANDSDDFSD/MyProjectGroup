//
//  HXIPOrderAbnormalCtr.h
//  tysx
//
//  Created by zwc on 14-8-14.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "NetworkBase.h"

#define kDateKey @"ordertime"
#define kIpKey @"sourceIp"
#define kAddressKey @"adress"
#define kProductNameKey @"productId"
#define kOrderTimesKey @"cout"

@interface TYSXIPOrderAbnormalCtr : NetworkBase

@property (nonatomic, readonly) NSArray *abnormalDatas;

@property (nonatomic, readonly) NSString *lastDateStr;

- (NeedOperateType)updateLastDate:(NSDate *)date;
- (void)saveNetworkDataWithCompleteBlock:(dispatch_block_t) complete;
- (void)reloadData;
- (BOOL)hasAnyData;

@end
