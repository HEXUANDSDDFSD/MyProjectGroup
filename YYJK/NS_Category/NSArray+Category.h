//
//  NSArray+Category.h
//  tysx
//
//  Created by zwc on 14-7-1.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Category)

- (NSNumber *)maxValue;
- (NSNumber *)minValue;

- (CGFloat)maxFloatValue;
- (CGFloat)minFloatValue;

@end
