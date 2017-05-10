//
//  NSNumber+Format.m
//  tysx
//
//  Created by zwc on 13-11-15.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "NSNumber+Format.h"

@implementation NSNumber (Format)

- (NSString *)dollarFormatStr{
    int originalNumber = [self intValue];
    BOOL isNegative = NO;
    if (originalNumber < 0) {
        originalNumber *= -1;
        isNegative = YES;
    }
    
    __autoreleasing NSMutableString *ret = [[NSMutableString alloc] init];
    if (isNegative) {
        [ret appendString:@"-"];
    }
    
    [ret appendString:@"$"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [ret appendString:[formatter stringFromNumber:[NSNumber numberWithInt:originalNumber]]];
    return ret;
}

@end
