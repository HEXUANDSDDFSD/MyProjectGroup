//
//  NSString+Draw.h
//  tysx
//
//  Created by zwc on 13-11-28.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Draw)

- (void)drawCenterInRect:(CGRect )rect
                withFont:(UIFont *)font;

- (void)drawRotationAtPoint:(CGPoint )point
                   withFont:(UIFont *)font
                      angle:(CGFloat)angel;

@end
