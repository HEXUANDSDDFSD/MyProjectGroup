//
//  UIColor+category.m
//  tysx
//
//  Created by zwc on 13-11-25.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "UIColor+category.h"

@implementation UIColor (category)

- (BOOL)isClearColor {
   const CGFloat* components =CGColorGetComponents(self.CGColor);
    for (int i = 0; i < 4 ; i++) {
        if (components[i] > 0.000001) {
            return NO;
        }
    }
    return YES;
}

+ (UIColor *)grayColorWithGrayDegree:(CGFloat)degree {
    return [UIColor colorWithRed:degree green:degree blue:degree alpha:1.0];
}

+ (UIColor *)lightBlueColor {
    return [UIColor colorWithRed:51/255.0 green:176/255.0 blue:195/255.0 alpha:1];
}

+ (UIColor *)solidColorWithHue:(CGFloat) hue alpha:(CGFloat)alpha {
    return [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:alpha];
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
