//
//  HXCorePlotLayerDelegate.m
//  tysx
//
//  Created by zwc on 14-7-22.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXCorePlotLayerDelegate.h"
#import "HXCorePlot.h"

typedef enum {
    TextPosition_None,
    TextPosition_Left,
    TextPosition_Right,
    TextPosition_LinePosition
}TextPosition;

@implementation HXCorePlotLayerDelegate
@synthesize paddingBottom;
@synthesize paddingLeft;
@synthesize paddingRight;
@synthesize paddingTop;
@synthesize insetLeft;
@synthesize insetRight;
@synthesize maxValue;
@synthesize minValue;
@synthesize rightMinValue;
@synthesize rightMaxValue;

- (id)init {
    if (self = [super init]) {
        self.paddingLeft = self.paddingTop = self.paddingRight = self.paddingBottom =  30;
    }
    return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if ([layer isKindOfClass:[HXCorePlotYAxisLayer class]]) {
        HXCorePlotYAxisLayer *axisLayer = (HXCorePlotYAxisLayer *)layer;
        
        if (axisLayer.needLegend) {
            CGFloat legendInterval = 20;
            CGFloat interval = 8;
            CGFloat legendWidth = 10;
            CGFloat legendHeight = 8;
            UIFont *font = [UIFont systemFontOfSize:15];
            CGFloat offsetTop = axisLayer.bounds.size.height - 50;
            CGFloat sumWidth = 0;
            NSMutableArray *titleWidths = [NSMutableArray array];
            for (int i = 0; i < [axisLayer.legendTitles count]; i++) {
                CGSize titleSize = [axisLayer.legendTitles[i] sizeWithAttributes:@{NSFontAttributeName : font}];
                [titleWidths addObject:[NSNumber numberWithFloat:titleSize.width]];
                sumWidth += titleSize.width + legendWidth + interval;
            }
            sumWidth += legendInterval * ([axisLayer.legendTitles count] - 1);
            CGFloat drawOffsetLeft = (axisLayer.bounds.size.width - paddingLeft - paddingRight - sumWidth) / 2 + paddingLeft;
            UIGraphicsPushContext(ctx);
            for (int i = 0; i < [axisLayer.legendTitles count]; i++) {
                CGContextSetFillColorWithColor(ctx, ((UIColor *)axisLayer.legendColor[i]).CGColor);
                CGContextFillRect(ctx, CGRectMake(drawOffsetLeft, offsetTop + (font.pointSize - legendHeight) / 2, legendWidth, legendHeight));
                drawOffsetLeft += interval + legendWidth;
                [axisLayer.legendTitles[i] drawAtPoint:CGPointMake(drawOffsetLeft, offsetTop) withAttributes:@{NSFontAttributeName : font,
                                                                                                               NSForegroundColorAttributeName:[UIColor grayColor]}];
                drawOffsetLeft += legendInterval + [titleWidths[i] floatValue];
                
                
            }
            UIGraphicsPopContext();
        }
        
        if (axisLayer.dataSource != nil) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentRight;
            
            CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
            CGContextMoveToPoint(ctx, paddingLeft, paddingTop);
            CGContextAddLineToPoint(ctx, paddingLeft, axisLayer.bounds.size.height - paddingBottom);
            CGContextStrokePath(ctx);
            
            NSInteger yAxisCount = 0;
            if ([axisLayer.dataSource respondsToSelector:@selector(numberOfTitleInYAxis:)]) {
                yAxisCount = [axisLayer.dataSource numberOfTitleInYAxis:axisLayer];
            }
            
            CGFloat everyHeight = 0;
            
            if (yAxisCount == 1) {
                everyHeight = (axisLayer.bounds.size.height - paddingBottom - paddingTop);
            }
            else {
                everyHeight = (axisLayer.bounds.size.height - paddingBottom - paddingTop) / (yAxisCount - 1);
            }
            NSString *yAxisTitle = nil;
            UIGraphicsPushContext(ctx);
            
            CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
            CGContextMoveToPoint(ctx, paddingLeft, axisLayer.bounds.size.height - paddingBottom);
            CGContextAddLineToPoint(ctx, axisLayer.bounds.size.width - paddingRight, axisLayer.bounds.size.height - paddingBottom);
            CGContextStrokePath(ctx);
            for (int i = 0; i < yAxisCount; i++) {
                //                CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
//                CGContextMoveToPoint(ctx, paddingLeft, paddingTop + everyHeight * i);
//                CGContextAddLineToPoint(ctx, axisLayer.bounds.size.width - paddingRight, paddingTop + everyHeight * i);
//                CGContextStrokePath(ctx);
                if ([axisLayer.dataSource respondsToSelector:@selector(yAxis:titleAtIndex:isUseRightYAxis:)]) {
                    yAxisTitle = [axisLayer.dataSource yAxis:axisLayer titleAtIndex:i isUseRightYAxis:NO];
                    [yAxisTitle drawInRect:CGRectMake(0, paddingTop + everyHeight * i - 6, paddingLeft - 4, 15) withAttributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
                    
                    if (axisLayer.needRightYAxis) {
                        yAxisTitle = [axisLayer.dataSource yAxis:axisLayer titleAtIndex:i isUseRightYAxis:YES];
                        [yAxisTitle drawAtPoint:CGPointMake(axisLayer.bounds.size.width - paddingRight + 4, paddingTop + everyHeight * i - 6) withAttributes:nil];
                        CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
                        CGContextMoveToPoint(ctx, axisLayer.bounds.size.width - paddingRight, paddingTop);
                        CGContextAddLineToPoint(ctx, axisLayer.bounds.size.width - paddingRight, axisLayer.bounds.size.height - paddingBottom);
                        CGContextStrokePath(ctx);
                    }
                }
            }
            UIGraphicsPopContext();
            
            if (axisLayer.numberOfSubline > 0) {
                CGFloat everyOffset = (axisLayer.bounds.size.height - paddingTop - paddingBottom) / axisLayer.numberOfSubline;
                CGFloat yLocation = axisLayer.bounds.size.height - paddingBottom;
                for (int i = 0; i < axisLayer.numberOfSubline; i++) {
                    yLocation -= everyOffset;
                    CGContextSetLineWidth(ctx, axisLayer.sublineWidth);
                    CGContextSetStrokeColorWithColor(ctx, axisLayer.sublineColor.CGColor);
                    CGContextMoveToPoint(ctx, paddingLeft, yLocation);
                    CGContextAddLineToPoint(ctx, axisLayer.bounds.size.width - paddingRight, yLocation);
                }
                CGContextStrokePath(ctx);
            }
        }
    }
    else if ([layer isKindOfClass:[HXCoreplotXAxisLayer class]]) {
        HXCoreplotXAxisLayer *xAixs = (HXCoreplotXAxisLayer *)layer;
        NSInteger xAxisTitlesNum = 0;
        if ([xAixs.dataSource respondsToSelector:@selector(numberOfTitleInXAxis:)]) {
            xAxisTitlesNum = [xAixs.dataSource numberOfTitleInXAxis:xAixs];
            NSString *xAxisTitle = nil;
            CGFloat drawWidth = 100;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            CGFloat everyTitleOffset = (xAixs.bounds.size.width - paddingLeft - insetRight - insetLeft - paddingRight) / (xAxisTitlesNum - 1);
            
            UIGraphicsPushContext(ctx);
            for (int i = 0; i < xAxisTitlesNum; i++) {
                if ([xAixs.dataSource respondsToSelector:@selector(xAxis:titleAtIndex:)]) {
                    xAxisTitle = [xAixs.dataSource xAxis:xAixs titleAtIndex:i];
                    if (xAxisTitle.length != 0) {
                        [xAxisTitle drawInRect:CGRectMake(paddingLeft + insetLeft + everyTitleOffset * i - drawWidth / 2, xAixs.bounds.size.height - paddingBottom + 7, drawWidth, 15)withAttributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
                    }
                }
            }
            UIGraphicsPopContext();
            
            if (xAixs.numberOfSubline > 0) {
                CGFloat everyOffset = (xAixs.bounds.size.width - paddingLeft - insetRight - insetLeft - paddingRight) / (xAixs.numberOfSubline -  1);
                CGFloat xLocation = paddingLeft + insetLeft;
                for (int i = 0; i < xAixs.numberOfSubline; i++) {
                    CGContextSetLineWidth(ctx, xAixs.sublineWidth);
                    CGContextSetStrokeColorWithColor(ctx, xAixs.sublineColor.CGColor);
                    CGContextMoveToPoint(ctx, xLocation, paddingTop);
                    CGContextAddLineToPoint(ctx, xLocation, xAixs.bounds.size.height - paddingBottom);
                    xLocation += everyOffset;
                }
                CGContextStrokePath(ctx);
            }
        }
    }
    
    
    else if ([layer isKindOfClass:[HXLinePlot class]]){
        HXLinePlot *linePlot = (HXLinePlot *)layer;
        if (linePlot.dataSource != nil) {
            CGContextSetStrokeColorWithColor(ctx, linePlot.lineColor.CGColor);
            CGContextSetLineWidth(ctx, linePlot.lineWidth);
            NSInteger numberOfValues = 0;
            if ([linePlot.dataSource respondsToSelector:@selector(numberOfPlot:)]) {
                numberOfValues = [linePlot.dataSource numberOfPlot:linePlot];
            }
            CGFloat everyWidth = (linePlot.bounds.size.width - paddingLeft - paddingRight - insetLeft - insetRight) / (numberOfValues - 1);
            NSNumber *value = nil;
            CGMutablePathRef path = CGPathCreateMutable();
            for (int i = 0; i < numberOfValues; i++) {
                if (linePlot.showLimitNum != 0 && linePlot.showLimitNum == i) {
                    break;
                }
                if ([linePlot.dataSource respondsToSelector:@selector(plot:index:)]) {
                    value = [linePlot.dataSource plot:linePlot index:i];
                }
                CGFloat currentHeight = [self heightWithValue:[value floatValue] contentHeight:linePlot.bounds.size.height - paddingBottom - paddingTop isUseRightYAxis:linePlot.isUseRightAxisY];
                if (i == 0) {
                    CGPathMoveToPoint(path, NULL, insetLeft + paddingLeft + everyWidth * i, linePlot.bounds.size.height - paddingBottom - currentHeight);
                    CGContextMoveToPoint(ctx, insetLeft + paddingLeft + everyWidth * i, linePlot.bounds.size.height - paddingBottom - currentHeight);
                }
                else {
                    CGPathAddLineToPoint(path, NULL, insetLeft + paddingLeft + everyWidth * i, linePlot.bounds.size.height - paddingBottom - currentHeight);
                    CGContextAddLineToPoint(ctx, insetLeft + paddingLeft + everyWidth * i, linePlot.bounds.size.height - paddingBottom - currentHeight);
                }
            }
            CGContextStrokePath(ctx);
            
            if (linePlot.needFill) {
                CGPathAddLineToPoint(path, NULL, linePlot.bounds.size.width - insetRight - paddingRight, linePlot.bounds.size.height - paddingBottom);
                CGPathAddLineToPoint(path, NULL, paddingLeft + insetLeft, linePlot.bounds.size.height - paddingBottom);
                CGPathCloseSubpath(path);
                CGContextSaveGState(ctx);
                CGContextAddPath(ctx, path);
                CGContextClip(ctx);
                
                CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
                CGColorRef beginColor = CGColorCreate(colorSpaceRef, CGColorGetComponents(linePlot.topGradientColor.CGColor));
                CGColorRef endColor = CGColorCreate(colorSpaceRef, CGColorGetComponents(linePlot.bottomGradientColor.CGColor));
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
                CGContextDrawLinearGradient(ctx, gradientRef, CGPointMake(insetLeft + paddingLeft, paddingTop), CGPointMake(paddingLeft + insetLeft, linePlot.bounds.size.height - paddingBottom), 0);
                
                // 释放渐变对象
                CGGradientRelease(gradientRef);
                CGContextRestoreGState(ctx);
            }
            CGPathRelease(path);
        }
    }
    else if ([layer isKindOfClass:[HXPlotCursor class]]) {
        HXPlotCursor *cursor = (HXPlotCursor *)layer;
        [self drawCurosr:cursor context:ctx];
    }
    else if ([layer isKindOfClass:[HXHeapBarPlot class]]) {
        HXHeapBarPlot *heapBarPlot = (HXHeapBarPlot *)layer;
        if (heapBarPlot.dataSource != nil) {
            NSInteger numberOfHeap = 0;
            NSInteger numberOfXValue = 0;
            if ([heapBarPlot.dataSource respondsToSelector:@selector(numberOfHeapBarInHeapBarPlot:)]) {
                numberOfHeap = [heapBarPlot.dataSource numberOfHeapBarInHeapBarPlot:heapBarPlot];
            }
            
            if ([heapBarPlot.dataSource respondsToSelector:@selector(numberOfXValuesInHeapBarPlot:)]) {
                numberOfXValue = [heapBarPlot.dataSource numberOfXValuesInHeapBarPlot:heapBarPlot];
            }
            NSNumber *value = nil;
            CGFloat everyWidth = (heapBarPlot.bounds.size.width - paddingLeft - insetLeft - paddingRight - insetRight) / (numberOfXValue - 1);
            CGFloat barWidth = (heapBarPlot.endPosition - heapBarPlot.beginPosition) * everyWidth;
            if (numberOfXValue != 0 && numberOfHeap !=0) {
                for (int i = 0; i < numberOfXValue; i++) {
                    CGFloat currentHeight = heapBarPlot.bounds.size.height - paddingBottom;
                    CGFloat offsetX = paddingLeft + insetLeft + everyWidth * i - everyWidth / 2 + heapBarPlot.beginPosition * everyWidth;
                    CGFloat sumValue = 0;
                    for (int j = 0; j < numberOfHeap; j++) {
                        if ([heapBarPlot.dataSource respondsToSelector:@selector(heapBarPlot:valueOfXIndex:heapIndex:)]) {
                            value = [heapBarPlot.dataSource heapBarPlot:heapBarPlot  valueOfXIndex:i heapIndex:j];
                            sumValue += [value floatValue];
                            UIColor *fillColor = nil;
                            if ([heapBarPlot.dataSource respondsToSelector:@selector(heapBarPlot: colorOfHeapIndex:)]) {
                                fillColor = [heapBarPlot.dataSource heapBarPlot:heapBarPlot colorOfHeapIndex:j];
                            }
                            CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
                            CGFloat offsetY = currentHeight;
                            CGFloat barHeight = [self heightWithValue:[value floatValue] contentHeight:heapBarPlot.bounds.size.height - paddingBottom - paddingTop isUseRightYAxis:heapBarPlot.isUseRightAxisY];
                            CGContextFillRect(ctx, CGRectMake(offsetX, offsetY, barWidth, barHeight * -1));
                            
                            currentHeight -= barHeight;
                        }
                    }
                    if (heapBarPlot.needShowValue) {
                        UIGraphicsPushContext(ctx);
                        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
                        [attr setValue:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
                        NSMutableParagraphStyle *para = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                        para.alignment = NSTextAlignmentCenter;
                        [attr setValue:para forKey:NSParagraphStyleAttributeName];
                        [[NSString stringWithFormat:@"%.1f", sumValue] drawInRect:CGRectMake(offsetX, currentHeight - 20, barWidth, 20) withAttributes:attr];
                        UIGraphicsPopContext();
                    }
                }
            }
        }
    }
}

- (void)drawCurosr:(HXPlotCursor *)cursor
           context:(CGContextRef)ctx {
    CGFloat leftPosition = 0;
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    NSMutableParagraphStyle *paragrphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragrphStyle.alignment = NSTextAlignmentCenter;
    UIColor *baseColor = [UIColor blueColor];
    [attributes setValue:paragrphStyle forKey:NSParagraphStyleAttributeName];
    [attributes setValue:baseColor forKey:NSForegroundColorAttributeName];
    [attributes setValue:cursor.textFont forKey:NSFontAttributeName];
    
    if (cursor.numberOfCursor == 1 || (cursor.cursorType == CursorType_Double && cursor.numberOfCursor == 2)) {
        
        leftPosition = cursor.onePosition;
        
        if (cursor.cursorType == CursorType_Double && cursor.numberOfCursor == 2 && leftPosition > cursor.anotherPositon) {
            leftPosition = cursor.anotherPositon;
        }
        
        if (leftPosition < cursor.paddingLeft) {
            leftPosition = cursor.paddingLeft;
        }
        else if (leftPosition > cursor.bounds.size.width - cursor.paddingRight) {
            leftPosition = cursor.bounds.size.width - cursor.paddingRight;
        }
        
        CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
        CGContextMoveToPoint(ctx, leftPosition, paddingTop);
        CGContextAddLineToPoint(ctx, leftPosition, cursor.bounds.size.height - paddingBottom);
        CGContextStrokePath(ctx);
        
        NSInteger numberOfDegree = 0;
        if ([cursor.dataSource respondsToSelector:@selector(numberOfDegreeInCursor:)]) {
            numberOfDegree = [cursor.dataSource numberOfDegreeInCursor:cursor];
        }
        
        CGFloat everyDegreeWidth = (cursor.bounds.size.width - cursor.paddingLeft - cursor.paddingRight) / (numberOfDegree - 1);
        NSInteger degreeIndex = (leftPosition + everyDegreeWidth / 2 - cursor.paddingLeft) / everyDegreeWidth;
        
        NSString *currentDegreeName = nil;
        if ([cursor.dataSource respondsToSelector:@selector(plotCursor: degreeNameOfIndex:)]) {
            currentDegreeName = [cursor.dataSource plotCursor:cursor degreeNameOfIndex:degreeIndex];
        }
        CGFloat contentWidth = 200;
        CGFloat drawOffsetTop = 0;
        CGFloat intervalY = 10;
        
        UIGraphicsPushContext(ctx);
        
        CGFloat drawCenterPosition = 0;
        if (cursor.cursorType == CursorType_Double && cursor.numberOfCursor == 2) {
            drawCenterPosition = paddingLeft + 100;
            CGFloat value = 0;
            if ([cursor.dataSource respondsToSelector:@selector(plotCursor:valueOfIndex:)]) {
                value = [[cursor.dataSource plotCursor:cursor valueOfIndex:degreeIndex] floatValue];
                CGFloat y = cursor.bounds.size.height - paddingBottom - [self heightWithValue:value contentHeight:cursor.bounds.size.height - paddingTop - paddingBottom isUseRightYAxis:NO];
                CGContextFillEllipseInRect(ctx, CGRectMake(paddingLeft + insetLeft + everyDegreeWidth * degreeIndex - cursor.nodeRadius, y - cursor.nodeRadius, cursor.nodeRadius * 2, cursor.nodeRadius * 2));
            }
        }
        else {
            drawCenterPosition = leftPosition;
        }
        
        [currentDegreeName drawInRect:CGRectMake(drawCenterPosition - contentWidth / 2, drawOffsetTop, contentWidth, cursor.textFont.pointSize)
                       withAttributes:attributes];
        drawOffsetTop += cursor.textFont.pointSize + intervalY;
        
        NSInteger numberOfComponent = 0;
        if ([cursor.dataSource respondsToSelector:@selector(numberOfComponentInCursor:)]) {
            numberOfComponent = [cursor.dataSource numberOfComponentInCursor:cursor];
        }
        
        NSString *text = nil;
        if (cursor.cursorType == CursorType_Double) {
            if ([cursor.dataSource respondsToSelector:@selector(plotCursor: textOfIndex:)]) {
                // for (NSInteger i = 0; i < numberOfComponent; i++) {
                text = [cursor.dataSource plotCursor:cursor textOfIndex:degreeIndex];
                [text drawInRect:CGRectMake(drawCenterPosition - contentWidth / 2, drawOffsetTop, contentWidth, cursor.textFont.pointSize + 20)
                  withAttributes:attributes];
                //  drawOffsetTop += font.pointSize + intervalY;
                //}
            }
        }
        else if  (cursor.cursorType == CursorType_Single) {
            if ([cursor.dataSource respondsToSelector:@selector(plotCursor: textOfIndex:component:)]) {
                UIColor *textColor = nil;
                for (NSInteger i = 0; i < numberOfComponent; i++) {
                    if ([cursor.dataSource respondsToSelector:@selector(plotCursor:textColorOfComponent:)]) {
                        textColor = [cursor.dataSource plotCursor:cursor textColorOfComponent:i];
                        [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
                    }
                    text = [cursor.dataSource plotCursor:cursor textOfIndex:degreeIndex component:i];
                    [text drawInRect:CGRectMake(drawCenterPosition - contentWidth / 2, drawOffsetTop, contentWidth, cursor.textFont.pointSize + 20)
                      withAttributes:attributes];
                    drawOffsetTop += cursor.textFont.pointSize + intervalY;
                }
            }
            
        }
        UIGraphicsPopContext();
    }
    if (cursor.numberOfCursor == 2 && cursor.cursorType == CursorType_Double) {
        CGFloat rightPosition = cursor.anotherPositon;
        
        if (rightPosition < cursor.onePosition) {
            rightPosition = cursor.onePosition;
        }
        
        if (rightPosition < cursor.paddingLeft) {
            rightPosition = cursor.paddingLeft;
        }
        else if (rightPosition > cursor.bounds.size.width - cursor.paddingRight) {
            rightPosition = cursor.bounds.size.width - cursor.paddingRight;
        }
        CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
        CGContextMoveToPoint(ctx, rightPosition, paddingTop);
        CGContextAddLineToPoint(ctx, rightPosition, cursor.bounds.size.height - paddingBottom);
        CGContextStrokePath(ctx);
        
        NSInteger numberOfDegree = 0;
        if ([cursor.dataSource respondsToSelector:@selector(numberOfDegreeInCursor:)]) {
            numberOfDegree = [cursor.dataSource numberOfDegreeInCursor:cursor];
        }
        
        CGFloat everyDegreeWidth = (cursor.bounds.size.width - cursor.paddingLeft - cursor.paddingRight) / (numberOfDegree - 1);
        NSInteger degreeIndex = (rightPosition + everyDegreeWidth / 2 - cursor.paddingLeft) / everyDegreeWidth;
        
        CGFloat contentWidth = 200;
        CGFloat drawOffsetTop = 0;
        CGFloat intervalY = 10;
        
        UIGraphicsPushContext(ctx);
        
        CGFloat drawCenterPosition = cursor.bounds.size.width - cursor.paddingRight - 100;
        NSString *currentDegreeName = nil;
        if ([cursor.dataSource respondsToSelector:@selector(plotCursor:degreeNameOfIndex:)]) {
            currentDegreeName = [cursor.dataSource plotCursor:cursor degreeNameOfIndex:  degreeIndex];
        }
        
        [currentDegreeName drawInRect:CGRectMake(drawCenterPosition - contentWidth / 2, drawOffsetTop, contentWidth, cursor.textFont.pointSize)
                       withAttributes:attributes];
        drawOffsetTop += cursor.textFont.pointSize + intervalY;
        
        NSString *text = nil;
        if ([cursor.dataSource respondsToSelector:@selector(plotCursor:textOfIndex:)]) {
            text = [cursor.dataSource plotCursor:cursor textOfIndex:degreeIndex];
        }
        [text drawInRect:CGRectMake(drawCenterPosition - contentWidth / 2, drawOffsetTop, contentWidth, cursor.textFont.pointSize)
                       withAttributes:attributes];
        
        UIGraphicsPopContext();
        
        CGFloat value = 0;
        if ([cursor.dataSource respondsToSelector:@selector(plotCursor:valueOfIndex:)]) {
            value = [[cursor.dataSource plotCursor:cursor valueOfIndex:degreeIndex] floatValue];
            CGFloat y = cursor.bounds.size.height - paddingBottom - [self heightWithValue:value contentHeight:cursor.bounds.size.height - paddingTop - paddingBottom isUseRightYAxis:NO];
            CGContextFillEllipseInRect(ctx, CGRectMake(cursor.paddingLeft + everyDegreeWidth * degreeIndex - cursor.nodeRadius, y - cursor.nodeRadius, cursor.nodeRadius * 2, cursor.nodeRadius * 2));
        }
        
        CGPoint leftPoint = [self nodeWithCursor:cursor degreePosition:leftPosition];
        CGPoint rightPoint = [self nodeWithCursor:cursor degreePosition:rightPosition];
        CGFloat leftIndex = (leftPosition - cursor.paddingLeft) / everyDegreeWidth + 1;
        CGFloat rightIndex = (rightPosition - cursor.paddingLeft) / everyDegreeWidth;
        
        
        
        CGContextMoveToPoint(ctx, leftPoint.x, leftPoint.y);
        if ([cursor.dataSource respondsToSelector:@selector(plotCursor:valueOfIndex:)]) {
            for (NSInteger index = leftIndex; index < rightIndex; index++) {
                CGFloat yPosition = cursor.bounds.size.height - paddingBottom - [self heightWithValue:[[cursor.dataSource plotCursor:cursor valueOfIndex:index] floatValue] contentHeight:cursor.bounds.size.height - paddingTop - paddingBottom isUseRightYAxis:NO];
                CGContextAddLineToPoint(ctx, cursor.paddingLeft + index * everyDegreeWidth, yPosition);
            }
        }
        CGContextAddLineToPoint(ctx, rightPoint.x, rightPoint.y);
        CGContextStrokePath(ctx);
    }
}

- (CGPoint)nodeWithCursor:(HXPlotCursor *)cursor degreePosition:(CGFloat)degreePosition {
    
    CGPoint ret = CGPointZero;
    NSInteger numberOfDegree = 0;
    if ([cursor.dataSource respondsToSelector:@selector(numberOfDegreeInCursor:)]) {
        numberOfDegree = [cursor.dataSource numberOfDegreeInCursor:cursor];
    }
    CGFloat everyDegreeWidth = (cursor.bounds.size.width - cursor.paddingLeft - cursor.paddingRight) / (numberOfDegree - 1);
    NSInteger leftIndex = (degreePosition - cursor.paddingLeft) / everyDegreeWidth;
    
    if (leftIndex == numberOfDegree - 1) {
        leftIndex--;
    }
    
    NSInteger rightIndex = leftIndex + 1;
    
    if ([cursor.dataSource respondsToSelector:@selector(plotCursor:valueOfIndex:)]) {
        CGFloat leftHeight = [self heightWithValue:[[cursor.dataSource plotCursor:cursor valueOfIndex:leftIndex] floatValue] contentHeight:cursor.bounds.size.height - paddingTop - paddingBottom isUseRightYAxis:NO];
        CGFloat rightHeight = [self heightWithValue:[[cursor.dataSource plotCursor:cursor valueOfIndex:rightIndex] floatValue] contentHeight:cursor.bounds.size.height - paddingTop - paddingBottom isUseRightYAxis:NO];
        
        CGFloat leftYPosition = cursor.bounds.size.height - paddingBottom - leftHeight;
        CGFloat rightYPosition = cursor.bounds.size.height - paddingBottom - rightHeight;
        
        
        if (leftYPosition > rightYPosition) {
            ret = CGPointMake(degreePosition, leftYPosition - (degreePosition - cursor.paddingLeft - leftIndex * everyDegreeWidth) / everyDegreeWidth * (leftYPosition - rightYPosition));
        }
        else {
            ret = CGPointMake(degreePosition, rightYPosition - (cursor.paddingLeft + rightIndex * everyDegreeWidth - degreePosition) / everyDegreeWidth * (rightYPosition - leftYPosition));
        }
    }
    
    return ret;
}

- (CGFloat)heightWithValue:(CGFloat)value contentHeight:(CGFloat)height isUseRightYAxis:(BOOL)isUseRightYAxis {
    CGFloat ret = 0;
    CGFloat max = 0;
    CGFloat min = 0;
    if (isUseRightYAxis) {
        max = rightMaxValue;
        min = rightMinValue;
    }
    else {
        max = maxValue;
        min = minValue;
    }
    
    if (max > min) {
        ret = value / (max - min) * height;
    }
    return ret;
}

@end
