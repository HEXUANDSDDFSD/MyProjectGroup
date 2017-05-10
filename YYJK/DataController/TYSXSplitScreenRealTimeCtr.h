//
//  TYSXSplitScreenRealTimeCtr.h
//  tysx
//
//  Created by zwc on 15/1/4.
//  Copyright (c) 2015年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSSCachePlotCtr.h"

@interface TYSXSplitScreenRealTimeCtr : OSSCachePlotCtr

@property (nonatomic, readonly) NSArray *pvData;
@property (nonatomic, readonly) NSArray *uvData;
@property (nonatomic, readonly) NSArray *yesterdayPvData;
@property (nonatomic, readonly) NSArray *yesterdayUvData;
@property (nonatomic, assign) int selectedPlatType;
@property (nonatomic, assign) int selectedSubPlatType;

@property (nonatomic, readonly) NSArray *platNameList;
@property (nonatomic, readonly) NSArray *platSubTypeList;

@property (nonatomic, readonly) NSInteger maxHour;

@end
