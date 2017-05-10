//
//  HXMixChartView.m
//  tysx
//
//  Created by zwc on 14-2-26.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXMixChartView.h"
#import "UIColor+category.h"
#import <QuartzCore/QuartzCore.h>
#import "HXMixChartCell.h"
#import "NSString+Draw.h"

#define kTitleOffsetTop 20
#define kChartOffsetTop 100
#define kLeftPadding  70
#define kChartOffsetBottom 80

@implementation HXMixChartView {
    CGFloat charOffestBottom;
}
@synthesize isShowCellName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        charOffestBottom = kChartOffsetBottom;
    }
    return self;
}

- (void)setIsShowCellName:(BOOL)isShowCellName_ {
    isShowCellName = isShowCellName_;
    if (isShowCellName) {
        charOffestBottom += 15;
    }
}

- (void)layoutSubviews {
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    CGFloat xEvery = (self.bounds.size.width - 2 * kLeftPadding) / [self.xNames count];
    for (int i = 0; i < [self.xNames count]; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPadding + xEvery * i - 4, self.bounds.size.height - charOffestBottom + 18, xEvery + 8, 13)];
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor clearColor];
        label.text = [self.xNames objectAtIndex:i];
        label.textColor = [UIColor grayColor];
        label.transform = CGAffineTransformMakeRotation(-M_PI_2 / 3);
        [self addSubview:label];
    }
}

- (void)drawRect:(CGRect)rect {
//    if (self.isShowCellName) {
//    }
    
    [[UIColor grayColorWithGrayDegree:80/255.0] set];
    
    [@"x10000" drawRotationAtPoint:CGPointMake(30, kChartOffsetTop + 100) withFont:[UIFont systemFontOfSize:12] angle:M_PI_2];
    
    [self.title drawInRect:CGRectMake(0, kTitleOffsetTop, rect.size.width, 30)
                  withFont:[UIFont systemFontOfSize:20]
             lineBreakMode:NSLineBreakByTruncatingTail
                 alignment:NSTextAlignmentCenter];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat intervalY = (rect.size.height - kChartOffsetTop - charOffestBottom) / (self.yCount - 1);
    for (int i = 0; i < self.yCount; i++) {
        CGContextMoveToPoint(context, kLeftPadding, kChartOffsetTop + intervalY * i);
        CGContextAddLineToPoint(context, rect.size.width - kLeftPadding,kChartOffsetTop + intervalY * i);
        CGContextStrokePath(context);
    }
    
    CGFloat leftEvery = (self.leftMaxValue - self.leftMinValue) / (self.yCount - 1);
    CGFloat rightEvery = (self.rightMaxValue - self.rightMinValue) / (self.yCount - 1);
    for (int i = 0; i < self.yCount; i++) {
        NSString *leftStr = [NSString stringWithFormat:@"%d", (int)(self.leftMaxValue - leftEvery * i)];
        NSString *rightStr = [NSString stringWithFormat:@"%.1f", self.rightMaxValue - rightEvery * i];
        [leftStr drawAtPoint:CGPointMake(kLeftPadding - 30, kChartOffsetTop + intervalY * i - 8)withFont:[UIFont systemFontOfSize:13]];
        [rightStr drawAtPoint:CGPointMake(rect.size.width - kLeftPadding + 8, kChartOffsetTop + intervalY * i - 8) withFont:[UIFont systemFontOfSize:13]];
    }
    
    for (int i = 0; i < [self.cells count]; i++) {
        HXMixChartCell *cell = [self.cells objectAtIndex:i];
        int chartColumnCount = (int)[cell.datas count];
        CGFloat everyWidth = (rect.size.width - 2 * kLeftPadding) / chartColumnCount;
        
        if (cell.type == ChartType_Bar) {
            for (int i = 0; i < [cell.datas count]; i++) {
                CGContextSetFillColorWithColor(context, cell.color.CGColor);
                float value = [[cell.datas objectAtIndex:i] floatValue];
                CGRect drawRect = CGRectZero;
                drawRect.origin.x = kLeftPadding + everyWidth / 4 + i * everyWidth;
                drawRect.origin.y = [self yWithChartValue:value];
                drawRect.size.height = rect.size.height - charOffestBottom - drawRect.origin.y;
                drawRect.size.width = everyWidth / 2;
                CGContextFillRect(context, drawRect);
                NSString *valueStr = [NSString stringWithFormat:@"%.1f",value];
                CGFloat drawValueStrY = 0;
                if (i % 2 == 0) {
                    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
                    CGContextMoveToPoint(context, kLeftPadding + everyWidth / 2 + i * everyWidth, drawRect.origin.y);
                    CGContextAddLineToPoint(context, kLeftPadding + everyWidth / 2 + i * everyWidth, drawRect.origin.y - 8);
                    CGContextStrokePath(context);
                    drawValueStrY = drawRect.origin.y - 20 - 8;
                    
                }
                else {
                    drawValueStrY = drawRect.origin.y - 20;
                }
                [[UIColor grayColor] set];
                [valueStr drawInRect:CGRectMake(kLeftPadding + i * everyWidth, drawValueStrY, everyWidth, 20)
                            withFont:[UIFont systemFontOfSize:10]
                       lineBreakMode:NSLineBreakByTruncatingTail
                           alignment:NSTextAlignmentCenter];
            }
        }
        else {
            CGContextSetStrokeColorWithColor(context, cell.color.CGColor);
            CGContextSetLineWidth(context, 2);
            CGContextMoveToPoint(context, kLeftPadding + everyWidth / 2, [self yWithChartValue:[[cell.datas objectAtIndex:0] floatValue]]);
            for (int i = 1; i < [cell.datas count]; i++) {
                CGPoint drawPoint = CGPointZero;
                drawPoint.x = kLeftPadding + everyWidth / 2 + i * everyWidth;
                drawPoint.y = [self yWithChartValue:[[cell.datas objectAtIndex:i] floatValue]];
                CGContextAddLineToPoint(context, drawPoint.x, drawPoint.y);
            }
            CGContextStrokePath(context);
        }

    }
    
    // draw cell name
    
    if (!self.isShowCellName) {
        return;
    }
    
    CGFloat markWidth = 20;
    CGFloat markBarHeight = 10;
    CGFloat intervalXLittle = 5;
    CGFloat intervalXLarge = 10;
    CGFloat sumWidth = 0;
    CGFloat topOffset = rect.size.height - 30;
    UIFont *drawFont = [UIFont systemFontOfSize:14];
    for (int i = 0; i < [self.cells count]; i++) {
        HXMixChartCell *cell = [self.cells objectAtIndex:i];
        sumWidth += markWidth + intervalXLittle + [cell.name sizeWithFont:drawFont].width + intervalXLarge;
    }
    
    sumWidth -= intervalXLarge;
    CGFloat leftPadding = (kScreenHeight - sumWidth) / 2;
    for (int i = 0; i < [self.cells count]; i++) {
        HXMixChartCell *cell = [self.cells objectAtIndex:i];
        if (cell.type == ChartType_Line) {
            CGContextSetStrokeColorWithColor(context, cell.color.CGColor);
            CGContextMoveToPoint(context, leftPadding, topOffset + 4);
            CGContextAddLineToPoint(context, leftPadding + markWidth, topOffset + 4);
            CGContextStrokePath(context);
        }
        else if (cell.type == ChartType_Bar) {
            CGContextSetFillColorWithColor(context, cell.color.CGColor);
            CGContextFillRect(context, CGRectMake(leftPadding, topOffset, markWidth, markBarHeight));
        }
        [[UIColor grayColor] set];
        leftPadding += markWidth + intervalXLittle;
        [cell.name drawAtPoint:CGPointMake(leftPadding, topOffset - 4) withFont:drawFont];
        leftPadding += intervalXLarge + [cell.name sizeWithFont:drawFont].width;
    }
}

- (CGFloat)yWithChartValue:(CGFloat)value {
    CGFloat height = (value - self.leftMinValue) * (self.bounds.size.height - charOffestBottom - kChartOffsetTop) / (self.leftMaxValue - self.leftMinValue);
    CGFloat ret = self.bounds.size.height - charOffestBottom - height;
    return ret;
}



@end
