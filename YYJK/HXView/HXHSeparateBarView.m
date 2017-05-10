//
//  HXHSeparateBarView.m
//  tysx
//
//  Created by zwc on 13-12-30.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXHSeparateBarView.h"


@interface DrawView : UIView

@end

@implementation DrawView {
    CGFloat barWidth;
    CGFloat intervalX;
    CGPoint currentPoint;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectZero]) {
        barWidth = 14;
        intervalX = 3;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, (barWidth * 4 + intervalX) * 30, frame.size.height);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSArray *)data {
    NSMutableArray *retArr = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            [tempArr addObject:[NSNumber numberWithDouble:arc4random() % 14000]];
        }
        [retArr addObject:tempArr];
        
    }
    return retArr;
}

- (NSArray *)colors {
    return [NSArray arrayWithObjects:
            [UIColor colorWithRed:65/255.0 green:106/255.0 blue:180/255.0 alpha:1],
            [UIColor colorWithRed:172/255.0 green:60/255.0 blue:58/255.0 alpha:1],
            kFreshGreenColor,
            [UIColor colorWithRed:107/255.0 green:78/255.0 blue:152/255.0 alpha:1],nil];
}

- (NSString *)lastDate {
    return @"2013-12-11";
}

- (NSArray *)dates {
    NSMutableArray *retArr = [NSMutableArray array];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval lastTime = [[dateformatter dateFromString:[self lastDate]] timeIntervalSince1970];
    
    [dateformatter setDateFormat:@"MM-dd"];
    
    for (int i = 0; i < 30; i++) {
        NSString *key = [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:lastTime - 3600 * 24 * (i)]];
        [retArr insertObject:key atIndex:0];
    }
    return retArr;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:self];
    CGRect retFrame = CGRectMake(self.frame.origin.x + movePoint.x - currentPoint.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    if (retFrame.origin.x > 0) {
        retFrame = CGRectMake(0, retFrame.origin.y, retFrame.size.width, retFrame.size.height);
    }
    else if (retFrame.origin.x < [self superview].bounds.size.width - self.bounds.size.width) {
        retFrame = CGRectMake([self superview].bounds.size.width - self.bounds.size.width, retFrame.origin.y, retFrame.size.width, retFrame.size.height);
    }
    self.frame = retFrame;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
   CGFloat offsetTop = 520;
    CGFloat offsetLeft = 0;
   // offsetLeft += 60;
    NSArray *data = [self data];
    for (int i = 0; i < [data count]; i++) {
        for (int j = 0; j < 30; j++) {
            CGContextSetFillColorWithColor(context, ((UIColor *)[[self colors] objectAtIndex:i]).CGColor);
            int value = [[[[self data] objectAtIndex:i] objectAtIndex:j] intValue];
            CGContextFillRect(context, CGRectMake(offsetLeft + barWidth * i + j * (barWidth * 4 + intervalX), offsetTop, barWidth, -1.0 * value *  (60 * 7) / 14000));
        }
    }
    
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, offsetLeft - 5, offsetTop);
    CGContextAddLineToPoint(context, offsetLeft + 30 * (barWidth * 4 + 1), offsetTop);
    CGContextStrokePath(context);
    
    for (int i = 0; i < 30; i++) {
        CGContextMoveToPoint(context, offsetLeft + (i + 1) * (barWidth * 4 + intervalX), offsetTop);
        CGContextAddLineToPoint(context, offsetLeft + (i + 1) * (barWidth * 4 + intervalX), offsetTop + 5);
        CGContextStrokePath(context);
    }
    
    CGContextSelectFont(context, "Helvetica", 13, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextMatrix (context, CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ), 0));
    NSString *str = nil;
    offsetLeft = 10;
    [[UIColor blackColor] set];
    for (int i = 0; i < 30; i++) {
        str = [[self dates] objectAtIndex:i];
        CGContextShowTextAtPoint(context, offsetLeft + (barWidth * 4 + intervalX) * i, offsetTop + 30, [str UTF8String], strlen(    [str UTF8String]));
    }

}

@end

@implementation HXHSeparateBarView {
    DrawView *view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(90, 0, 900, 560)];
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        
        view = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, 0, bgView.bounds.size.height)];
        [bgView addSubview:view];
    }
    return self;
}

- (NSArray *)colors {
    return [NSArray arrayWithObjects:
            [UIColor colorWithRed:65/255.0 green:106/255.0 blue:180/255.0 alpha:1],
            [UIColor colorWithRed:172/255.0 green:60/255.0 blue:58/255.0 alpha:1],
            kFreshGreenColor,
            [UIColor colorWithRed:107/255.0 green:78/255.0 blue:152/255.0 alpha:1],nil];
}

- (NSArray *)names {
    return [NSArray arrayWithObjects:@"垂直频道",@"特色包",@"跨平产品包",@"渠道产品包",nil];
}
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//    
//}

- (void)drawRect:(CGRect)rect {
    CGFloat offsetTop = 50;
    CGFloat offsetLeft = 340;
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < [[self names] count]; i++) {
        CGContextSetFillColorWithColor(context, ((UIColor *)[[self colors] objectAtIndex:i]).CGColor);
        CGContextFillRect(context, CGRectMake(offsetLeft, offsetTop, 10, 10));
        offsetLeft += 15;
        [[[self names] objectAtIndex:i] drawAtPoint:CGPointMake(offsetLeft, offsetTop - 2) withFont:[UIFont systemFontOfSize:13]];
        offsetLeft += [[[self names] objectAtIndex:i] sizeWithFont:[UIFont systemFontOfSize:13]].width + 15;
    }
    
    offsetLeft = 30;
    offsetTop += 40;
    int maxValue = 14000;
    [[UIColor blackColor] set];
    for (int i = 0; i < 8; i++) {
//        [[NSString stringWithFormat:@"%d", maxValue - i * 2000] drawAtPoint:CGPointMake(offsetLeft, offsetTop + i * 60) withFont:[UIFont systemFontOfSize:12]];
        [[NSString stringWithFormat:@"%d", maxValue - i * 2000]
         drawInRect:CGRectMake(offsetLeft, offsetTop + i * 60, 50, 15)
         withFont:[UIFont systemFontOfSize:12]
         lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
        
    }
    
    CGContextSetLineWidth(context, 0.5);
    offsetTop += 9;
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, offsetLeft + 59, offsetTop);
    CGContextAddLineToPoint(context, offsetLeft + 59, offsetTop + 60 * 7 + 5);
    CGContextStrokePath(context);
    
    for (int i = 0; i < 7; i++) {
        CGContextMoveToPoint(context, offsetLeft + 59, offsetTop);
        CGContextAddLineToPoint(context, offsetLeft + 54, offsetTop);
        CGContextStrokePath(context);
        offsetTop += 60;
    }
    
//    offsetTop = 520;
//    CGFloat barWidth = 7;
//    offsetLeft += 60;
//    NSArray *data = [self data];
//    for (int i = 0; i < [data count]; i++) {
//        for (int j = 0; j < 30; j++) {
//            CGContextSetFillColorWithColor(context, ((UIColor *)[[self colors] objectAtIndex:i]).CGColor);
//            int value = [[[[self data] objectAtIndex:i] objectAtIndex:j] intValue];
//            CGContextFillRect(context, CGRectMake(offsetLeft + barWidth * i + j * (barWidth * 4 + 1), offsetTop, barWidth, -1.0 * value *  (60 * 7) / 14000));
//        }
//    }
//    
//    CGContextSetLineWidth(context, 0.5);
//    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
//    CGContextMoveToPoint(context, offsetLeft - 5, offsetTop);
//    CGContextAddLineToPoint(context, offsetLeft + 30 * (barWidth * 4 + 1), offsetTop);
//    CGContextStrokePath(context);
//    
//    for (int i = 0; i < 30; i++) {
//        CGContextMoveToPoint(context, offsetLeft + (i + 1) * (barWidth * 4 + 1), offsetTop);
//        CGContextAddLineToPoint(context, offsetLeft + (i + 1) * (barWidth * 4 + 1), offsetTop + 5);
//        CGContextStrokePath(context);
//    }
//    
//    CGContextSelectFont(context, "Helvetica", 13, kCGEncodingMacRoman);
//    CGContextSetTextDrawingMode(context, kCGTextFill);
//    CGContextSetTextMatrix (context, CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ), M_PI_4));
//    NSString *str = nil;
//    offsetLeft = 90;
//    [[UIColor blackColor] set];
//    for (int i = 0; i < 30; i++) {
//        str = [[self dates] objectAtIndex:i];
//        CGContextShowTextAtPoint(context, offsetLeft - 7 + (barWidth * 4 + 1) * i, offsetTop + 40, [str UTF8String], strlen(    [str UTF8String]));
//    }
}

@end
