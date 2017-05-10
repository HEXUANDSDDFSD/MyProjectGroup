//
//  HXCorePlotAxisLayer.m
//  tysx
//
//  Created by zwc on 14-7-22.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXCorePlotYAxisLayer.h"

@implementation HXCorePlotYAxisLayer {
    BOOL _needRightYAxis;
}

@synthesize dataSource;
@synthesize sublineColor;
@synthesize sublineWidth;

+ (HXCorePlotYAxisLayer *)layer {
    return [[HXCorePlotYAxisLayer alloc] init];
}

- (id)init {
    if (self = [super init]) {
        sublineWidth = 1;
        sublineColor = [UIColor grayColor];
    }
    return self;
}

- (void)setNeedRightYAxis:(BOOL)needRightYAxis {
    _needRightYAxis = needRightYAxis;
    [self setNeedsDisplay];
}

- (BOOL)needRightYAxis {
    return _needRightYAxis;
}

@end
