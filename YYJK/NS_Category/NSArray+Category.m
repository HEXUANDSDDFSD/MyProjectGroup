//
//  NSArray+Category.m
//  tysx
//
//  Created by zwc on 14-7-1.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)

- (NSNumber *)maxValue {
    NSArray *sortArr = [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return  NSOrderedAscending;
        }
        else {
            return  NSOrderedDescending;
        }
        
    }];
    return [sortArr lastObject];
}


- (NSNumber *)minValue {
    NSArray *sortArr = [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return  NSOrderedAscending;
        }
        else {
            return  NSOrderedDescending;
        }
        
    }];
    return [sortArr firstObject];
}

- (CGFloat)maxFloatValue {
    NSArray *sortArr = [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return  NSOrderedAscending;
        }
        else {
            return  NSOrderedDescending;
        }
        
    }];
    return [[sortArr lastObject] floatValue];
}


- (CGFloat)minFloatValue {
    NSArray *sortArr = [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return  NSOrderedAscending;
        }
        else {
            return  NSOrderedDescending;
        }
        
    }];
    return [[sortArr firstObject] floatValue];
}

@end
