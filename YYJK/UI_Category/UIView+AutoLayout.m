//
//  UIView+AutoLayout.m
//  MyNewsstandApplication
//
//  Created by zwc on 14-10-3.
//  Copyright (c) 2014年 MYSTERIOUS. All rights reserved.
//

#import "UIView+AutoLayout.h"
#import <objc/runtime.h>

@implementation UIView (AutoLayout)

- (NSLayoutConstraint *)layoutConstraintEqualWidthOfView:(UIView *)view constant:(CGFloat)c {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:c];
}

- (NSLayoutConstraint *)layoutConstraintEqualHeightOfView:(UIView *)view constant:(CGFloat)c {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1 constant:c];
}

- (NSLayoutConstraint *)layoutConstraintCenterXInView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return  [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
}

- (NSLayoutConstraint *)layoutConstraintCenterYInView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    return  [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
}


- (void)locationAtSuperView:(UIView *)superView edgeInsets:(UIEdgeInsets)edgeInsets{
    if (![self.superview isEqual:superView]) {
        NSLog(@"superView 参数 不是 当前View 的父视图");
        return;
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableArray *layouts = [NSMutableArray array];
    [layouts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[self]-%f-|", edgeInsets.left, edgeInsets.right] options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    [layouts addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[self]-%f-|", edgeInsets.top, edgeInsets.bottom]  options:NSLayoutFormatAlignAllLeft metrics:nil views:NSDictionaryOfVariableBindings(self)]];
    [superView addConstraints:layouts];
}

@end
