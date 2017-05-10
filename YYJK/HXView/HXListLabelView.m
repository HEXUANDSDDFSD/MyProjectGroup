//
//  HXListLabelView.m
//  tysx
//
//  Created by zwc on 13-11-12.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXListLabelView.h"

@implementation HXListLabelView
@synthesize monthStr;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setMonthStr:(NSString *)monthStr_ {
    monthStr = [monthStr_ copy];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [[UIColor colorWithRed:100/255.0 green:99/255.0 blue:99/255.0 alpha:1] set];
    UIFont *font = [UIFont systemFontOfSize:13];
    int offsetLeft = 10;
    int offsetTop = 3;
    [@"Drug Class" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withFont:font];
    offsetLeft += 645;
    [@"变化率" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withFont:font];
    offsetLeft += 253;
    [monthStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withFont:font];
}

@end
