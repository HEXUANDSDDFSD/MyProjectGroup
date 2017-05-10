//
//  UIColor+category.h
//  tysx
//
//  Created by zwc on 13-11-25.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (category)

- (BOOL)isClearColor;
+ (UIColor *)grayColorWithGrayDegree:(CGFloat)degree;
+ (UIColor *)lightBlueColor;
+ (UIColor *)solidColorWithHue:(CGFloat) hue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)color;

@end
