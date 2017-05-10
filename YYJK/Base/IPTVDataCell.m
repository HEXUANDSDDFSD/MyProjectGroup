//
//  IPTVDataCell.m
//  tysx
//
//  Created by zwc on 14/10/23.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "IPTVDataCell.h"
#import "MYDrawContentView.h"

@interface IPTVDataCell()<MYDrawContentViewDrawDelegate>

@end

@implementation IPTVDataCell {
    MYDrawContentView *drawView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        drawView = [[MYDrawContentView alloc] initWithFrame:CGRectZero];
        drawView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
        drawView.drawDelegate = self;
        [self.contentView addSubview:drawView];
        [drawView locationAtSuperView:self.contentView edgeInsets:UIEdgeInsetsZero];
    }
    return self;
}

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    
    CGFloat offsetTop = 12;
    CGFloat offsetLeft = 20;
    CGFloat intervalY = 12;
    
    drawLineText(CGPointMake(offsetLeft, offsetTop), @[@"当月用户数: 1667504户"], @[[UIColor grayColor]], @[[UIFont systemFontOfSize:20]]);
    
    offsetTop += 20 + intervalY;
    
    drawLineText(CGPointMake(offsetLeft, offsetTop), @[@"同比增长:", @" ↑ ", @"+0.3%"], @[[UIColor grayColor], [UIColor colorWithHexString:@"3ed43a"], [UIColor colorWithHexString:@"3ed43a"]], @[[UIFont systemFontOfSize:20], [UIFont systemFontOfSize:20], [UIFont systemFontOfSize:30]]);
    
    offsetTop += 20 + intervalY + 7;
    
    drawLineText(CGPointMake(offsetLeft, offsetTop), @[@"环比增长:", @" ↓ ", @"-0.3%"], @[[UIColor grayColor], [UIColor colorWithHexString:@"fa6060"], [UIColor colorWithHexString:@"fa6060"]], @[[UIFont systemFontOfSize:20], [UIFont systemFontOfSize:20], [UIFont systemFontOfSize:30]]);
}

@end
