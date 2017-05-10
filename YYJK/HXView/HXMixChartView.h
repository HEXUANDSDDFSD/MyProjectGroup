//
//  HXMixChartView.h
//  tysx
//
//  Created by zwc on 14-2-26.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMixChartView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *xNames;
@property (nonatomic, copy) NSArray *yNames;
@property (nonatomic, copy) NSArray *cells;
@property (nonatomic, assign) CGFloat leftMinValue;
@property (nonatomic, assign) CGFloat leftMaxValue;
@property (nonatomic, assign) CGFloat rightMinValue;
@property (nonatomic, assign) CGFloat rightMaxValue;
@property (nonatomic, assign) int yCount;
@property (nonatomic, assign) BOOL isShowCellName;

@end
