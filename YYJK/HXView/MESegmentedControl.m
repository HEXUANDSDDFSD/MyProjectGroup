//
//  MESegmentedControl.m
//  tysx
//
//  Created by zwc on 14/11/25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "MESegmentedControl.h"

@implementation MESegmentedControl {
    NSMutableArray *itemWidths;
    NSMutableArray *titles;
   CGFloat _itemHeight;
    UIFont *_font;
    UIColor *_borderColor;
    UIColor *_normalTitleColor;
    UIColor *_selectedTitleColor;
    UIColor *_normalBgColor;
    UIColor *_seletedBgColor;
    NSInteger _selectedIndex;
    NSMutableArray *buttonItems;
}

- (id)initWithFrame:(CGRect)frame {
    return nil;
}

- (id)initWithTitle:(NSArray *)titles_ {
    if ([titles_ count] < 2) {
        return nil;
    }
    if (self = [super initWithFrame:CGRectZero]) {
        buttonItems = [NSMutableArray array];
        titles = [titles_ mutableCopy];
        _font = [UIFont systemFontOfSize:18];
        _borderColor = [UIColor blueColor];
        _selectedTitleColor = [UIColor whiteColor];
        _normalTitleColor = [UIColor blueColor];
        _normalBgColor = [UIColor whiteColor];
        _seletedBgColor = [UIColor blueColor];
        _itemHeight = 30;
        itemWidths = [NSMutableArray array];
        for (int i = 0; i < [titles count]; i++) {
            [itemWidths addObject:@60.0];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self changeFrame];
    [self addSubButton];
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
}

- (void)setEveryWidth:(CGFloat)everyWidth {
    [itemWidths removeAllObjects];
    for (int i = 0; i < [titles count]; i++) {
        [itemWidths addObject:[NSNumber numberWithFloat:everyWidth]];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex) {
        UIButton *selectedButton = buttonItems[_selectedIndex];
        [self selectButton:selectedButton];
    }
}

- (NSInteger)selectedIndex {
    return _selectedIndex;
}

- (void)setFont:(UIFont *)font {
    _font = font;
}

- (UIFont *)font {
    return _font;
}

- (void)setItemHeight:(CGFloat)itemHeight {
    _itemHeight = itemHeight;
}

- (CGFloat)itemHeight {
    return _itemHeight;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
}

- (UIColor *)borderColor {
    return _borderColor;
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor {
    _normalTitleColor = normalTitleColor;
}

- (UIColor *)normalTitleColor {
    return _normalTitleColor;
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
}

- (UIColor *)selectedTitleColor {
    return _selectedTitleColor;
}

- (void)setNormalBgColor:(UIColor *)normalBgColor {
    _normalTitleColor = normalBgColor;
}

- (UIColor *)normalBgColor {
    return _normalTitleColor;
}

- (void)setSeletedBgColor:(UIColor *)seletedBgColor {
    _seletedBgColor = seletedBgColor;
}

- (UIColor *)seletedBgColor {
    return _seletedBgColor;
}
    

- (void)changeFrame {
    CGFloat sumWidth = 0;
    for (int i = 0; i < [titles count]; i++) {
        sumWidth += [[itemWidths objectAtIndex:i] floatValue];
    }
    self.frame = CGRectMake(self.x, self.y, sumWidth, _itemHeight);
}

- (void)addSubButton {
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    [buttonItems removeAllObjects];
    CGFloat offsetLeft = 0;
    for (int i = 0; i < [titles count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = _font;
        [button addTarget:self action:@selector(changeSelectedItemAction:) forControlEvents:UIControlEventTouchDown];
        button.frame = CGRectMake(offsetLeft, 0, [[itemWidths objectAtIndex:i] floatValue], _itemHeight);
        [self addSubview:button];
        [button setTitleColor:_normalTitleColor forState:UIControlStateNormal];
        [button setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
        if (i % 2 == 1) {
            button.layer.borderColor = _borderColor.CGColor;
            button.layer.borderWidth = 1;
        }
        if (i == _selectedIndex) {
            button.userInteractionEnabled = NO;
            button.selected = YES;
            button.backgroundColor = _seletedBgColor;
        }
        else {
            button.backgroundColor = _normalBgColor;
        }
        [buttonItems addObject:button];
        offsetLeft += [[itemWidths objectAtIndex:i] floatValue];
    }
}

- (void)selectButton:(UIButton *)button {
    UIButton *originSelectBtn = buttonItems[_selectedIndex];
    originSelectBtn.userInteractionEnabled = YES;
    originSelectBtn.backgroundColor = _normalBgColor;
    originSelectBtn.selected = NO;
    
    button.userInteractionEnabled = NO;
    button.backgroundColor = _seletedBgColor;
    button.selected = YES;
    _selectedIndex = [buttonItems indexOfObject:button];
}

- (void)changeSelectedItemAction:(UIButton *)sender {
    [self selectButton:sender];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
