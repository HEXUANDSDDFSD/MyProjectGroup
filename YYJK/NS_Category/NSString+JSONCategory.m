//
//  NSString+JSONCategory.m
//  tysx
//
//  Created by zwc on 13-11-6.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "NSString+JSONCategory.h"

@implementation NSString (JSONCategory)

-(id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end
