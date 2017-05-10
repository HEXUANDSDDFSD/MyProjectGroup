//
//  HXHeapBarPlot.m
//  tysx
//
//  Created by zwc on 14-7-29.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXHeapBarPlot.h"

@implementation HXHeapBarPlot {
    CGFloat _beginPosition;
    CGFloat _endPosition;
}

@synthesize dataSource;

- (id)init {
    if (self = [super init]) {
        _beginPosition = 0.1;
        _endPosition = 0.9;
    }
    return self;
}

- (void)setBeginPosition:(CGFloat)beginPosition {
    if (_beginPosition < 0) {
        _beginPosition = 0;
    }
    else if (_beginPosition > 1) {
        _beginPosition = 1;
    }
    _beginPosition = beginPosition;
}

- (void)setEndPosition:(CGFloat)endPosition {
    if (_endPosition < 0) {
        _endPosition = 0;
    }
    else if (_endPosition> 1) {
        _endPosition = 1;
    }
    _endPosition = endPosition;
}

- (CGFloat)beginPosition {
    return _beginPosition;
}

- (CGFloat)endPosition {
    return _endPosition;
}

@end
