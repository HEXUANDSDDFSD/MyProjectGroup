//
//  HXCoreplotXAxisLayer.m
//  tysx
//
//  Created by zwc on 14-8-7.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXCoreplotXAxisLayer.h"

@implementation HXCoreplotXAxisLayer
@synthesize sublineColor;
@synthesize sublineWidth;

- (id)init {
    if (self = [super init]) {
        self.contentWidthScale = 1.0;
        
        sublineWidth = 1;
        sublineColor = [UIColor grayColor];
    }
    return self;
}

@end
