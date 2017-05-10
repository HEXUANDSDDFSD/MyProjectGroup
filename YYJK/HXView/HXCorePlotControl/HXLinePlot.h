//
//  HXLinePlot.h
//  tysx
//
//  Created by zwc on 14-7-29.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXBasePlot.h"

@interface HXLinePlot : HXBasePlot

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) BOOL needFill;
@property (nonatomic, assign) NSInteger showLimitNum;
@property (nonatomic, strong) UIColor *topGradientColor;
@property (nonatomic, strong) UIColor *bottomGradientColor;

@property (nonatomic, weak) id<HXBaseDataSource> dataSource;

@end
