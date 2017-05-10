//
//  MyPlotView.m
//  MyChartPlotTest
//
//  Created by zwc on 14-6-23.
//  Copyright (c) 2014年 MYSTERIOUS. All rights reserved.
//

#import "MyPlotView.h"

#define kCurrentFontName @"CourierNewPSMT"

@interface CursorLayer : CALayer {
    
}

@end

@implementation CursorLayer

+ (CursorLayer *)layer{
    CursorLayer *retLayer = [[[self class] superclass] layer];
    retLayer.delegate = retLayer;
    return retLayer;
}

@end

//@interface MyPlotLayerDelegate : NSObject
//
//@end
//
//@implementation MyPlotLayerDelegate
//
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//    
//}
//
//@end

@implementation MyPlotView {
    NSInteger needDrawLineCount;
    CGFloat oneLineXPositon;
    CGFloat anotherLineXPosition;
    CAGradientLayer *dataLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:gesture];
        
        //self.multipleTouchEnabled = YES;
        
        dataLayer = [CAShapeLayer layer];
        dataLayer.frame = self.bounds;
        dataLayer.backgroundColor = kFreshBlueColor.CGColor;
        
        //layer.mask = maskLayer;
        
       // [self.layer addSublayer:dataLayer];
    }
    return self;
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    if ([panGesture numberOfTouches] == 1 || [panGesture numberOfTouches] == 2) {
        oneLineXPositon = [panGesture locationOfTouch:0 inView:self].x;
//        if ([self isNeedDrawLineWithXPositon:oneXPosition]) {
//            int currentLineIndex = [self indexWithXPosition:oneXPosition];
//            oneValuePoint = [self positionWith:[values objectAtIndex:currentLineIndex] index:currentLineIndex];
//        }
        if ([panGesture numberOfTouches] == 2) {
            if (needDrawLineCount == 1) {
                needDrawLineCount = 2;
            }
            anotherLineXPosition = [panGesture locationOfTouch:1 inView:self].x;
//            if ([self isNeedDrawLineWithXPositon:anotherXPosition]) {
//                int currentLineIndex = [self indexWithXPosition:anotherXPosition];
//                anotherValuePoint = [self positionWith:[values objectAtIndex:currentLineIndex] index:currentLineIndex];
//            }
        }
        [self setNeedsDisplay];
    }
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        needDrawLineCount = 0;
        [self setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *toucheArr = [[event allTouches] allObjects];
    if (needDrawLineCount == 0) {
        if ([toucheArr count] == 1) {
            needDrawLineCount = 1;
            UITouch *touch = [toucheArr objectAtIndex:0];
            oneLineXPositon = [touch locationInView:self].x;
            [self setNeedsDisplay];
        }
        else if ([toucheArr count] == 2) {
            needDrawLineCount = 2;
            UITouch *touch1 = [toucheArr objectAtIndex:0];
            oneLineXPositon = [touch1 locationInView:self].x;
            UITouch *touch2 = [toucheArr objectAtIndex:1];
            anotherLineXPosition = [touch2 locationInView:self].x;
            [self setNeedsDisplay];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *toucheArr = [[event allTouches] allObjects];
    if (needDrawLineCount == 1 && [toucheArr count] == 2) {
        needDrawLineCount = 2;
        UITouch *touch1 = [toucheArr objectAtIndex:0];
        oneLineXPositon = [touch1 locationInView:self].x;
        UITouch *touch2 = [toucheArr objectAtIndex:1];
        anotherLineXPosition = [touch2 locationInView:self].x;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    needDrawLineCount = 0;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, &CGAffineTransformIdentity, self.paddingLeft + self.plotpaddingLeft, rect.size.height - self.paddingBottom);
//    for (NSInteger i = 0; i < [self.values count]; i++) {
//        CGPoint valuePoint = [self pointWithValueIndex:i];
//        CGPathAddLineToPoint(path, &CGAffineTransformIdentity, valuePoint.x, valuePoint.y);
//    }
//    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, rect.size.width -self.paddingRight - self.plotPaddingRight, rect.size.height - self.paddingBottom);
//    CGPathCloseSubpath(path);
//    maskLayer.path = path;
//    dataLayer.mask = maskLayer;
//    CGPathRelease(path);
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ref, kFreshBlueColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, self.paddingLeft + self.plotpaddingLeft, rect.size.height - self.paddingBottom);
    for (NSInteger i = 0; i < [self.values count]; i++) {
        CGPoint valuePoint = [self pointWithValueIndex:i];
        CGPathAddLineToPoint(path, &CGAffineTransformIdentity, valuePoint.x, valuePoint.y);
    }
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, rect.size.width -self.paddingRight - self.plotPaddingRight, rect.size.height - self.paddingBottom);
    CGPathCloseSubpath(path);
    
    
    [self drawGradientWithContext:ref Path:path];
    //CGContextAddPath(ref, path);
    CGPathRelease(path);
   // CGContextFillPath(ref);
    
    CGContextSetLineWidth(ref, 0.5);
    
    CGContextSetStrokeColorWithColor(ref, [UIColor lightGrayColor].CGColor);
    CGContextMoveToPoint(ref, self.paddingLeft, self.paddingTop);
    CGContextAddLineToPoint(ref, self.paddingLeft, rect.size.height - self.paddingBottom);
    CGContextAddLineToPoint(ref, rect.size.width - self.paddingRight, rect.size.height - self.paddingBottom);
    CGContextStrokePath(ref);
    
    CGContextMoveToPoint(ref, self.paddingLeft, self.paddingTop);
    CGContextAddLineToPoint(ref,rect.size.width - self.paddingRight, self.paddingTop);
    CGContextStrokePath(ref);
    
     CGContextMoveToPoint(ref, self.paddingLeft, rect.size.height - self.paddingBottom - (rect.size.height - self.paddingBottom - self.paddingTop) / 2);
    CGContextAddLineToPoint(ref, rect.size.width - self.paddingRight, rect.size.height - self.paddingBottom - (rect.size.height - self.paddingBottom - self.paddingTop) / 2);
    
    CGContextStrokePath(ref);
    
    CGContextSetLineWidth(ref, 1);
    
   // CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    [[UIColor blackColor] set];
    
    CGFloat drawWidth = 80;
    CGFloat everyWidth = (rect.size.width - self.paddingRight - self.paddingLeft - self.plotpaddingLeft - self.plotPaddingRight) / ([self.showHorizonalTitles count] - 1);
    for (NSInteger i = 0; i < [self.showHorizonalTitles count]; i++) {
        [[self.showHorizonalTitles objectAtIndex:i] drawInRect:CGRectMake(self.plotpaddingLeft + self.paddingLeft + i * everyWidth - drawWidth / 2, rect.size.height - self.paddingBottom + 8, drawWidth, 20) withFont:[UIFont systemFontOfSize:13]
                                             lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    }
    
    [[self stringWithValue:self.minVerticalValue] drawInRect:CGRectMake(0, rect.size.height - self.paddingBottom - 6, self.paddingLeft - 4, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    [[self stringWithValue:(self.minVerticalValue + self.maxVerticalValue) / 2] drawInRect:CGRectMake(0, rect.size.height - self.paddingBottom - (rect.size.height - self.paddingTop - self.paddingBottom) / 2 - 6, self.paddingLeft - 4, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    [[self stringWithValue:self.maxVerticalValue] drawInRect:CGRectMake(0, self.paddingTop - 6, self.paddingLeft - 4, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    
//    CGFloat drawValueEveryWith = (rect.size.width - self.paddingLeft - self.plotpaddingLeft - self.plotPaddingRight - self.paddingRight) / ([self.values count] - 1);
    CGContextSetStrokeColorWithColor(ref, [UIColor blueColor].CGColor);
    CGPoint drawPoint = [self pointWithValueIndex:0];
    CGContextMoveToPoint(ref, drawPoint.x, drawPoint.y);
    for (NSInteger i = 1; i < [self.values count]; i++) {
        drawPoint = [self pointWithValueIndex:i];
        CGContextAddLineToPoint(ref, drawPoint.x, drawPoint.y);
    }
    CGContextStrokePath(ref);
    
    if (needDrawLineCount == 1) {
        CGContextSetStrokeColorWithColor(ref, [UIColor blueColor].CGColor);
        CGContextMoveToPoint(ref, oneLineXPositon, self.paddingTop);
        CGContextAddLineToPoint(ref, oneLineXPositon, rect.size.height - self.paddingBottom);
        CGContextStrokePath(ref);
        
        CGContextSetFillColorWithColor(ref, [UIColor blueColor].CGColor);
        NSInteger oneIndex = [self valueIndexWithXPositon:oneLineXPositon];
        CGPoint onePoint = [self pointWithValueIndex:oneIndex];
        CGContextFillEllipseInRect(ref, CGRectMake(onePoint.x - 5, onePoint.y - 5, 10, 10));
        
        [[self stringWithValue:[[self.values objectAtIndex:oneIndex] floatValue]] drawInRect:CGRectMake(oneLineXPositon - 80, self.paddingTop - 40, 160, 25) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        [[self.horizonalTitles objectAtIndex:oneIndex] drawInRect:CGRectMake(oneLineXPositon - 80, self.paddingTop - 70, 160, 25) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    }
    else if (needDrawLineCount == 2) {
        if (oneLineXPositon > anotherLineXPosition) {
            CGFloat tempPosition = oneLineXPositon;
            oneLineXPositon = anotherLineXPosition;
            anotherLineXPosition = tempPosition;
        }
        
        NSInteger oneIndex = [self valueIndexWithXPositon:oneLineXPositon];
        NSInteger anotherIndex = [self valueIndexWithXPositon:anotherLineXPosition];
        
        CGFloat oneValue = [[self.values objectAtIndex:oneIndex] floatValue];
        CGFloat anotherValue = [[self.values objectAtIndex:anotherIndex] floatValue];
        
        UIColor *strokeColor = nil;
        
        if (oneValue < anotherValue) {
            strokeColor = kFreshGreenColor;
        }
        else if (oneValue == anotherValue) {
            strokeColor = kFreshYellowColor;
        }
        else {
            strokeColor = [UIColor redColor];
        }
        
        CGContextSetLineWidth(ref, 2);
        CGContextSetStrokeColorWithColor(ref, strokeColor.CGColor);
        CGPathRef path = [self pathWithOneXpositon:oneLineXPositon anotherPosition:anotherLineXPosition];
        CGContextAddPath(ref, path);
        CGPathRelease(path);
        CGContextStrokePath(ref);
        
        CGContextSetLineWidth(ref, 1);
        
        strokeColor = [UIColor blueColor];
        
        CGContextSetStrokeColorWithColor(ref, strokeColor.CGColor);
        CGContextMoveToPoint(ref, oneLineXPositon, self.paddingTop);
        CGContextAddLineToPoint(ref, oneLineXPositon, rect.size.height - self.paddingBottom);
        CGContextStrokePath(ref);
        [strokeColor set];
        
        [[self stringWithValue:[[self.values objectAtIndex:oneIndex] floatValue]] drawAtPoint:CGPointMake(self.paddingLeft + self.plotpaddingLeft + 50, self.paddingTop - 40) withFont:[UIFont systemFontOfSize:25]];
        
        [[self.horizonalTitles objectAtIndex:oneIndex] drawAtPoint:CGPointMake(self.paddingLeft + self.plotpaddingLeft + 50, self.paddingTop - 70) withFont:[UIFont systemFontOfSize:25]];
        
//        [[NSString stringWithFormat:@"%.0f", [[self.values objectAtIndex:oneIndex] floatValue]] drawInRect:CGRectMake(self.paddingLeft + self.plotpaddingLeft + 300, self.paddingTop - 40, 160, 25) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        CGContextSetFillColorWithColor(ref, strokeColor.CGColor);
        CGPoint onePoint = [self pointWithValueIndex:oneIndex];
        CGContextFillEllipseInRect(ref, CGRectMake(onePoint.x - 5, onePoint.y - 5, 10, 10));
        
        NSString *header = @"";
        
        if (oneValue < anotherValue) {
            strokeColor = kFreshGreenColor;
            header = @"+";
        }
        else if (oneValue == anotherValue) {
            strokeColor = kFreshYellowColor;
        }
        else {
            strokeColor = [UIColor redColor];
            header = @"-";
        }
        CGContextSetStrokeColorWithColor(ref, strokeColor.CGColor);
        
        CGContextMoveToPoint(ref, anotherLineXPosition, self.paddingTop);
        CGContextAddLineToPoint(ref, anotherLineXPosition, rect.size.height - self.paddingBottom);
        CGContextStrokePath(ref);
        
        [strokeColor set];
        [[self stringWithValue:[[self.values objectAtIndex:anotherIndex] floatValue]] drawInRect:CGRectMake(0, self.paddingTop - 40, rect.size.width - self.paddingRight - self.plotPaddingRight - 50, 25) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
        
        [[self.horizonalTitles objectAtIndex:anotherIndex] drawInRect:CGRectMake(0, self.paddingTop - 70, rect.size.width - self.paddingRight - self.plotPaddingRight - 50, 25) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
        
        CGPoint anotherPoint = [self pointWithValueIndex:anotherIndex];
        CGContextSetFillColorWithColor(ref, strokeColor.CGColor);
        CGContextFillEllipseInRect(ref, CGRectMake(anotherPoint.x - 5, anotherPoint.y - 5, 10, 10));
        
        NSString *rateStr = [NSString stringWithFormat:@"%@%.2f%%", header, fabsf(anotherValue - oneValue) / oneValue * 100];
        
        if (oneValue == 0) {
            rateStr = @"0.00%";
        }
        
        [rateStr drawInRect:CGRectMake(self.paddingLeft + self.plotpaddingLeft, self.paddingTop - 80, rect.size.width - self.paddingLeft - self.plotpaddingLeft - self.paddingRight - self.plotPaddingRight, 30) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        [[self stringWithValue:anotherValue - oneValue] drawInRect:CGRectMake([self allpaddingLeft], self.paddingTop - 50, rect.size.width - [self allpaddingLeft] - [self allPaddingRight], 30) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
    }
}

- (void)drawGradientWithContext:(CGContextRef)context Path:(CGPathRef)path {
    [self gradientColorWithColor];
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef beginColor = CGColorCreate(colorSpaceRef, CGColorGetComponents(self.fillColor.CGColor));
    CGColorRef endColor = CGColorCreate(colorSpaceRef, CGColorGetComponents(self.gradientColor.CGColor));
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
    
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        0.0f,       // 对应起点颜色位置
        1.0f        // 对应终点颜色位置
    });
    
    // 释放颜色数组
    CFRelease(colorArray);
    
    // 释放起点和终点颜色
    CGColorRelease(beginColor);
    CGColorRelease(endColor);
    CGColorSpaceRelease(colorSpaceRef);
    
    // CGContextFillRect(ref, CGRectMake(0, 0, 300, 200));
    CGContextDrawLinearGradient(context, gradientRef, CGPointMake([self allpaddingLeft], self.paddingTop), CGPointMake(self.paddingLeft, self.bounds.size.height - self.paddingBottom), 0);
    
    // 释放渐变对象
    CGGradientRelease(gradientRef);
    CGContextRestoreGState(context);
}

- (CGFloat )allpaddingLeft {
    return self.paddingLeft + self.plotpaddingLeft;
}

- (CGFloat )allPaddingRight {
    return self.paddingRight + self.plotPaddingRight;
}

- (CGFloat)heightWithValue:(CGFloat)value {
    
    if (self.maxVerticalValue == 0) {
        return self.bounds.size.height - self.paddingBottom;
    }
    
   return (self.maxVerticalValue - value) / (self.maxVerticalValue - self.minVerticalValue) * (self.bounds.size.height - self.paddingBottom - self.paddingTop) + self.paddingTop;
}

- (NSInteger)valueIndexWithXPositon:(CGFloat)xPosition {
    CGFloat valueEveryWidth = (self.bounds.size.width - self.paddingLeft - self.paddingRight - self.plotpaddingLeft - self.plotPaddingRight) / ([self.values count] - 1);
    
    NSInteger ret = (xPosition - self.paddingLeft - self.plotpaddingLeft + valueEveryWidth / 2) / valueEveryWidth;
    
    if (ret < 0) {
        ret = 0;
    }
    else if (ret >= [self.values count]) {
        ret = [self.values count] - 1;
    }
    
    return ret;
}

- (CGPoint)pointWithValueIndex:(NSInteger )index {
    CGFloat valueEveryWidth = (self.bounds.size.width - self.paddingLeft - self.paddingRight - self.plotpaddingLeft - self.plotPaddingRight) / ([self.values count] - 1);
    return CGPointMake(self.paddingLeft + self.plotpaddingLeft + valueEveryWidth * index, [self heightWithValue:[[self.values objectAtIndex:index] floatValue]]);
}

- (CGPathRef)pathWithOneXpositon:(CGFloat)oneXpositon anotherPosition:(CGFloat)anotherPosition {
    
    if (oneXpositon > anotherPosition) {
        CGFloat tempPosition = oneXpositon;
        oneXpositon = anotherPosition;
        anotherPosition = tempPosition;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    if (oneXpositon < self.paddingLeft + self.plotpaddingLeft) {
        oneXpositon = self.paddingLeft + self.plotPaddingRight;
    }
    else if (oneXpositon > self.bounds.size.width - self.paddingRight - self.plotPaddingRight - 1) {
        oneXpositon = self.bounds.size.width - self.paddingRight - self.plotPaddingRight - 1;
    }
    
    if (anotherPosition < self.paddingLeft + self.plotpaddingLeft) {
        anotherPosition = self.paddingLeft + self.plotPaddingRight;
    }
    else if (anotherPosition > self.bounds.size.width - self.paddingRight - self.plotPaddingRight - 1) {
        anotherPosition = self.bounds.size.width - self.paddingRight - self.plotPaddingRight - 1;
    }
    
    CGPoint oneNode = [self nodeWithXPosition:oneXpositon];
    CGPoint anotherNode = [self nodeWithXPosition:anotherPosition];
    
    NSInteger minIndex = 0;
    NSInteger maxIndex = 0;
    
    CGFloat valueEveryWidth = (self.bounds.size.width - self.paddingLeft - self.paddingRight - self.plotpaddingLeft - self.plotPaddingRight) / ([self.values count] - 1);
    
    minIndex = (oneXpositon - self.paddingLeft - self.plotpaddingLeft) / valueEveryWidth + 1;
    maxIndex = (anotherPosition - self.paddingLeft - self.plotpaddingLeft) / valueEveryWidth;
    
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, oneNode.x,oneNode.y);
    
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        CGPoint nodePoint = [self pointWithValueIndex:i];
        CGPathAddLineToPoint(path, &CGAffineTransformIdentity, nodePoint.x, nodePoint.y);
    }
    
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, anotherNode.x, anotherNode.y);
    
    return path;
}

- (CGPoint)nodeWithXPosition:(CGFloat)xPosition {
    
    CGPoint ret = CGPointZero;
    
    CGFloat valueEveryWidth = (self.bounds.size.width - self.paddingLeft - self.paddingRight - self.plotpaddingLeft - self.plotPaddingRight) / ([self.values count] - 1);
    NSInteger leftIndex = (xPosition - self.paddingLeft - self.plotpaddingLeft) / valueEveryWidth;
    NSInteger rightIndex = leftIndex + 1;
    
    CGFloat leftHeight = [self heightWithValue:[[self.values objectAtIndex:leftIndex] floatValue]];
    CGFloat rightHeight = [self heightWithValue:[[self.values objectAtIndex:rightIndex] floatValue]];
    
    if (leftHeight > rightHeight) {
        ret = CGPointMake(xPosition, leftHeight - (xPosition - self.plotpaddingLeft - self.paddingLeft - leftIndex * valueEveryWidth) / valueEveryWidth * (leftHeight - rightHeight));
    }
    else {
        ret = CGPointMake(xPosition, rightHeight - (self.plotpaddingLeft + self.paddingLeft + rightIndex * valueEveryWidth - xPosition) / valueEveryWidth * (rightHeight - leftHeight));
    }
    
    return ret;
}

- (NSString *)stringWithValue:(float)value {
    NSString *unitStr = self.unitStr;
    if (unitStr == nil) {
        unitStr = @"";
    }
    NSString *ret = nil;
    if (self.needChangeBigUnit) {
        ret = [NSString stringWithFormat:@"%.2f%@", value / 1024.0 / 1024, unitStr];
    }
    else {
        ret = [NSString stringWithFormat:@"%.0f%@", value, unitStr];
    }
    
    if (self.needUseFloatValue) {
        ret = [NSString stringWithFormat:@"%.2f%%", value * 100];
    }
    
    return ret;
}

- (UIColor *)gradientColorWithColor {
    NSUInteger num = CGColorGetNumberOfComponents(self.fillColor.CGColor);
    const CGFloat *colorComponents = CGColorGetComponents(self.fillColor.CGColor);
    return nil;
}

@end
