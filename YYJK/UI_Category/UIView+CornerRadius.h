//
//  UIView+CornerRadius.h
//  tysx
//
//  Created by zwc on 14-4-2.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)

- (void)setCornerRadiusWithCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRdii;

- (UIImage *)snapshotImageWithSize:(CGSize)size;

@end
