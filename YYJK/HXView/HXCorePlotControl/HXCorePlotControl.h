//
//  HXCorePlotControl.h
//  tysx
//
//  Created by zwc on 14-7-22.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXCorePlot.h"
#import "HXCorePlotLayerDelegate.h"
#import "HXCoreplotXAxisLayer.h"
#import "HXCorePlotYAxisLayer.h"
#import "HXPlotCursor.h"
#import "HXBasePlot.h"

@class HXCorePlotControl;

@protocol HXCorePlotControlDelegate <NSObject>

- (NSInteger)numberOfNeedTouchDegreeCorePlotControl:(HXCorePlotControl *)corePlotControl;
- (void)corePlotControl:(HXCorePlotControl *)corePlotControl touchIndex:(NSInteger)index;

@end

typedef enum {
    TitleLocation_Top,
    TitleLocation_Bottom
}TitleLocation;

@interface HXCorePlotControl : UIView

@property (nonatomic, readonly) HXCorePlotLayerDelegate *layerManager;
@property (nonatomic, readonly) HXCorePlotYAxisLayer *yAxis;
@property (nonatomic, readonly) HXCoreplotXAxisLayer *xAxis;
@property (nonatomic, assign) BOOL needCursor;
@property (nonatomic, readonly) HXPlotCursor *cursor;
@property (nonatomic, readonly) NSArray *plotLayers;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) CGFloat titleOffset;

@property (nonatomic, copy) NSString *unitString;
@property (nonatomic, copy) NSString *rightUnitString;

@property (nonatomic, assign) TitleLocation titleLocation;
@property (nonatomic, strong) NSArray *legendList;
@property (nonatomic, assign) CGFloat legendIntervalX;
@property (nonatomic, assign) CGPoint legendOriginPoint;
@property (nonatomic, weak) id<HXCorePlotControlDelegate> delegate;

- (void)reloadData;
- (void)addPlot:(HXBasePlot *)plot;
- (void)removePlotWithName:(NSString *)name;
- (void)removePlotAtIndex:(NSInteger)index;

- (void)removeAllPlot;

@end
