//
//  HXCorePlotCursorLayer.m
//  tysx
//
//  Created by zwc on 14-7-25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXPlotCursor.h"

@implementation HXPlotCursor {
    CGFloat _onePosition;
    CGFloat _anotherPosition;
    NSInteger _numberOfCursor;
    BOOL _needShowCursor;
}

- (void)setNumberOfCursor:(NSInteger)numberOfCursor {
    _numberOfCursor = numberOfCursor;
    [self setNeedsDisplay];
}

- (NSInteger)numberOfCursor {
    return _numberOfCursor;
}

- (void)setOnePosition:(CGFloat)onePosition {
    _onePosition = onePosition;
    [self setNeedsDisplay];
}

- (CGFloat)onePosition {
    return _onePosition;
}

- (void)setAnotherPositon:(CGFloat)anotherPositon {
    _anotherPosition = anotherPositon;
    [self setNeedsDisplay];
}

- (CGFloat)anotherPositon {
    return _anotherPosition;
}

- (void)setNeedShowCursor:(BOOL)needShowCursor {
    _needShowCursor = needShowCursor;
    [self setNeedsDisplay];
}

- (BOOL)needShowCursor {
    return _needShowCursor;
}

@end
