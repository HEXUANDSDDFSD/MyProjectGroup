//
//  HXCorePlotCursorLayer.h
//  tysx
//
//  Created by zwc on 14-7-25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXCorePlotBaseLayer.h"

@class HXPlotCursor;

@protocol HXPlotCursorDataSource <NSObject>

- (NSString *)plotCursor:(HXPlotCursor *)plotCursor degreeNameOfIndex:(NSInteger)index;
- (NSInteger)numberOfDegreeInCursor:(HXPlotCursor *)plotCursor;

@optional

// only use when cursorType is CursorType_Single

- (NSInteger)numberOfComponentInCursor:(HXPlotCursor *)plotCursor;
- (NSString *)plotCursor:(HXPlotCursor *)plotCursor textOfIndex:(NSInteger)index component:(NSInteger)component;
- (UIColor *)plotCursor:(HXPlotCursor *)plotCursor textColorOfComponent:(NSInteger)component;

// only use when cursorType is CursorType_Double

- (NSString *)plotCursor:(HXPlotCursor *)plotCursor textOfIndex:(NSInteger)index;
- (NSNumber *)plotCursor:(HXPlotCursor *)plotCursor valueOfIndex:(NSInteger)index;

@end

typedef enum{
    CursorType_None,
    CursorType_Single,
    CursorType_Double
}CursorType;

@interface HXPlotCursor : HXCorePlotBaseLayer

@property (nonatomic, weak) id<HXPlotCursorDataSource> dataSource;
@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;
@property (nonatomic, assign) CGFloat onePosition;
@property (nonatomic, assign) NSInteger numberOfCursor;
@property (nonatomic, assign) CursorType cursorType;
@property (nonatomic, assign) CGFloat anotherPositon;
@property (nonatomic, assign) CGFloat nodeRadius;
@property (nonatomic, copy) UIFont *textFont;

@end
