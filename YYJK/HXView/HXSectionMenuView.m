//
//  HXSectionMenuView.m
//  tysx
//
//  Created by zwc on 13-12-17.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXSectionMenuView.h"

#define kSectionBaseTag 1000
#define kRowBaseTag 2000

@implementation HXSectionMenuView {
    NSInteger selectedSection;
    NSInteger selectedRow;
    CGFloat rowOffsetLeft;
}
@synthesize dataSource;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews {
    [self reloadSubView];
}

- (void)reloadSubView {
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    CGFloat offsetLeft = 63;
    CGFloat offsetTop = 19;
    CGFloat paddingX = 10;
    CGFloat paddingY = 5;
    CGFloat intervalX = 15;
    NSInteger sectionNum = 0;
    UIFont *titleFont = [UIFont systemFontOfSize:16];
    if ([dataSource respondsToSelector:@selector(numberOfSectionsInSectionMenuView:)]) {
        sectionNum = [dataSource numberOfSectionsInSectionMenuView:self];
    }
    for (NSInteger i = 0; i < sectionNum; i++) {
        NSString *title = nil;
        if ([dataSource respondsToSelector:@selector(sectionMenuView:titleInSection:)]) {
            title = [dataSource sectionMenuView:self titleInSection:i];
        }
        CGSize titleSize = [title sizeWithFont:titleFont];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offsetLeft, offsetTop, titleSize.width + 2 * paddingX, titleSize.height + 2 * paddingY)];
        button.tag = kSectionBaseTag + i;
        button.backgroundColor = i == selectedSection ? kFreshBlueColor : [UIColor clearColor];
        button.titleLabel.font = titleFont;
        [button addTarget:self action:@selector(changeSectionAction:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor: (i == selectedSection ? [UIColor whiteColor] : [UIColor grayColorWithGrayDegree:132 /255.0]) forState:UIControlStateNormal];
        [self addSubview:button];
        
        if (button.tag == selectedSection + kSectionBaseTag) {
            button.userInteractionEnabled = NO;
           // rowOffsetLeft = offsetLeft;
        }
        
        offsetLeft += button.bounds.size.width + intervalX;
    }
    [self reloadRowSubView];
}

- (void)changeSectionAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:kFreshBlueColor];
    
    UIButton *button = (UIButton *)[self viewWithTag:selectedSection + kSectionBaseTag];
    if ([button isKindOfClass:[UIButton class]]) {
        button.userInteractionEnabled = YES;
        [button setTitleColor:[UIColor grayColorWithGrayDegree:132 /255.0] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
    }
    selectedSection = sender.tag - kSectionBaseTag;
    rowOffsetLeft = sender.frame.origin.x;
    
    selectedRow = 0;
    [self reloadRowSubView];
    if ([delegate respondsToSelector:@selector(sectionMenuView:didSelectRowAtIndexPath:)]) {
        [delegate sectionMenuView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:selectedSection]];
    }
}

- (void)changeRowAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:kFreshBlueColor];
    
    UIButton *button = (UIButton *)[self viewWithTag:selectedRow + kRowBaseTag];
    if ([button isKindOfClass:[UIButton class]]) {
        button.userInteractionEnabled = YES;
        [button setTitleColor:[UIColor grayColorWithGrayDegree:132 /255.0] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
    }
    selectedRow = sender.tag - kRowBaseTag;
    if ([delegate respondsToSelector:@selector(sectionMenuView:didSelectRowAtIndexPath:)]) {
        [delegate sectionMenuView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:selectedSection]];
    }
}

- (void)reloadRowSubView {
    for (UIView *view in [self subviews]) {
        if (view.tag >= kRowBaseTag) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat offsetTop = 57;
    CGFloat paddingX = 10;
    CGFloat paddingY = 5;
    CGFloat intervalX = 15;
    NSInteger sectionNum = 0;
    CGFloat offsetLeft = 63;
    
    UIFont *titleFont = [UIFont systemFontOfSize:16];
    if ([dataSource respondsToSelector:@selector(sectionMenuView:numberOfRowsInSection:)]) {
        sectionNum = [dataSource sectionMenuView:self numberOfRowsInSection:selectedSection];
    }

    for (NSInteger i = 0; i < sectionNum; i++) {
        NSString *title = nil;
        if ([dataSource respondsToSelector:@selector(sectionMenuView:titleForRowAtIndexPath:)]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:selectedSection];
            title = [dataSource sectionMenuView:self titleForRowAtIndexPath:indexPath];
        }
        CGSize titleSize = [title sizeWithFont:titleFont];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offsetLeft, offsetTop, titleSize.width + 2 * paddingX, titleSize.height + 2 * paddingY)];
        button.tag = kRowBaseTag + i;
        button.backgroundColor = i == selectedRow ? kFreshBlueColor : [UIColor clearColor];
        button.titleLabel.font = titleFont;
        [button addTarget:self action:@selector(changeRowAction:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor: (i == selectedRow ? [UIColor whiteColor] : [UIColor grayColorWithGrayDegree:132 /255.0]) forState:UIControlStateNormal];
        [self addSubview:button];
        if (button.tag == selectedRow + kRowBaseTag) {
            button.userInteractionEnabled = NO;
        }
        //offsetLeft += button.bounds.size.width + intervalX;
        offsetLeft += button.bounds.size.width + intervalX;
    }

}

@end
