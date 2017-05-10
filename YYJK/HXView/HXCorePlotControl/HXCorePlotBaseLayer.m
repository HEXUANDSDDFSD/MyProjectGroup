//
//  HXCorePlotBaseLayer.m
//  tysx
//
//  Created by zwc on 14-7-22.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXCorePlotBaseLayer.h"
#import "HXCorePlotYAxisLayer.h"

@implementation HXCorePlotBaseLayer

+ (id)layer {
     return [[[self class] alloc] init];
}

- (id)init {
    if (self = [super init]) {
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

@end
