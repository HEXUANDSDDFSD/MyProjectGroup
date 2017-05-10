//
//  MEDragSegmentedControl.m
//  tysx
//
//  Created by zwc on 14/12/5.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "MEDragSegmentedControl.h"

#define IsNewVersion 1

@interface MEDragSegmentedControl()<UIScrollViewDelegate>

@end

@implementation MEDragSegmentedControl {
    UIScrollView *scrollView;
    NSInteger _selectedIndex;
    NSArray *_itemTitles;
    ShowOrientation _orientation;
}
@synthesize everyHeight;
@synthesize normalColor;
@synthesize selectedColor;
@synthesize normalFont;
@synthesize selectedFont;
@synthesize everyWidth;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [self addSubview:scrollView];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        [scrollView locationAtSuperView:self edgeInsets:UIEdgeInsetsZero];
        
        normalFont = [UIFont systemFontOfSize:16];
        selectedFont = [UIFont systemFontOfSize:18];
        normalColor = [UIColor grayColor];
        selectedColor = [UIColor blueColor];
        
        everyHeight = 62;
        everyWidth = 60;
        self.orientation = ShowOrientation_Vertical;
        //[self.layer addSublayer:gradientLayer];
        
    }
    return self;
}

- (void)setOrientation:(ShowOrientation)orientation {
        _orientation = orientation;
        
        if (IsNewVersion) {
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = self.bounds;
            gradientLayer.colors = @[(id)[[UIColor grayColor] colorWithAlphaComponent:0.1],(id)[UIColor grayColor].CGColor, (id)[[UIColor grayColor] colorWithAlphaComponent:0.1]];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.locations = @[@0.0, @0.5, @1.0];
            
            if (_orientation == ShowOrientation_Vertical) {
                gradientLayer.endPoint = CGPointMake(0, 1);
            }
            else {
                gradientLayer.endPoint = CGPointMake(1, 0);
            }
            self.layer.mask = gradientLayer;
            //[self.layer addSublayer:gradientLayer];
        }
        else {
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, 0, 20, 0));
            gradientLayer.colors = @[(id)[UIColor grayColor].CGColor, (id)[[UIColor grayColor] colorWithAlphaComponent:0.4]];
            gradientLayer.startPoint = CGPointMake(0, 0);
            
            if (_orientation == ShowOrientation_Vertical) {
                gradientLayer.endPoint = CGPointMake(0, 0.8);
            }
            else {
                gradientLayer.endPoint = CGPointMake(1, 0);
            }
            self.layer.mask = gradientLayer;
        }
        [self refreshLabel];
}

- (ShowOrientation)orientation {
    return _orientation;
}

- (NSString *)selectedTitle {
    NSString *ret = @"";
    if (_selectedIndex >= 0 && _selectedIndex <= [self.itemTitles count] - 1) {
        ret = self.itemTitles[_selectedIndex];
    }
    return ret;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
}

- (NSInteger)selectedIndex {
    return _selectedIndex;
}

- (void)refreshLabel {
    for (UIView *view in [scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    if (IsNewVersion) {
        CGFloat offsetTop = self.height / 2 - everyHeight / 2;
        CGFloat offsetLeft = self.width / 2 - everyWidth / 2;
        for (int i = 0; i < [_itemTitles count]; i++) {
            UIButton *button = nil;
            if (_orientation == ShowOrientation_Vertical) {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, offsetTop, self.width, everyHeight);
                offsetTop += everyHeight;
            }
            else {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(offsetLeft, 0, everyWidth, self.height);
                offsetLeft += everyWidth;
            }
            [scrollView addSubview:button];
            button.tag = i;
            [button addTarget:self action:@selector(touchChoose:) forControlEvents:UIControlEventTouchDown];
            [button setTitle:_itemTitles[i] forState:UIControlStateNormal];
            
            if (i == 0) {
                [button setTitleColor:selectedColor forState:UIControlStateNormal];
                button.titleLabel.font = selectedFont;
            }
            else {
                [button setTitleColor:normalColor forState:UIControlStateNormal];
                button.titleLabel.font = normalFont;
            }
        }
        
        if (_orientation == ShowOrientation_Vertical) {
            scrollView.contentSize = CGSizeMake(self.width, offsetTop + self.height / 2 - everyHeight / 2);
        }
        else {
            scrollView.contentSize = CGSizeMake(offsetLeft + self.width / 2 - everyWidth / 2, self.height);
        }
    }
    else {
        CGFloat offsetTop = everyHeight;
        CGFloat offsetLeft = everyWidth;
        for (int i = 0; i < [_itemTitles count]; i++) {
            UIButton *button = nil;
            if (_orientation == ShowOrientation_Vertical) {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, offsetTop, self.width, everyHeight);
                offsetTop += everyHeight;
            }
            else {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(offsetLeft, 0, everyWidth, self.height);
                offsetLeft += everyWidth;
            }
            [scrollView addSubview:button];
            button.tag = i;
            [button addTarget:self action:@selector(touchChoose:) forControlEvents:UIControlEventTouchDown];
            [button setTitle:_itemTitles[i] forState:UIControlStateNormal];
            
            if (i == 0) {
                [button setTitleColor:selectedColor forState:UIControlStateNormal];
                button.titleLabel.font = selectedFont;
            }
            else {
                [button setTitleColor:normalColor forState:UIControlStateNormal];
                button.titleLabel.font = normalFont;
            }
        }
        
        if (_orientation == ShowOrientation_Vertical) {
            scrollView.contentSize = CGSizeMake(self.width, offsetTop + self.height - everyHeight * 2);
        }
        else {
            scrollView.contentSize = CGSizeMake(offsetLeft + self.width - everyWidth * 2, self.height);
        }
    }
}

- (void)touchChoose:(UIButton *)sender {
    if (sender.tag == _selectedIndex) {
        return;
    }
    
    if (_orientation == ShowOrientation_Vertical) {
        [scrollView setContentOffset:CGPointMake(0, sender.tag * everyHeight) animated:YES];
    }
    else {
        [scrollView setContentOffset:CGPointMake(sender.tag * everyWidth, 0) animated:YES];
    }
   // [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setItemTitles:(NSArray *)itemTitles {
    _itemTitles = itemTitles;
    [self refreshLabel];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_ {
    
    NSInteger index = 0;
    
    if (_orientation == ShowOrientation_Vertical) {
        index = (scrollView.contentOffset.y) / everyHeight;
    }
    else {
        index = (scrollView.contentOffset.x) / everyWidth;
    }
    if (index < 0 || index >= [self.itemTitles count]) {
        return;
    }
    if (index != _selectedIndex) {
        _selectedIndex = index;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        for (UIView *view in [scrollView subviews]) {
            if (![view isKindOfClass:[UIButton class]]) {
                return;
            }
            UIButton *button = (UIButton *)view;
            if (view.tag == _selectedIndex) {
                [button setTitleColor:selectedColor forState:UIControlStateNormal];
                button.titleLabel.font = selectedFont;
            }
            else {
                [button setTitleColor:normalColor forState:UIControlStateNormal];
                button.titleLabel.font = normalFont;
            }
        }
    }
}

//- (void)resetLocationWithIndex:(NSInteger)index {
//    if (_orientation == ShowOrientation_Vertical) {
//        [scrollView setContentOffset:CGPointMake(0, self.height / 2 - everyHeight / 2 + everyHeight * index)];
//    }
//    else {
//        [scrollView setContentOffset:CGPointMake(self.width / 2 - everyWidth / 2 + everyWidth * index, 0)];
//    }
//}

//- (NSInteger)estimateSelectedIndex {
//    NSInteger index = 0;
//    if (_orientation == ShowOrientation_Vertical) {
//        index = (scrollView.contentOffset.y) / everyHeight;
//        [scrollView setContentOffset:CGPointMake(0, index * everyHeight) animated:YES];
//    }
//    else {
//        index = (scrollView.contentOffset.x) / everyWidth;
//        [scrollView setContentOffset:CGPointMake(index * everyWidth, 0) animated:YES];
//    }
//    return index;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_ {
    NSInteger index = 0;
    if (_orientation == ShowOrientation_Vertical) {
        index = (scrollView.contentOffset.y) / everyHeight;
        [scrollView setContentOffset:CGPointMake(0, index * everyHeight) animated:YES];
    }
    else {
        index = (scrollView.contentOffset.x) / everyWidth;
        [scrollView setContentOffset:CGPointMake(index * everyWidth, 0) animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView_ willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        NSInteger index = 0;
        if (_orientation == ShowOrientation_Vertical) {
            index = (scrollView.contentOffset.y) / everyHeight;
            [scrollView setContentOffset:CGPointMake(0, index * everyHeight) animated:YES];
        }
        else {
            index = (scrollView.contentOffset.x) / everyWidth;
            [scrollView setContentOffset:CGPointMake(index * everyWidth, 0) animated:YES];
        }
    }
}

@end
