//
//  HXCoreplotXAxisLayer.h
//  tysx
//
//  Created by zwc on 14-8-7.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXCorePlotBaseLayer.h"

@class HXCoreplotXAxisLayer;

@protocol HXCoreplotXAxisDataSource <NSObject>

- (NSInteger)numberOfTitleInXAxis:(HXCoreplotXAxisLayer *)xAxis;
- (NSString *)xAxis:(HXCoreplotXAxisLayer *)xAxis titleAtIndex:(NSInteger)index;

@end

@interface HXCoreplotXAxisLayer : HXCorePlotBaseLayer

@property (nonatomic, assign) CGFloat contentWidthScale;
@property (nonatomic, assign) CGFloat offsetLeft;
@property (nonatomic, assign) CGFloat offsetRight;
@property (nonatomic, assign) NSInteger numberOfSubline;
@property (nonatomic, assign) CGFloat sublineWidth;
@property (nonatomic, copy) UIColor *sublineColor;
@property (nonatomic, weak) id<HXCoreplotXAxisDataSource> dataSource;

@end
