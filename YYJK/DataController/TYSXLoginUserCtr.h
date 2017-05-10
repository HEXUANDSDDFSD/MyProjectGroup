//
//  TYSXLoginUserCtr.h
//  tysx
//
//  Created by zwc on 14/11/25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "OSSCachePlotCtr.h"

#define kOldKey @"old"
#define kNewKey @"new"
#define kClientNameKey @"clientName"
#define kTongbiKey @"tongbi"
#define kHuanbiKey @"huanbi"
#define kSumLoginKey @"countctld"

@interface TYSXLoginUserCtr : OSSCachePlotCtr

@property (nonatomic, readonly) NSArray *clientList;
@property (nonatomic, readonly) NSArray *loginUserNumList;
@property (nonatomic, readonly) NSArray *loginList;
@property (nonatomic, readonly) NSArray *playList;
@property (nonatomic, readonly) NSArray *orderList;
@property (nonatomic, assign) NSInteger selectedPlatIndex;

@end
