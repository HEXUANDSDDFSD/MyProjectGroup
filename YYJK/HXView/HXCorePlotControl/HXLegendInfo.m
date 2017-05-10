//
//  LegendInfo.m
//  tysx
//
//  Created by zwc on 14/11/17.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXLegendInfo.h"

@implementation HXLegendInfo

- (id)init {
    if (self = [super init]) {
        self.font = [UIFont systemFontOfSize:12];
        self.fillWidth = 10;
        self.fillHeight = 10;
        self.intervalX = 7;
        self.legendType = LegendType_Bar;
    }
    return self;
}

- (CGFloat)titleTopOffset {
    CGSize titleSize = [self.legendTitle sizeWithAttributes:@{NSFontAttributeName:self.font}];
    return titleSize.height / 2;
}

- (CGFloat)titleWidth {
   return [self.legendTitle sizeWithAttributes:@{NSFontAttributeName:self.font}].width;
}

@end
