//
//  HXSegmentedControl.m
//  MeasureTool
//
//  Created by zwc on 14-6-13.
//  Copyright (c) 2014年 MYSTERIOUS. All rights reserved.
//

#import "HXSegmentedControl.h"

#define kItemBaseTag 1000

@implementation HXSegmentedControl {
    NSArray *items;
    int _currentIndex;
}

@synthesize itemWidth;
@synthesize itemHeight;
@synthesize currentIndex;
@synthesize font;
@synthesize delegate;
@synthesize selectedColor;

- (id)initWithItems:(NSArray *)_items{
    if (self = [super initWithFrame:CGRectMake(0, 0, 0, 1)]) {
        if ([_items count] <= 1) {
            return nil;
        }
        self.selectedColor = kFreshBlueColor;
        self.selectedTitleColor = kDefaultTextColor;
        self.normalColor = kDefaultTextColor;
        self.normalTitleColor = kFreshBlueColor;
        items = _items;
    }
    return self;
}

- (void)setCurrentIndex:(int)currentIndex_ {
    if (currentIndex >= [items count] || currentIndex_ == _currentIndex) {
        return;
    }
    UIButton *oriBtn = (UIButton *)[self viewWithTag:_currentIndex + kItemBaseTag];
    UIButton *currentBtn = (UIButton *)[self viewWithTag:currentIndex_ + kItemBaseTag];
    [self modifyPropertyWithButton:oriBtn isSelected:NO];
    [self modifyPropertyWithButton:currentBtn isSelected:YES];
    _currentIndex = currentIndex_;
}

- (int)currentIndex {
    return _currentIndex;
}

- (void)setItemHeight:(CGFloat)_itemHeight {
    itemHeight = _itemHeight;
    self.bounds = CGRectMake(0, 0, itemWidth * [items count], itemHeight);
}

- (void)setItemWidth:(CGFloat)_itemWidth {
    itemWidth = _itemWidth;
    self.bounds = CGRectMake(0, 0, itemWidth * [items count], itemHeight);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self viewWithTag:kItemBaseTag] == nil) {
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;

        for (int i = 0; i < [items count]; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = kItemBaseTag + i;
            button.titleLabel.font = font;
            
            if (self.needBorder) {
                button.layer.borderColor = selectedColor.CGColor;
                button.layer.borderWidth = 1;
            }
            [button setTitle:items[i] forState:UIControlStateNormal];
            button.frame = CGRectMake(i * itemWidth, 0, itemWidth, itemHeight);
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:button];
            
            if (currentIndex == i) {
                [self modifyPropertyWithButton:button isSelected:YES];
            }
            else {
               [self modifyPropertyWithButton:button isSelected:NO];
            }
            
            if (self.needBorder) {
                CALayer *borderLayer = [CALayer layer];
                borderLayer.frame = CGRectInset(self.bounds, 0, 0);
                borderLayer.borderColor = self.selectedColor.CGColor;
                borderLayer.borderWidth = 1;
                borderLayer.cornerRadius = self.layer.cornerRadius;
                [self.layer addSublayer:borderLayer];
            }
        }
    }
}

- (void)modifyPropertyWithButton:(UIButton *)button isSelected :(BOOL)isSelected {
    if (isSelected) {
        [button setBackgroundColor:self.selectedColor];
        [button setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
        button.userInteractionEnabled = NO;
    }
    else {
        [button setBackgroundColor:self.normalColor];
        button.userInteractionEnabled = YES;
        [button setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
    }
}

- (void)buttonAction:(UIButton *)sender {
    UIButton *button = (UIButton *)[self viewWithTag:_currentIndex + kItemBaseTag];
    [self modifyPropertyWithButton:sender isSelected:YES];
    [self modifyPropertyWithButton:button isSelected:NO];
    _currentIndex = (int)sender.tag - kItemBaseTag;
    
    if ([delegate respondsToSelector:@selector(segmentedControlValueChanged:)]) {
        [delegate segmentedControlValueChanged:self];
    }
}

@end
