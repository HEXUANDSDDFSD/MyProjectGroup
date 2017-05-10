//
//  HXCorePlotAxisLayer.h
//  tysx
//
//  Created by zwc on 14-7-22.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXCorePlotBaseLayer.h"

@class HXCorePlotYAxisLayer;

@protocol HXCorePlotYAxisDataSource <NSObject>

- (NSInteger)numberOfTitleInYAxis:(HXCorePlotYAxisLayer *)yAxis;
- (NSString *)yAxis:(HXCorePlotYAxisLayer *)yAxis titleAtIndex:(NSInteger)index isUseRightYAxis:(BOOL)isUseRight;


@end

@interface HXCorePlotYAxisLayer : HXCorePlotBaseLayer

@property (nonatomic, weak) id<HXCorePlotYAxisDataSource> dataSource;
@property (nonatomic, assign) BOOL needLegend;
@property (nonatomic, strong) NSArray *legendTitles;
@property (nonatomic, strong) NSArray *legendColor;
@property (nonatomic, assign) NSInteger numberOfSubline;
@property (nonatomic, assign) CGFloat sublineWidth;
@property (nonatomic, copy) UIColor *sublineColor;
//@property (nonatomic, )

@property (nonatomic, assign) BOOL needRightYAxis;


@end
