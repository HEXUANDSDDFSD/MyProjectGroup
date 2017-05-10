//
//  HXCorePlotControl.m
//  tysx
//
//  Created by zwc on 14-7-22.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXCorePlotControl.h"

@implementation HXCorePlotControl {
    HXCorePlotLayerDelegate *plotLayerDelegate;
    HXCorePlotYAxisLayer *yAxisLayer;
    HXCoreplotXAxisLayer *xAxisLayer;
    NSMutableArray *plotLayerList;
    HXPlotCursor *cursorLayer;
    CALayer *displayClipLayer;
    BOOL _needCursor;
}
@synthesize title;
@synthesize titleFont;
@synthesize titleOffset;
@synthesize legendIntervalX;
@synthesize legendList;
@synthesize legendOriginPoint;
@synthesize delegate;
@synthesize titleLocation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        plotLayerList = [NSMutableArray array];
        
        plotLayerDelegate = [[HXCorePlotLayerDelegate alloc] init];
        
        yAxisLayer = [HXCorePlotYAxisLayer layer];
        yAxisLayer.delegate = plotLayerDelegate;
        [yAxisLayer setNeedsDisplay];
        
        [self.layer addSublayer:yAxisLayer];
        
        displayClipLayer = [CALayer layer];
        displayClipLayer.masksToBounds = YES;
//        displayClipLayer.backgroundColor = [UIColor greenColor].CGColor;
//        displayClipLayer.opacity = 0.2;
        [yAxisLayer addSublayer:displayClipLayer];
        
        xAxisLayer = [HXCoreplotXAxisLayer layer];
        xAxisLayer.delegate = plotLayerDelegate;
        [displayClipLayer addSublayer:xAxisLayer];
        [xAxisLayer setNeedsDisplay];
        
        self.legendIntervalX = 30;
        self.titleLocation = TitleLocation_Bottom;
        self.titleFont = [UIFont systemFontOfSize:17];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    NSMutableParagraphStyle *para = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [attr setValue:[UIColor colorWithHexString:@"1A1A1A"] forKey:NSForegroundColorAttributeName];
    
    if (self.unitString.length != 0) {
        para.alignment = NSTextAlignmentRight;
        [attr setValue:para forKey:NSParagraphStyleAttributeName];
        [attr setValue:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
        [self.unitString drawInRect:CGRectMake(0, plotLayerDelegate.paddingTop - 25, plotLayerDelegate.paddingLeft, 20) withAttributes:attr];
    }
    
    if (self.rightUnitString.length != 0) {
        [self.rightUnitString drawAtPoint:CGPointMake(rect.size.width - plotLayerDelegate.paddingRight, plotLayerDelegate.paddingTop - 25) withAttributes:attr];
    }
    
    para.alignment = NSTextAlignmentCenter;
    [attr setValue:para forKey:NSParagraphStyleAttributeName];
    [attr setValue:self.titleFont forKey:NSFontAttributeName];
    
    if (title.length != 0) {
        CGFloat offsetTop = 0;
        if (titleLocation == TitleLocation_Bottom) {
            offsetTop = rect.size.height - plotLayerDelegate.paddingBottom + titleOffset + 4;
        }
        else {
            offsetTop = plotLayerDelegate.paddingTop + titleOffset;
        }
        [title drawInRect:CGRectMake(0, offsetTop, rect.size.width, 30) withAttributes:attr];
    }
    
//    ) {
//        <#statements#>
//    }
//    [title drawInRect:CGRectMake(0, rect.size.height - 40, rect.size.width, 30) withAttributes:attr];
    
    [attr removeAllObjects];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint oriPoint = legendOriginPoint;
    for (int i = 0; i < [legendList count]; i++) {
        HXLegendInfo *legendInfo = legendList[i];
        CGContextSetFillColorWithColor(ctx, legendInfo.color.CGColor);
        CGContextFillRect(ctx, CGRectMake(oriPoint.x, oriPoint.y - legendInfo.fillHeight / 2, legendInfo.fillWidth, legendInfo.fillHeight));
        oriPoint.x += legendInfo.fillWidth + legendInfo.intervalX;
        
        [legendInfo.legendTitle drawAtPoint:CGPointMake(oriPoint.x, oriPoint.y - legendInfo.titleTopOffset) withAttributes:@{NSFontAttributeName:legendInfo.font}];
        oriPoint.x += legendInfo.titleWidth + self.legendIntervalX;
    }
}

- (void)layoutSubviews {
    CGFloat contentWidth = self.bounds.size.width - self.layerManager.paddingLeft - self.layerManager.paddingRight;
    displayClipLayer.frame = CGRectMake(self.layerManager.paddingLeft - xAxisLayer.offsetLeft, 0, contentWidth + xAxisLayer.offsetLeft + xAxisLayer.offsetRight, self.bounds.size.height);
    
    yAxisLayer.frame = self.bounds;
    
    CGFloat xAxisLayerWidth = contentWidth * xAxisLayer.contentWidthScale + self.layerManager.paddingLeft + self.layerManager.paddingRight + xAxisLayer.offsetLeft + xAxisLayer.offsetRight;
    
    xAxisLayer.frame = CGRectMake(self.layerManager.paddingRight + displayClipLayer.bounds.size.width - xAxisLayerWidth, 0, xAxisLayerWidth, self.bounds.size.height);
    
    for (HXBasePlot *plot in self.plotLayers) {
        plot.frame = self.xAxis.bounds;
    }
    
    if (self.needCursor) {
        self.cursor.paddingLeft = self.layerManager.paddingLeft + self.layerManager.insetLeft - self.xAxis.offsetLeft;
        self.cursor.paddingRight = self.layerManager.paddingRight + self.layerManager.insetRight - self.xAxis.offsetRight  ;
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    
    static CGFloat originXPosition;
    
    if (panGesture.numberOfTouches == 1) {
        if (panGesture.state == UIGestureRecognizerStateBegan) {
            originXPosition = [panGesture locationInView:self].x;
        }
        
        CGFloat resultXPosition = xAxisLayer.frame.origin.x + [panGesture locationInView:self].x - originXPosition;
        
        if (resultXPosition > self.layerManager.paddingLeft * -1) {
            resultXPosition = self.layerManager.paddingLeft * -1;
        }
        if (resultXPosition < self.layerManager.paddingRight + displayClipLayer.bounds.size.width - xAxisLayer.bounds.size.width) {
            resultXPosition = self.layerManager.paddingRight + displayClipLayer.bounds.size.width - xAxisLayer.bounds.size.width;
        }
        
        xAxisLayer.frame = CGRectMake(resultXPosition, 0, xAxisLayer.bounds.size.width, xAxisLayer.bounds.size.height);
        originXPosition = [panGesture locationInView:self].x;
    }
    
    if (self.needCursor && panGesture.state == UIGestureRecognizerStateChanged) {
        
        if (cursorLayer.cursorType == CursorType_Single) {
            CGPoint touchPoint = [panGesture locationOfTouch:0 inView:self];
            cursorLayer.onePosition = touchPoint.x;
        }
        else if (cursorLayer.cursorType == CursorType_Double) {
            CGPoint touchPoint = [panGesture locationOfTouch:0 inView:self];
            cursorLayer.onePosition = touchPoint.x;
            if (panGesture.numberOfTouches == 2) {
                cursorLayer.numberOfCursor = 2;
                CGPoint touchPoint = [panGesture locationOfTouch:1 inView:self];
                cursorLayer.anotherPositon = touchPoint.x;
            }
        }
    }
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        cursorLayer.numberOfCursor = 0;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    
    if (![delegate respondsToSelector:@selector(numberOfNeedTouchDegreeCorePlotControl:)] ||
        ![delegate respondsToSelector:@selector(corePlotControl:touchIndex:)]) {
        return;
    }
    
    CGRect validFrame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(self.layerManager.paddingTop, self.layerManager.paddingLeft, self.layerManager.paddingBottom, self.layerManager.paddingRight));
    CGPoint touchPoint = [tapGesture locationInView:self];
    if (CGRectContainsPoint(validFrame, touchPoint)) {
        CGFloat xAxisTouchX = [self.layer convertPoint:touchPoint toLayer:self.xAxis].x;
        
        NSInteger degreeNum = [delegate numberOfNeedTouchDegreeCorePlotControl:self];
        if (degreeNum > 1) {
            CGFloat everyWidth = (self.xAxis.bounds.size.width - plotLayerDelegate.insetLeft - plotLayerDelegate.insetRight - plotLayerDelegate.paddingLeft - plotLayerDelegate.paddingRight) / (degreeNum - 1);
            
            [delegate corePlotControl:self touchIndex:(NSInteger)((xAxisTouchX - plotLayerDelegate.insetLeft - plotLayerDelegate.paddingLeft + everyWidth / 2) / everyWidth)];
        }
    }
}

- (void)setNeedCursor:(BOOL)needCursor {
    _needCursor = needCursor;
    if (needCursor) {
        if (cursorLayer == nil) {
            cursorLayer = [HXPlotCursor layer];
            cursorLayer.frame = self.bounds;
            cursorLayer.speed = 20;
            cursorLayer.delegate = plotLayerDelegate;
            cursorLayer.cursorType = CursorType_Single;
            [self.layer addSublayer:cursorLayer];
        }
    }
    else {
        [cursorLayer removeFromSuperlayer];
        cursorLayer = nil;
    }
}

- (BOOL)needCursor {
    return _needCursor;
}

- (HXCorePlotLayerDelegate *)layerManager {
    return plotLayerDelegate;
}

- (HXPlotCursor *)cursor {
    return cursorLayer;
}

- (NSArray *)plotLayers {
    return plotLayerList;
}

- (HXCorePlotYAxisLayer *)yAxis {
    return yAxisLayer;
}

- (HXCoreplotXAxisLayer *)xAxis {
    return xAxisLayer;
}

- (void)reloadData {
    [self setNeedsDisplay];
    [self.yAxis setNeedsDisplay];
    [self.xAxis setNeedsDisplay];
    for (HXBasePlot *plot in plotLayerList) {
        [plot setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.needCursor) {
        NSArray *toucheArr = [[event allTouches] allObjects];
        UITouch *touch = [touches allObjects][0];
        CGPoint touchPoint = [touch locationInView:self];
        cursorLayer.numberOfCursor = 1;
        cursorLayer.onePosition = touchPoint.x;
        if ([toucheArr count] == 2 && self.cursor.cursorType == CursorType_Double) {
            touch = toucheArr[1];
            touchPoint = [touch locationInView:self];
            cursorLayer.anotherPositon = touchPoint.x;
            cursorLayer.numberOfCursor = 2;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *toucheArr = [[event allTouches] allObjects];
    if (self.needCursor &&
        cursorLayer.cursorType == CursorType_Double &&
        cursorLayer.numberOfCursor == 1 && [toucheArr count] == 2) {
        UITouch *touch = toucheArr[0];
        CGPoint touchPoint = [touch locationInView:self];
        cursorLayer.onePosition = touchPoint.x;
        
        touch = toucheArr[1];
        touchPoint = [touch locationInView:self];
        cursorLayer.anotherPositon = touchPoint.x;
        cursorLayer.numberOfCursor = 2;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    cursorLayer.numberOfCursor = 0;
}

- (void)addPlot:(HXBasePlot *)plot {
    plot.frame = self.xAxis.bounds;
    plot.delegate = plotLayerDelegate;
    [plot setNeedsDisplay];
    [plotLayerList addObject:plot];
    [self.xAxis addSublayer:plot];
}

- (void)removePlotWithName:(NSString *)name {
    NSMutableArray *plots = [NSMutableArray arrayWithArray:plotLayerList];
    for (HXBasePlot *plot in plots) {
        if ([plot.plotName isEqualToString:name]) {
            [plot removeFromSuperlayer];
            [plotLayerList removeObject:plot];
        }
    }
}

- (void)removePlotAtIndex:(NSInteger)index {
    [plotLayerList[index] removeFromSuperlayer];
    [plotLayerList removeObjectAtIndex:index];
}

- (void)removeAllPlot {
    NSArray *temp = [NSArray arrayWithArray:plotLayerList];
    for (HXBasePlot *plot in temp) {
        [plotLayerList removeObject:plot];
        [plot removeFromSuperlayer];
    }
}

@end
