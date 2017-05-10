//
//  HXSeparateBarView.m
//  tysx
//
//  Created by zwc on 13-12-29.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXSeparateBarView.h"

@implementation HXSeparateBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (NSArray *)data {
    NSMutableArray *retArr = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            [tempArr addObject:[NSNumber numberWithDouble:arc4random() % 31 / 100.0]];
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
            [UIColor colorWithRed:107/255.0 green:78/255.0 blue:152/255.0 alpha:1],
            [UIColor colorWithRed:69/255.0 green:185/255.0 blue:189/255.0 alpha:1],
            [UIColor orangeColor],nil];
}

- (NSArray *)names {
    return [NSArray arrayWithObjects:@"wap门户",@"客户端预装",@"富媒体预装",@"客户端4预装",@"客户端5预装",@"渠道推广", nil];
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


- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] set];
    [@"渠道订购来源" drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height) withFont:[UIFont systemFontOfSize:17] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    
    NSArray *tempArr = [NSArray arrayWithObjects:@"2",@"1.5",@"1",@"0.5",@"0", nil];
    CGFloat offsetTop = 50;
    CGFloat offsetLeft = 50;
    for (int i = 0; i < [tempArr count]; i++) {
        [[tempArr objectAtIndex:i] drawAtPoint:CGPointMake(offsetLeft, offsetTop)withFont:[UIFont systemFontOfSize:12]];
        offsetTop += 100;
    }
    offsetTop -= 90;
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        [resultArr addObject:[NSNumber numberWithDouble:0.0]];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSelectFont(context, "Helvetica", 13, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextMatrix (context, CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ), M_PI_2));
    NSString *str1 = @"x10000";
    [[UIColor blackColor] set];
    
    CGContextShowTextAtPoint(context, 40, 200, [str1 UTF8String], strlen(    [str1 UTF8String]));
//    double delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        //<#code to be executed on the main queue after delay#>
//    });
    
    offsetLeft += 50;
    CGFloat barWidth = 15;
    for (int i = 0; i < 6; i++) {
        CGContextSetFillColorWithColor(context, ((UIColor *)[[self colors] objectAtIndex:i]).CGColor);
        for (int j = 0; j < 30; j++) {
            double currentRetValue = [[resultArr objectAtIndex:j] doubleValue];
            double currentDrawValue = [[[[self data] objectAtIndex:i] objectAtIndex:j] doubleValue];
            CGContextFillRect(context, CGRectMake(offsetLeft + barWidth * 2 * j,  offsetTop - (currentRetValue / 2) * 400, barWidth, -currentDrawValue / 2 * 400));
            [resultArr replaceObjectAtIndex:j withObject:[NSNumber numberWithDouble:currentRetValue + currentDrawValue]];
        }
    }
    CGFloat temp = 6;
    for (int i = 0; i < [resultArr count]; i++) {
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        double currentRetValue = [[resultArr objectAtIndex:i] doubleValue];
        CGContextStrokeRect(context, CGRectMake(offsetLeft + i * 2 * barWidth - temp, offsetTop - (currentRetValue / 2) * 400 - 8, barWidth + temp * 2, -17));
        [[UIColor blackColor] set];
        [[NSString stringWithFormat:@"%.2f", currentRetValue] drawInRect:CGRectMake(offsetLeft + i * 2 * barWidth - temp, offsetTop - (currentRetValue / 2) * 400 - 25, barWidth + temp * 2, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    }
    
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, offsetLeft - barWidth / 2, offsetTop);
    CGContextAddLineToPoint(context, offsetLeft + 30 * barWidth * 2 - barWidth / 2 , offsetTop);
    CGContextStrokePath(context);
    
    for (int i = 0; i < 31; i++) {
        CGContextMoveToPoint(context, offsetLeft + i * barWidth * 2 - barWidth / 2, offsetTop);
        CGContextAddLineToPoint(context, offsetLeft + i * barWidth * 2 - barWidth / 2, offsetTop + 5);
        CGContextStrokePath(context);
    }
    
    offsetTop += 65;
    offsetLeft = 240;
    for (int i = 0; i < [[self names] count]; i++) {
        CGContextSetFillColorWithColor(context, ((UIColor *)[[self colors] objectAtIndex:i]).CGColor);
        CGContextFillRect(context, CGRectMake(offsetLeft, offsetTop, 10, 10));
        offsetLeft += 15;
        [[[self names] objectAtIndex:i] drawAtPoint:CGPointMake(offsetLeft, offsetTop - 2) withFont:[UIFont systemFontOfSize:13]];
        offsetLeft += [[[self names] objectAtIndex:i] sizeWithFont:[UIFont systemFontOfSize:13]].width + 15;
    }
    
    
    CGContextSelectFont(context, "Helvetica", 13, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextMatrix (context, CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ), M_PI_4));
    NSString *str = nil;
    offsetLeft = 90;
    [[UIColor blackColor] set];
    for (int i = 0; i < 30; i++) {
        str = [[self dates] objectAtIndex:i];
        CGContextShowTextAtPoint(context, offsetLeft + barWidth * 2 * i, offsetTop - 25, [str UTF8String], strlen(    [str UTF8String]));
    }

}

@end
