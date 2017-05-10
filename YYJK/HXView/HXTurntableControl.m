//
//  HXTurntableControl.m
//  tysx
//
//  Created by zwc on 14-7-7.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXTurntableControl.h"
#import "NSString+Draw.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HXTurntableControlLayerDelegate : NSObject

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *colors;

@end

@implementation HXTurntableControlLayerDelegate {
    
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if ([layer.name isEqualToString:@"mark"]) {
        CGContextMoveToPoint(ctx, layer.bounds.size.width / 2 - layer.bounds.size.width / 17, 0);
        CGContextAddLineToPoint(ctx, layer.bounds.size.width / 2 + layer.bounds.size.width / 17, 0);
        CGContextAddLineToPoint(ctx, layer.bounds.size.width / 2, layer.bounds.size.height / 5);
        CGContextClosePath(ctx);
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor);
        CGContextFillPath(ctx);
        
//        CGContextFillEllipseInRect(ctx, CGRectInset(layer.bounds, layer.bounds.size.width * 1.2 / 4, layer.bounds.size.width * 1.2 / 4));
        
//        UIGraphicsPushContext(ctx);
//        CGFloat sum = 0;
//        for (int i  = 0; i < [self.values count]; i++) {
//            sum += [self.values[i] floatValue];
//        }
//        
//        [[UIColor blackColor] set];
//        [[NSString stringWithFormat:@"总量:%.2f%%", sum * 100] drawInRect:CGRectMake(0, layer.bounds.size.height / 2 - 10, layer.bounds.size.width, 20) withFont:[UIFont systemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
//        UIGraphicsPopContext();
    }
    else if ([layer.name isEqualToString:@"plot"]) {
        CGFloat sum = 0.0;
        for (NSNumber *number in self.values) {
            sum += [number floatValue];
        }
        
        CGFloat currentAngle = -[[self.values objectAtIndex:0] floatValue] / sum * M_PI * 2 / 2 - M_PI / 2;
        
        for (int i = 0; i < [self.values count]; i++) {
            CGContextMoveToPoint(ctx, layer.bounds.size.width/2, layer.bounds.size.height / 2);
            CGContextSetFillColorWithColor(ctx, ((UIColor *)[self.colors objectAtIndex:i]).CGColor);
            CGContextAddArc(ctx, layer.bounds.size.width / 2, layer.bounds.size.height / 2, layer.bounds.size.width / 2 - 10,  currentAngle, currentAngle + [[self.values objectAtIndex:i] floatValue] / sum * M_PI * 2, 0);
            currentAngle += [[self.values objectAtIndex:i] floatValue] / sum * M_PI * 2;
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);
        }

    }
}

@end

@implementation HXTurntableControl {
    HXTurntableControlLayerDelegate *layerDelegate;
    CALayer *plotLayer;
    NSInteger selectedIndex;
    long long sumValues;
}
@synthesize currentIndex;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       self.backgroundColor = [UIColor clearColor];
        layerDelegate = [[HXTurntableControlLayerDelegate alloc] init];
        
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.frame = self.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:frame.size.width / 2];
        mask.path = [maskPath CGPath];
        self.layer.mask = mask;
        
        plotLayer = [CALayer layer];
        plotLayer.frame = self.bounds;
        plotLayer.delegate = layerDelegate;
        plotLayer.name = @"plot";
        plotLayer.contentsScale = [UIScreen mainScreen].scale;
        [plotLayer setNeedsDisplay];
        plotLayer.speed = 10;
        [self.layer addSublayer:plotLayer];
        
        CALayer *markLayer = [CALayer layer];
        markLayer.frame = self.bounds;
        markLayer.delegate = layerDelegate;
        markLayer.name = @"mark";
        markLayer.contentsScale = [UIScreen mainScreen].scale;
        [markLayer setNeedsDisplay];
        [self.layer addSublayer:markLayer];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tapGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (CGFloat)currentRate {
  return [layerDelegate.values[currentIndex] integerValue] * 1.0 / sumValues;
}

- (void)setValues:(NSArray *)values {
    sumValues = 0;
    for (NSNumber *number in values) {
        sumValues += [number integerValue];
    }
    layerDelegate.values = values;
}

- (NSArray *)values {
    return layerDelegate.values;
}

- (void)setColors:(NSArray *)colors {
    layerDelegate.colors = colors;
}

- (NSArray *)colors {
    return layerDelegate.colors;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
   CGPoint touchPoint = [tapGesture locationInView:self];
    NSInteger willSelectedIndex = [self tapIndexWithTapPoint:touchPoint];
    selectedIndex = willSelectedIndex;
    if ([delegate respondsToSelector:@selector(turntableControlDidChangeIndex:)]) {
        currentIndex = (int)selectedIndex;
        [delegate turntableControlDidChangeIndex:self];
    }
    [self animationChangeToAngle:[self angleLocationWithIndex:willSelectedIndex]];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    static CGPoint pervious = {0.0, 0.0};
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        pervious = [panGesture locationInView:self];
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint current = [panGesture locationInView:self];
        
        CGFloat degree = degreeBetweenLines(CGPointMake(self.bounds.size.width / 2, self.bounds.size.height/2), pervious, CGPointMake(self.bounds.size.width / 2, self.bounds.size.height/2), current);
        
        plotLayer.affineTransform = CGAffineTransformRotate(plotLayer.affineTransform, degree);
        NSInteger index = [self selectIndexOfCurrentAngle:atan2(plotLayer.affineTransform.b, plotLayer.affineTransform.a)];
        pervious = current;
        if (index != selectedIndex) {
            selectedIndex = index;
            AudioServicesPlaySystemSound(1057);
        }

    }
    else if (panGesture.state == UIGestureRecognizerStateEnded) {
        selectedIndex = [self selectIndexOfCurrentAngle:atan2(plotLayer.affineTransform.b, plotLayer.affineTransform.a)];
        if ([delegate respondsToSelector:@selector(turntableControlDidChangeIndex:)]) {
            currentIndex = (int)selectedIndex;
            [delegate turntableControlDidChangeIndex:self];
        }
        [self animationChangeToAngle:[self angleLocationWithIndex:selectedIndex]];
    }
}

- (NSInteger)tapIndexWithTapPoint:(CGPoint)tapPoint {
    CGFloat angle = atan2(tapPoint.y - self.bounds.size.height / 2, tapPoint.x - self.bounds.size.width / 2) + M_PI / 2;
    
    CGFloat affineTransformAngle = atan2(plotLayer.affineTransform.b, plotLayer.affineTransform.a);
    
    CGFloat angleDistance = angle - affineTransformAngle;
    
    if (angleDistance > M_PI) {
        angleDistance -= 2 * M_PI;
    }
    
    angleDistance += [self angleWithIndex:0] / 2;
    
    if (angleDistance < 0) {
        angleDistance += 2 * M_PI;
    }
    
    int willSelectedIndex = 0;
    for (int i = 0; i < [self.values count]; i++) {
        angleDistance -= [self angleWithIndex:i];
        if (angleDistance < 0 ) {
            willSelectedIndex = i;
            break;
        }
    }
    return willSelectedIndex;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
   // CGMutablePathRef path = CGPathCreateMutable();
    CGContextAddEllipseInRect(contextRef, rect);
    CGContextClip(contextRef);
    
    CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
    CGContextFillRect(contextRef, rect);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        NSInteger index = [self selectIndexOfCurrentAngle:atan2(((CALayer *)plotLayer.presentationLayer).affineTransform.b, ((CALayer *)plotLayer.presentationLayer).affineTransform.a)];
        plotLayer.affineTransform = CGAffineTransformMakeRotation([self angleLocationWithIndex:index]);
        [plotLayer removeAnimationForKey:@"acl"];
    }
}

- (CGFloat)sumValue {
    CGFloat sum = 0;
    for (NSNumber *number in self.values) {
        sum += [number floatValue];
    }
    return sum;
}

- (CGFloat)angleLocationWithIndex:(NSInteger)index {
    
    CGFloat angle = 0;
    
    if (index != 0) {
        angle = [[self.values objectAtIndex:0] floatValue] / [self sumValue] / 2 * M_PI * 2;
        for (int i = 1; i <= index; i++) {
            if (i == index) {
                angle += [self angleWithIndex:i] / 2;
            }
            else {
                angle += [self angleWithIndex:i];
            }
        }
    }
    
    if (angle > M_PI) {
        angle = M_PI * 2 - angle;
    }
    else {
        angle *= -1;
    }
    
    return angle;
}

- (NSInteger)selectIndexOfCurrentAngle:(CGFloat)angle {
    NSInteger *index = 0;
    
    if (angle > 0) {
        angle = M_PI * 2 - angle;
    }
    else {
        angle *= -1;
    }
    
    CGFloat addAngle = [[self.values objectAtIndex:0] floatValue] / [self sumValue] / 2 * M_PI * 2;
    
    if (addAngle < angle) {
        for (int i = 1; i < [self.values count]; i++) {
            addAngle += [[self.values objectAtIndex:i] floatValue] / [self sumValue] * M_PI * 2;
            if (addAngle >= angle) {
                index = i;
                break;
            }
        }
    }
    
    return index;
}

- (CGFloat)angleWithIndex:(NSInteger )index {
    return  [[self.values objectAtIndex:index] floatValue] / [self sumValue] * M_PI * 2;
}

- (void)animationChangeToAngle:(CGFloat)angle {
    
    CGFloat perivousAngle = [[plotLayer valueForKeyPath:@"transform.rotation.z"] floatValue];
    if (fabsf(angle - perivousAngle) > M_PI) {
        if (angle > 0) {
            angle -= 2 * M_PI;
        }
        else {
            angle += 2 * M_PI;
        }
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:angle];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = plotLayer.speed * 0.3;
    animation.delegate = self;
    [plotLayer addAnimation:animation forKey:@"acl"];
}

@end
