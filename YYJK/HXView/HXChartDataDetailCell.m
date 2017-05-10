//
//  HXChartDataDetailCell.m
//  tysx
//
//  Created by zwc on 13-11-25.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXChartDataDetailCell.h"
#import "MYDrawContentView.h"

@interface HXChartDataDetailCell()<MYDrawContentViewDrawDelegate>

@end

@implementation HXChartDataDetailCell {
    MYDrawContentView *drawView;
}

@synthesize currentValue;
@synthesize compareValue;
@synthesize typeIndex;
@synthesize isSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        drawView = [[MYDrawContentView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
        drawView.drawDelegate = self;
        [self.contentView addSubview:drawView];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected_ {
    isSelected = isSelected_;
    if (isSelected) {
        drawView.backgroundColor = [UIColor whiteColor];
    }
    else {
        drawView.backgroundColor = [UIColor colorWithRed:171/255.0 green:174/255.0 blue:179/255.0 alpha:1];
    }
    [drawView setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    drawView.frame = CGRectMake(5, 0, self.contentView.bounds.size.width - 5 * 2, self.contentView.bounds.size.height);
}

- (NSString *)typeName{
    NSString *ret = nil;
    switch (typeIndex) {
        case 0:
            ret = @"订购数同环比上升下降";
            break;
        case 1:
            ret = @"退订数同环比上升下降";
            break;
        case 2:
            ret = @"点播流量同环比上升下降";
            break;
            
        default:
            break;
    }
    
    return ret;
}

//- (void)setIsIncrease:(BOOL)isIncrease_ {
////    isIncrease = isIncrease_;
////    if (isIncrease) {
////        drawView.backgroundColor = [UIColor colorWithRed:171/255.0 green:174/255.0 blue:179/255.0 alpha:1];
////    }
////    else {
////        drawView.backgroundColor = [UIColor whiteColor];
////    }
//}

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    int offsetTop = 12;
    int offsetLeft = 13;
    int drawWidth = (rect.size.width - offsetLeft * 3) / 2;
    
    NSString *unitStr = self.unitStr;
    if (unitStr == nil) {
        unitStr = @"";
    }
    
    NSString *drawValueStr = nil;
    
    [[UIColor darkGrayColor] set];
    [@"当前" drawAtPoint:CGPointMake(offsetLeft, offsetTop + 4) withFont:[UIFont systemFontOfSize:15]];
//    if (currentValue <= compareValue) {
//        [[UIColor redColor] set];
//    }
//    else {
//        [kFreshGreenColor set];
//    }
    
    if (self.needChangeBigUnit) {
        drawValueStr = [NSString stringWithFormat:@"%.2f%@", currentValue / 1024.0 / 1024, unitStr];
    }
    else {
        drawValueStr = [NSString stringWithFormat:@"%lld%@", currentValue, unitStr];
    }
    
    [drawValueStr drawInRect:CGRectMake(offsetLeft, offsetTop, drawWidth, 24) withFont:[UIFont systemFontOfSize:20] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    offsetTop += 26;
    NSString *compareTitle = nil;
    if (typeIndex % 2 == 0) {
        compareTitle = @"上周";
    }
    else {
        compareTitle = @"昨日";
    }
    [[UIColor darkGrayColor] set];
    [@"上周" drawAtPoint:CGPointMake(offsetLeft, offsetTop + 4) withFont:[UIFont systemFontOfSize:15]];
    
    [@"昨日" drawAtPoint:CGPointMake(offsetLeft + drawWidth + offsetLeft, offsetTop + 4) withFont:[UIFont systemFontOfSize:15]];
    
    isSelected ? [[UIColor darkGrayColor] set] : [[UIColor whiteColor] set];
    
    if (self.needChangeBigUnit) {
        drawValueStr = [NSString stringWithFormat:@"%.2f%@", self.weakCompareValue / 1024.0 / 1024, unitStr];
    }
    else {
        drawValueStr = [NSString stringWithFormat:@"%lld%@", self.weakCompareValue, unitStr];
    }
    [drawValueStr drawInRect:CGRectMake(offsetLeft, offsetTop, drawWidth, 24) withFont:[UIFont systemFontOfSize:20] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    if (self.needChangeBigUnit) {
        drawValueStr = [NSString stringWithFormat:@"%.2f%@", self.dayCompareValue / 1024.0 / 1024, unitStr];
    }
    else {
        drawValueStr = [NSString stringWithFormat:@"%lld%@", self.dayCompareValue, unitStr];
    }
    
    [drawValueStr drawInRect:CGRectMake(offsetLeft + drawWidth + offsetLeft, offsetTop, drawWidth, 24) withFont:[UIFont systemFontOfSize:20] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    offsetTop += 26;
    if (currentValue <= self.weakCompareValue) {
        [[UIColor redColor] set];
    }
    else {
        [kFreshGreenColor set];
    }
    [[self rateStrWithCompareValue:self.weakCompareValue] drawInRect:CGRectMake(offsetLeft, offsetTop, drawWidth, 24) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    if (currentValue <= self.dayCompareValue) {
        [[UIColor redColor] set];
    }
    else {
        [kFreshGreenColor set];
    }
    [[self rateStrWithCompareValue:self.dayCompareValue] drawInRect:CGRectMake(offsetLeft + offsetLeft + drawWidth, offsetTop, drawWidth, 24) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    offsetTop += 40;
    isSelected ? [[UIColor darkGrayColor] set] : [[UIColor whiteColor] set];
    [[self typeName] drawInRect:CGRectMake(0, offsetTop, rect.size.width, 24) withFont:[UIFont systemFontOfSize:15] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
}

- (NSString *)rateStrWithCompareValue:(long long)value {
    NSString *ret = nil;
    
    if (currentValue == value) {
        ret = @"0.00%";
    }
    else if (currentValue != 0 && value == 0) {
        ret = @"";
    }
    else if (currentValue > value) {
        CGFloat rate = (currentValue - value) * 100.0 / value;
        ret = [@"+ " stringByAppendingFormat:@"%0.2f%%", rate];
    }
    else {
        CGFloat rate = (value - currentValue) * 100.0 / value;
        ret = [@"- " stringByAppendingFormat:@"%0.2f%%", rate];
    }
    
    return  ret;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
