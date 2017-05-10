//
//  TYSXKeyPackageCtr.h
//  tysx
//
//  Created by zwc on 15/1/4.
//  Copyright (c) 2015年 huangjia. All rights reserved.
//

#import "OSSCachePlotCtr.h"

@interface TYSXKeyPackageCtr : OSSCachePlotCtr

@property (nonatomic, readonly) NSArray *sumOrderData;
@property (nonatomic, readonly) NSArray *naturalOrderData;
@property (nonatomic, readonly) NSArray *extendOrderData;
@property (nonatomic, readonly) NSArray *sumUnData;
@property (nonatomic, readonly) NSArray *naturalUnData;
@property (nonatomic, readonly) NSArray *extendUnData;

@property (nonatomic, assign) NSInteger selectedType;

@property (nonatomic, readonly) NSArray *productNameList;

@end
