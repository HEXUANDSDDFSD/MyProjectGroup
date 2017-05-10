//
//  HXChartDataSimpleCell.m
//  tysx
//
//  Created by zwc on 13-11-25.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXChartDataSimpleCell.h"
#import "MYDrawContentView.h"

@interface HXChartDataSimpleCell()<MYDrawContentViewDrawDelegate>

@end

@implementation HXChartDataSimpleCell {
    MYDrawContentView *drawView;
}
@synthesize unusualNumber;
@synthesize index;
@synthesize unusualRate;

@synthesize dayStr;
@synthesize isIncrease;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        drawView = [[MYDrawContentView alloc] initWithFrame:CGRectMake(5, 0, self.contentView.bounds.size.width - 5 * 2, self.contentView.bounds.size.height)];
        drawView.drawDelegate = self;
        [self.contentView addSubview:drawView];
    }
    return self;
}

- (void)setIndex:(int)index_ {
    index = index_;
    if (index % 2 == 0) {
        drawView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    }
    else {
        drawView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setIsIncrease:(BOOL)isIncrease_ {
    isIncrease = isIncrease_;
    if (isIncrease) {
        drawView.backgroundColor = [UIColor whiteColor];
    }
    else {
        drawView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    }
}

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    [[UIColor darkGrayColor] set];
    CGFloat offsetTop = 10;
    
    [dayStr drawAtPoint:CGPointMake(15, offsetTop) withFont:[UIFont boldSystemFontOfSize:14]];
    
    
    [[NSString stringWithFormat:@"%d", unusualNumber] drawInRect:CGRectMake(400, offsetTop, 300, 16) withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *fillColor = nil;
    fillColor = isIncrease ? kFreshGreenColor : [UIColor redColor];
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, CGRectMake(730, (rect.size.height - 15) / 2, 220 * unusualRate, 15));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
