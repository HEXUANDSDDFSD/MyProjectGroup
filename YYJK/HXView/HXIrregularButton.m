//
//  HXNiuBiButton.m
//  ButtonTest
//
//  Created by zwc on 13-11-22.
//  Copyright (c) 2013年 hexuan. All rights reserved.
//

#import "HXIrregularButton.h"
#import "UIColor+category.h"

@implementation HXIrregularButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (UIColor *) colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    NSLog(@"%@", NSStringFromCGPoint(point));
//    return self;
//}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([[self colorOfPoint:point] isClearColor]) {
        return NO;
    }
    return YES;
}

@end
