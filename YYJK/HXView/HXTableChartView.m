//
//  HXTableChartView.m
//  tysx
//
//  Created by zwc on 13-12-18.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXTableChartView.h"

@implementation HXTableChartView {
    UIImageView *topView;
}
@synthesize dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    if (topView == nil) {
        CGFloat height =  [dataSource tableChartView:self heightOfRow:0];
        height += self.paddingTop;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width, height), YES, [UIScreen mainScreen].scale                                                              );
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        topView = [[UIImageView alloc] initWithImage:uiImage];
        topView.frame = CGRectMake(0, 0, self.bounds.size.width, height);
    }
}

- (UIView *)showTopView {
    return topView;
}


- (void)drawRect:(CGRect)rect {
    [[UIColor grayColorWithGrayDegree:80/255.0] set];
    [self.title drawInRect:CGRectMake(0, 20, rect.size.width, 30) withFont:[UIFont systemFontOfSize:20]
             lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    
    CGFloat paddingL = self.paddingLeft;
    CGFloat paddingT = self.paddingTop;
    NSInteger rowSum = 0;
    NSInteger columnSum = 0;
    CGFloat rowHeightSum = 0;
    CGFloat columnWidthSum = 0;
    if ([dataSource respondsToSelector:@selector(numberOfRowsInTableChartView:)]) {
        rowSum = [dataSource numberOfRowsInTableChartView:self];
    }
    if ([dataSource respondsToSelector:@selector(numberOfColumnsInTableChartView:)]) {
        columnSum = [dataSource numberOfColumnsInTableChartView:self];
    }
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    if ([dataSource respondsToSelector:@selector(tableChartView:fontOfRow:column:)] &&
        [dataSource respondsToSelector:@selector(tableChartView:textColorOfRow:column:)] &&
        [dataSource respondsToSelector:@selector(tableChartView:textOfRow:column:)] &&
        [dataSource respondsToSelector:@selector(tableChartView:backgroundColorOfRow:column:)]&&
        [dataSource respondsToSelector:@selector(tableChartView:heightOfRow:)] &&
        [dataSource respondsToSelector:@selector(tableChartView:widthOfColumn:)] &&
        [dataSource respondsToSelector:@selector(tableChartView:needDrawTrendOfRow:column:)] &&
        [dataSource respondsToSelector:@selector(tableChartView:drawTrendDerictionOfRow:column:)]) {
        CGFloat paddingT = self.paddingTop;
        CGFloat paddingL = self.paddingLeft;
        UIColor *bgColor = nil;
        CGFloat height = 0;
        CGFloat width = 0;
        UIColor *textColor = nil;
        NSString *text = nil;
        UIFont *font = nil;
        
        for (int row = 0; row < rowSum; row++) {
            paddingL = self.paddingLeft;
            height = [dataSource tableChartView:self heightOfRow:row];
            for (int column = 0; column < columnSum; column++) {
                width = [dataSource tableChartView:self widthOfColumn:column];
                bgColor = [dataSource tableChartView:self backgroundColorOfRow:row column:column];
                CGContextSetFillColorWithColor(contextRef, bgColor.CGColor);
                CGRect drawRect = CGRectMake(paddingL, paddingT, width, height);
                CGContextFillRect(contextRef, drawRect);
                paddingL += width;
                
                BOOL isNeedDrawTrend = [dataSource tableChartView:self needDrawTrendOfRow:row column:column];
                if (isNeedDrawTrend) {
                    eDrawDirection direction = [dataSource tableChartView:self drawTrendDerictionOfRow:row column:column];
                    CGFloat side = 20;
                    switch (direction) {
                        case DrawDirection_Right:
                            drawTriangle([UIColor colorWithRed:252/255.0 green:222/255.0 blue:87/255.0 alpha:1.0], CGPointMake(drawRect.origin.x + 4 + side / 2, drawRect.origin.y + drawRect.size.height / 2), side, direction);
                            break;
                        case DrawDirection_Up:
                            drawTriangle(kFreshGreenColor, CGPointMake(drawRect.origin.x + 4 + side / 2, drawRect.origin.y + drawRect.size.height / 2), side, direction);
                            break;
                        case DrawDirection_Down:
                            drawTriangle([UIColor redColor], CGPointMake(drawRect.origin.x + 4 + side / 2, drawRect.origin.y + drawRect.size.height / 2), side, direction);
                            break;
                        default:
                            break;
                    }
                }
                
                textColor = [dataSource tableChartView:self textColorOfRow:row column:column];
                text = [dataSource tableChartView:self textOfRow:row column:column];
                font = [dataSource tableChartView:self fontOfRow:row column:column];
                CGFloat fontHeight = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, height)].height;
                [textColor set];
                [text drawInRect:CGRectMake(drawRect.origin.x, drawRect.origin.y + (height - fontHeight) / 2, width, height) withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
            }
            paddingT += [dataSource tableChartView:self heightOfRow:row];
        }
    }
    
    if ([dataSource respondsToSelector:@selector(tableChartView:heightOfRow:)] &&
        [dataSource respondsToSelector:@selector(tableChartView:widthOfColumn:)]) {
        for (int i = 0; i < columnSum; i++) {
            columnWidthSum += [dataSource tableChartView:self widthOfColumn:i];
        }
        for (int i = 0; i < rowSum; i++) {
            rowHeightSum += [dataSource tableChartView:self heightOfRow:i];
        }
        for (int i = 0; i < columnSum - 1; i++) {
            paddingL += [dataSource tableChartView:self widthOfColumn:i];
            CGContextSetStrokeColorWithColor(contextRef, self.columnLineColor.CGColor);
            CGContextSetLineWidth(contextRef, self.columnLineWidth);
            CGContextMoveToPoint(contextRef, paddingL, paddingT);
            CGContextAddLineToPoint(contextRef, paddingL, paddingT + rowHeightSum);
            CGContextStrokePath(contextRef);
        }
        paddingL = self.paddingLeft;
        for (int i = 0; i < rowSum - 1; i++) {
            paddingT += [dataSource tableChartView:self heightOfRow:i];
            CGContextSetStrokeColorWithColor(contextRef, self.rowLineColor.CGColor);
            CGContextSetLineWidth(contextRef, self.rowLineWidth);
            CGContextMoveToPoint(contextRef, paddingL, paddingT);
            CGContextAddLineToPoint(contextRef, paddingL + columnWidthSum, paddingT);
            CGContextStrokePath(contextRef);
        }
        CGContextSetStrokeColorWithColor(contextRef, self.borderLineColor.CGColor);
        //CGContextSetStrokeColorWithColor(contextRef, [UIColor grayColor].CGColor);

        CGContextSetLineWidth(contextRef, self.borderLineWidth);
        CGContextStrokeRect(contextRef, CGRectMake(self.paddingLeft, self.paddingTop, columnWidthSum, rowHeightSum));
    }
    
    CGFloat textHeight = [self.bottomStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenHeight - 2 * self.paddingLeft, 20480)].height + 20;
    [self.bottomStr drawInRect:CGRectMake(self.paddingLeft, rect.size.height - textHeight, rect.size.width - self.paddingLeft * 2, 20480) withFont:[UIFont systemFontOfSize:14]];
}

@end
