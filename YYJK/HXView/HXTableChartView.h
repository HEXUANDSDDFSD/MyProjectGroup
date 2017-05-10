//
//  HXTableChartView.h
//  tysx
//
//  Created by zwc on 13-12-18.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXTableChartView;

@protocol HXTableChartViewDataSource <NSObject>

- (NSInteger)numberOfRowsInTableChartView:(HXTableChartView *)menuView;

- (NSInteger)numberOfColumnsInTableChartView:(HXTableChartView *)menuView;

- (CGFloat)tableChartView:(HXTableChartView *)tableChartView
            widthOfColumn:(NSInteger)column;

- (CGFloat)tableChartView:(HXTableChartView *)tableChartView
              heightOfRow:(NSInteger)row;

- (UIFont *)tableChartView:(HXTableChartView *)tableChartView
                 fontOfRow:(NSInteger)row
                    column:(NSInteger)column;

- (UIColor *)tableChartView:(HXTableChartView *)tableChartView
       backgroundColorOfRow:(NSInteger)row
                     column:(NSInteger)column;

- (UIColor *)tableChartView:(HXTableChartView *)tableChartView
             textColorOfRow:(NSInteger)row
                     column:(NSInteger)column;

- (NSString *)tableChartView:(HXTableChartView *)tableChartView
                   textOfRow:(NSInteger)row
                      column:(NSInteger)column;

- (BOOL)tableChartView:(HXTableChartView *)tableChartView
                   needDrawTrendOfRow:(NSInteger)row
                      column:(NSInteger)column;

- (eDrawDirection)tableChartView:(HXTableChartView *)tableChartView
                   drawTrendDerictionOfRow:(NSInteger)row
                      column:(NSInteger)column;


@end

@interface HXTableChartView : UIView

@property (nonatomic, weak) id<HXTableChartViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat borderLineWidth;
@property (nonatomic, copy) UIColor *borderLineColor;
@property (nonatomic, assign) CGFloat rowLineWidth;
@property (nonatomic, assign) UIColor *rowLineColor;
@property (nonatomic, assign) CGFloat columnLineWidth;
@property (nonatomic, assign) UIColor *columnLineColor;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *bottomStr;
@property (nonatomic, readonly) UIView *showTopView;

@end
