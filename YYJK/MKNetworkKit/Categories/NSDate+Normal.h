//
//  NSDate+Normal.h
//  tysx
//
//  Created by zwc on 14/12/17.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Normal)

+ (NSDate *)dateWithDateString:(NSString *)dateString format:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSInteger)week;
- (NSString *)weekStr;
- (NSDate *)dateWithNumberOfDayBefore:(NSInteger)numberOfDay;

@end
