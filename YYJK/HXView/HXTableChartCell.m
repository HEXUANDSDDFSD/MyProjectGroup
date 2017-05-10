//
//  HXTableChartCell.m
//  tysx
//
//  Created by zwc on 14-8-13.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXTableChartCell.h"

@interface HXTableChartDrawView : UIView

@property (nonatomic, weak) HXTableChartCell *cell;

@end

@implementation HXTableChartDrawView
@synthesize cell;

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSInteger numberOfColumn = 0;
    if ([cell.dataSource respondsToSelector:@selector(numberOfColumnInTableChartCell:)]) {
        numberOfColumn = [cell.dataSource numberOfColumnInTableChartCell:cell];
    }
    
    if ([cell.dataSource respondsToSelector:@selector(widthOfColumnInTableChartCell:atColumn:)] &&
        [cell.dataSource respondsToSelector:@selector(contentInTableChartCell:atColumn:)] &&
        [cell.dataSource respondsToSelector:@selector(fontOfColumnInTableChartCell:atColumn:)]) {
        CGFloat offsetLeft = cell.chartInsets.left;
        CGFloat columnWidth = 0;
        NSString *content = nil;
        UIFont *contentFont = nil;
        NSDictionary *attributes = [NSMutableDictionary dictionary];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
        
        for (NSInteger i = 0; i < numberOfColumn; i++) {
            columnWidth = [cell.dataSource widthOfColumnInTableChartCell:cell atColumn:i];
            content = [cell.dataSource contentInTableChartCell:cell atColumn:i];
            contentFont = [cell.dataSource fontOfColumnInTableChartCell:cell atColumn:i];
            
            [attributes setValue:contentFont forKey:NSFontAttributeName];
            
            CGContextStrokeRect(ctx, CGRectMake(offsetLeft, cell.chartInsets.top, columnWidth, rect.size.height - cell.chartInsets.top - cell.chartInsets.bottom));
            
            [content drawInRect:CGRectMake(offsetLeft, (self.bounds.size.height - cell.chartInsets.bottom - cell.chartInsets.top - contentFont.pointSize) / 2, columnWidth, contentFont.pointSize + 5) withAttributes:attributes];
            
            offsetLeft += columnWidth;
            
        }
    }
}

@end

@implementation HXTableChartCell {
    UIEdgeInsets _chartInsets;
    HXTableChartDrawView *drawView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        drawView = [[HXTableChartDrawView alloc] initWithFrame:self.contentView.bounds];
        drawView.cell = self;
        drawView.backgroundColor = [UIColor clearColor];
        drawView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:drawView];
    }
    return self;
}

- (UIEdgeInsets)chartInsets {
    return _chartInsets;
}

- (void)setChartInsets:(UIEdgeInsets)chartInsets {
    _chartInsets = chartInsets;
    [drawView setNeedsDisplay];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
