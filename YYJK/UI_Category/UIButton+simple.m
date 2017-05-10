//
//  UIButton+simple.m
//  tysx
//
//  Created by zwc on 13-11-5.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "UIButton+simple.h"

@implementation UIButton (simple)

- (void)setNormalStateBgImage:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setNormalStateTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setHighStateTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

@end
