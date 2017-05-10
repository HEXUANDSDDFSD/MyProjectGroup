//
//  UIView+AutoLayout.h
//  MyNewsstandApplication
//
//  Created by zwc on 14-10-3.
//  Copyright (c) 2014年 MYSTERIOUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)

- (NSLayoutConstraint *)layoutConstraintEqualWidthOfView:(UIView *)view constant:(CGFloat)c;
- (NSLayoutConstraint *)layoutConstraintEqualHeightOfView:(UIView *)view constant:(CGFloat)c;

- (NSLayoutConstraint *)layoutConstraintCenterXInView:(UIView *)view;
- (NSLayoutConstraint *)layoutConstraintCenterYInView:(UIView *)view;

- (void)locationAtSuperView:(UIView *)superView edgeInsets:(UIEdgeInsets)edgeInsets;

@end
