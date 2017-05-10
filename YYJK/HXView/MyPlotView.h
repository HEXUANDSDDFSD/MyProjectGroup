//
//  MyPlotView.h
//  MyChartPlotTest
//
//  Created by zwc on 14-6-23.
//  Copyright (c) 2014年 MYSTERIOUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPlotView : UIView

@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingBottom;

@property (nonatomic, assign) CGFloat plotpaddingLeft;
@property (nonatomic, assign) CGFloat plotPaddingRight;

@property (nonatomic, strong) NSArray *horizonalTitles;
@property (nonatomic, strong) NSArray *showHorizonalTitles;
@property (nonatomic, strong) NSArray *values;

@property (nonatomic, assign) CGFloat maxVerticalValue;
@property (nonatomic, assign) CGFloat minVerticalValue;

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *gradientColor;

@property (nonatomic, copy) NSString *unitStr;
@property (nonatomic, assign) BOOL needChangeBigUnit;
@property (nonatomic, assign) BOOL needUseFloatValue;

@end
