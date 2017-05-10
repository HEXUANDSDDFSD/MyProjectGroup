//
//  HXHeapBarPlot.h
//  tysx
//
//  Created by zwc on 14-7-29.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXBasePlot.h"

@class HXHeapBarPlot;

@protocol HXHeapBarPlotDataSource <NSObject>

- (NSInteger)numberOfXValuesInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot;
- (NSInteger)numberOfHeapBarInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot;
- (NSNumber *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot valueOfXIndex:(NSInteger)xIndex heapIndex:(NSInteger)heapIndex;
- (UIColor *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot colorOfHeapIndex:(NSInteger)heapIndex;

@end

@interface HXHeapBarPlot : HXBasePlot

@property (nonatomic, weak) id<HXHeapBarPlotDataSource> dataSource;
@property (nonatomic, assign) CGFloat beginPosition;
@property (nonatomic, assign) CGFloat endPosition;
@property (nonatomic, assign) BOOL needShowValue;
@end
