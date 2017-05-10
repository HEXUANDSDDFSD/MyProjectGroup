//
//  MESegmentedControl.h
//  tysx
//
//  Created by zwc on 14/11/25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MESegmentedControl : UIControl

- (id)initWithTitle:(NSArray *)titles;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat everyWidth;
@property (nonatomic, strong) UIColor *normalBgColor;
@property (nonatomic, strong) UIColor *seletedBgColor;
@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)setEveryWidth:(CGFloat)everyWidth;

@end
