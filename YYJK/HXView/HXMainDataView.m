//
//  HXMainDataView.m
//  tysx
//
//  Created by zwc on 13-11-14.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXMainDataView.h"
#import "NSNumber+Format.h"

@implementation HXMainDataView {
    NSString *firstStr;
    NSString *secondStr;
}

@synthesize productName;
@synthesize typeName;
@synthesize currentDayStr;
@synthesize currentValue;
@synthesize compareValue;
@synthesize isCompareWeek;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark set reDraw

- (void)setCurrentDayStr:(NSString *)currentDayStr_ {
    if (![currentDayStr_ isEqualToString:currentDayStr]) {
        currentDayStr = currentDayStr_;
        [self setNeedsDisplay];
    }
}

- (void)setCurrentValue:(long long)currentValue_ {
    if (currentValue != currentValue_) {
        currentValue = currentValue_;
        [self setNeedsDisplay];
    }
}

- (void)setCompareValue:(long long)compareValue_{
    if (compareValue != compareValue_) {
        compareValue = compareValue_;
        [self setNeedsDisplay];
    }
}

- (void)drawTriangleWithIsUp:(BOOL)isUp
                       color:(UIColor* )color
                  beginPoint:(CGPoint)beginPoint {
    CGFloat side = 25;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, beginPoint.x, beginPoint.y);
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    if (!isUp) {
        CGContextAddLineToPoint(context, beginPoint.x + side, beginPoint.y);
        CGContextAddLineToPoint(context, beginPoint.x + side / 2, beginPoint.y + sin(M_PI_2 * 2 / 3) * side);
    }
    else {
        CGContextAddLineToPoint(context, beginPoint.x - side / 2, beginPoint.y + sin(M_PI_2 * 2 / 3) * side);
        CGContextAddLineToPoint(context, beginPoint.x + side / 2, beginPoint.y + sin(M_PI_2 * 2 / 3) * side);
    }
    
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)drawTriangleWithColor:(UIColor *)color
                  centerPoint:(CGPoint)centerPoint
                         side:(CGFloat)side
                         isUp:(BOOL)isUp
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int controlValue;
    controlValue = isUp ? -1 : 1;
    
    CGContextMoveToPoint(context, centerPoint.x, centerPoint.y + side / 2 / sin(M_PI_2 * 2 / 3) * controlValue);
    CGContextAddLineToPoint(context, centerPoint.x - side / 2, centerPoint.y + side / 2 / tan(M_PI_2 * 2 / 3) * controlValue * -1);
    CGContextAddLineToPoint(context, centerPoint.x + side / 2, centerPoint.y + side / 2 / tan(M_PI_2 * 2 / 3) * controlValue * -1);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (NSString *)rateStrWithCompareValue:(long long)value {
    NSString *ret = nil;
    
    if (currentValue == value) {
        ret = @"0.00%";
    }
    else if (currentValue != 0 && value == 0) {
        ret = @"";
    }
    else if (currentValue > value) {
        CGFloat rate = (currentValue - value) * 100.0 / value;
        ret = [@"+ " stringByAppendingFormat:@"%0.2f%%", rate];
    }
    else {
        CGFloat rate = (value - currentValue) * 100.0 / value;
        ret = [@"- " stringByAppendingFormat:@"%0.2f%%", rate];
    }
    
    return  ret;
}

- (void)drawRect:(CGRect)rect {
    int offsetLeft = 27;
    int offsetTop = 10;
    
    NSString *unitStr = self.unitStr;
    if (unitStr == nil) {
        unitStr = @"";
    }
    
    NSString *drawValueStr = nil;
    
    [[UIColor darkGrayColor] set];
    
    NSString *dateStr = currentDayStr;
    [dateStr drawInRect:CGRectMake(offsetLeft, offsetTop, rect.size.width - offsetLeft * 2, 30) withFont:[UIFont systemFontOfSize:20] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
    
    offsetTop += 80;
    
    
    [self.productName drawAtPoint:CGPointMake(offsetLeft, offsetTop) withFont:[UIFont systemFontOfSize:22]];
    
    offsetTop += 60;
    
    [self.typeName drawAtPoint:CGPointMake(offsetLeft, offsetTop) withFont:[UIFont systemFontOfSize:18]];
    
    offsetLeft += 20;
    offsetTop += 60;
    int drawWidth = 200;
    
    [@"当前" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withFont:[UIFont systemFontOfSize:15]];
//    currentValue > compareValue ?  [kFreshGreenColor set] : [[UIColor redColor] set];
    
    if (self.needChangeBigUnit) {
        drawValueStr = [NSString stringWithFormat:@"%.2f%@", currentValue / 1024.0 / 1024, unitStr];
    }
    else {
        drawValueStr = [NSString stringWithFormat:@"%lld%@", currentValue, unitStr];
    }
    
    [drawValueStr drawInRect:CGRectMake(offsetLeft, offsetTop - 5, drawWidth, 30) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    offsetTop += 40;
    [[UIColor grayColor] set];
    
    NSString *compareStr = nil;
    if (isCompareWeek) {
        compareStr = @"上周";
    }
    else {
        compareStr = @"昨日";
    }
    
    [@"上周" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withFont:[UIFont systemFontOfSize:15]];
    
    if (self.needChangeBigUnit) {
        drawValueStr = [NSString stringWithFormat:@"%.2f%@", self.weakCompareValue / 1024.0 / 1024, unitStr];
    }
    else {
        drawValueStr = [NSString stringWithFormat:@"%lld%@", self.weakCompareValue, unitStr];
    }
    
    [drawValueStr drawInRect:CGRectMake(offsetLeft, offsetTop - 5, drawWidth, 30) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    offsetTop += 35;
    
    UIColor *useColor = nil;
    BOOL isUp = currentValue > self.weakCompareValue;
    useColor = (currentValue > self.weakCompareValue) ? kFreshGreenColor : [UIColor redColor];
    [self drawTriangleWithColor:useColor
                    centerPoint:CGPointMake(offsetLeft + 13, offsetTop + 18)
                           side:25
                           isUp:isUp];
    [useColor set];
    [[self rateStrWithCompareValue:self.weakCompareValue] drawInRect:CGRectMake(offsetLeft, offsetTop, drawWidth, 30) withFont:[UIFont systemFontOfSize:28] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    [[UIColor grayColor] set];
    offsetTop += 33;
    [@"%变化率" drawInRect:CGRectMake(offsetLeft, offsetTop, drawWidth, 30) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    offsetTop += 40;
    [[UIColor grayColor] set];
    
    compareStr = nil;
    if (isCompareWeek) {
        compareStr = @"上周";
    }
    else {
        compareStr = @"昨日";
    }
    
    [@"昨日" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withFont:[UIFont systemFontOfSize:15]];
    
    if (self.needChangeBigUnit) {
        drawValueStr = [NSString stringWithFormat:@"%.2f%@", self.dayCompareValue / 1024.0 / 1024, unitStr];
    }
    else {
        drawValueStr = [NSString stringWithFormat:@"%lld%@", self.dayCompareValue, unitStr];
    }
    [drawValueStr drawInRect:CGRectMake(offsetLeft, offsetTop - 5, drawWidth, 30) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    offsetTop += 35;
    
    useColor = nil;
    isUp = currentValue > self.dayCompareValue;
    useColor = (currentValue > self.dayCompareValue) ? kFreshGreenColor : [UIColor redColor];
    [self drawTriangleWithColor:useColor
                    centerPoint:CGPointMake(offsetLeft + 13, offsetTop + 18)
                           side:25
                           isUp:isUp];
    [useColor set];
    [[self rateStrWithCompareValue:self.dayCompareValue] drawInRect:CGRectMake(offsetLeft, offsetTop, drawWidth, 30) withFont:[UIFont systemFontOfSize:28] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    [[UIColor grayColor] set];
    offsetTop += 33;
    [@"%变化率" drawInRect:CGRectMake(offsetLeft, offsetTop, drawWidth, 30) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
}

@end
