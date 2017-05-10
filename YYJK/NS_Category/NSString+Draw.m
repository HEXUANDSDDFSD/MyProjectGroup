//
//  NSString+Draw.m
//  tysx
//
//  Created by zwc on 13-11-28.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "NSString+Draw.h"

@implementation NSString (Draw)

- (void)drawCenterInRect:(CGRect )rect withFont:(UIFont *)font {
    [self drawInRect:rect withFont:font lineBreakMode:NSLineBreakByTruncatingMiddle alignment:NSTextAlignmentCenter];
}

- (void)drawRotationAtPoint:(CGPoint )point withFont:(UIFont *)font angle:(CGFloat)angel {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSelectFont(context, [font.fontName UTF8String], font.pointSize, kCGEncodingMacRoman);
    NSStringEncoding enc = NSUTF8StringEncoding;
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextMatrix (context, CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ), angel));
        CGContextShowTextAtPoint(context, point.x, point.y, [self cStringUsingEncoding:enc], strlen([self cStringUsingEncoding:enc]));
}

@end
