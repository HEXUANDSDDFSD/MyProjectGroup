//
//  HXMeasureView.m
//  tysx
//
//  Created by zwc on 14-6-11.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXMeasureView.h"

@implementation HXMeasureView {
    CGPoint beginPoint;
    CGPoint endPoint;
    UILabel *frameLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        frameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, frame.size.width, 30)];
        frameLabel.backgroundColor = [UIColor clearColor];
        frameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:frameLabel];
        
        beginPoint = CGPointMake(20, 40);
        endPoint = CGPointMake(300, 700);
        [self updateFrame];
        
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    if ([pan numberOfTouches] == 1) {
        endPoint = [pan locationOfTouch:0 inView:self];
        [self setNeedsDisplay];
        [self updateFrame];
    }
    else if ([pan numberOfTouches] == 2) {
        beginPoint = [pan locationOfTouch:0 inView:self];
        endPoint = [pan locationOfTouch:1 inView:self];
        [self setNeedsDisplay];
        [self updateFrame];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ref, [UIColor redColor].CGColor);
    CGContextStrokeRect(ref, CGRectMake(beginPoint.x, beginPoint.y, endPoint.x - beginPoint.x, endPoint.y - beginPoint.y));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)updateFrame {
    CGRect showFrame = [self rectWithBeginPoint:beginPoint endPoint:endPoint];
    NSLog(@"%@", [self rectInputFormatWithRect:showFrame]);
    frameLabel.text = [NSString stringWithFormat:@"X:%.1f    Y:%.1f   WIDTH:%.1f  HEIGHT:%.1f", showFrame.origin.x, showFrame.origin.y, showFrame.size.width, showFrame.size.height];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    beginPoint = [self newBeginPointWithOriginBeginPoint:beginPoint
                                           orginEndPoint:endPoint
                                              touchPoint:touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray * touchesArr=[[event allTouches] allObjects];
    if ([touchesArr count] == 1) {
        UITouch *touch = [touchesArr objectAtIndex:0];
        endPoint = [touch locationInView:self];
        [self setNeedsDisplay];
        [self updateFrame];
    }
    else if([touchesArr count] == 2) {
        UITouch *touch1 = touchesArr[0];
        UITouch *touch2 = touchesArr[1];
        beginPoint = [touch1 locationInView:self];
        endPoint = [touch2 locationInView:self];
        [self setNeedsDisplay];
        [self updateFrame];
    }
}

- (CGPoint)newBeginPointWithOriginBeginPoint:(CGPoint)begin
                               orginEndPoint:(CGPoint)end
                                  touchPoint:(CGPoint)touchPoint {
    CGFloat beginXDistance = fabsf(touchPoint.x - begin.x);
    CGFloat beginYDistance = fabsf(touchPoint.y - begin.y);
    CGFloat endXDistance = fabsf(touchPoint.x - end.x);
    CGFloat endYDistance = fabsf(touchPoint.y - end.y);
    
    CGPoint newBeginPoint;
    
    if (beginXDistance < endXDistance) {
        newBeginPoint = CGPointMake(end.x, beginYDistance < endYDistance  ? end.y : begin.y);
    }
    else {
        newBeginPoint = CGPointMake(begin.x, beginYDistance < endYDistance  ? end.y : begin.y);
    }
    
    return newBeginPoint;
}

- (CGRect)rectWithBeginPoint:(CGPoint)begin endPoint:(CGPoint)end {
    CGRect rect = CGRectMake(begin.x < end.x ? begin.x : end.x, begin.y < end.y ? begin.y : end.y, fabsf(begin.x - end.x), fabsf(begin.y - end.y));
    
    return rect;
}

- (NSString *)rectInputFormatWithRect:(CGRect)rect {
    return [NSString stringWithFormat:@"CGRectMake(%.1f, %.1f, %.1f, %.1f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
