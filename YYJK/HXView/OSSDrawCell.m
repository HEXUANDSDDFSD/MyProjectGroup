//
//  OSSDrawCell.m
//  tysx
//
//  Created by zwc on 14/11/17.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "OSSDrawCell.h"

@interface CellDrawView : UIView

@property (nonatomic, weak) OSSDrawCell *cell;

@end

@implementation CellDrawView
@synthesize cell;

- (void)drawRect:(CGRect)rect {
    if ([cell.drawDelegate respondsToSelector:@selector(drawCell:rect:)]) {
        [cell.drawDelegate drawCell:cell rect:rect];
    }
}

@end

@implementation OSSDrawCell {
    CellDrawView *drawView;
}
@synthesize drawDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        drawView = [[CellDrawView alloc] initWithFrame:CGRectZero];
        drawView.backgroundColor = [UIColor clearColor];
        drawView.cell = self;
        [self.contentView addSubview:drawView];
        [drawView locationAtSuperView:self.contentView edgeInsets:UIEdgeInsetsZero];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [drawView setNeedsDisplay];
    // Configure the view for the selected state
}

@end
