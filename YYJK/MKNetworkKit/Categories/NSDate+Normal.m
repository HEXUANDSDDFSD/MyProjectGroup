//
//  NSDate+Normal.m
//  tysx
//
//  Created by zwc on 14/12/17.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "NSDate+Normal.h"

@implementation NSDate (Normal)

+ (NSDate *)dateWithDateString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [dateFormat dateFromString:dateString];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:self];
}

- (NSInteger)week {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:self];
    return [comps weekday];
}

- (NSDate *)dateWithNumberOfDayBefore:(NSInteger)numberOfDay {
    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    timeInterval -= numberOfDay * 24 * 3600;
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

- (NSString *)weekStr {
    NSString *ret = nil;
    switch ([self week]) {
        case 1:
            ret = @"周日";
            break;
        case 2:
            ret = @"周一";
            break;
        case 3:
            ret = @"周二";
            break;
        case 4:
            ret = @"周三";
            break;
        case 5:
            ret = @"周四";
            break;
        case 6:
            ret = @"周五";
            break;
        case 7:
            ret = @"周六";
            break;
            
        default:
            break;
    }
    return ret;
}

@end
