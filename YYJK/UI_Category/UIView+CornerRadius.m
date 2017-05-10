//
//  UIView+CornerRadius.m
//  tysx
//
//  Created by zwc on 14-4-2.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)

- (UIImage *)snapshotImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale); //currentView 当前的view
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

- (void)setCornerRadiusWithCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRdii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRdii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
