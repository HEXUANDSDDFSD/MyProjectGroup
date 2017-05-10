//
//  HXBasePlot.h
//  tysx
//
//  Created by zwc on 14-7-29.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXCorePlotBaseLayer.h"

@class HXBasePlot;

@protocol HXBaseDataSource <NSObject>

- (NSInteger)numberOfPlot:(HXBasePlot *)plot;
- (NSNumber *)plot:(HXBasePlot *)plot index:(NSInteger)index;

@end

@interface HXBasePlot : HXCorePlotBaseLayer

@property (nonatomic, assign) BOOL isUseRightAxisY;
@property (nonatomic, copy) NSString *plotName;

@end
