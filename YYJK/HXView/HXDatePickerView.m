//
//  HXDatePickerView.m
//  tysx
//
//  Created by zwc on 14-6-18.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXDatePickerView.h"

@interface HXDatePickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation HXDatePickerView {
    UIPickerView *pickerView;
    NSMutableArray *months;
    NSMutableArray *days;
    NSMutableArray *years;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
        pickerView.showsSelectionIndicator = YES;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, pickerView.bounds.size.height);
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.backgroundColor = [UIColor clearColor];
        [self addSubview:pickerView];
        
        [pickerView selectRow:1 inComponent:0 animated:NO];
        
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-24 * 3600];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M"];
        int currentMonthIndex = [[dateFormatter stringFromDate:yesterday] intValue] - 1;
        [pickerView selectRow:currentMonthIndex inComponent:1 animated:NO];
        
        [dateFormatter setDateFormat:@"d"];
        int currentDayIndex = [[dateFormatter stringFromDate:yesterday] intValue] - 1;
        [pickerView selectRow:currentDayIndex inComponent:2 animated:NO];
        
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger ret = 0;
    switch (component) {
        case 0:
            ret = [[self years] count];
            break;
        case 1:
            ret = [[self months] count];
            break;
        case 2:
            ret = [[self days] count];
            break;
            
        default:
            break;
    }
    return ret;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:22];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = [self titleWithRow:row component:component];
    return label;
}

- (NSArray *)years {
    if (years == nil) {
        years = [NSMutableArray array];
        NSDate *  currentdate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
       // [dateformatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateformatter setDateFormat:@"yyyy"];
        NSString *  currentYear = [dateformatter stringFromDate:currentdate];
        [years insertObject:[currentYear stringByAppendingString:@"年"] atIndex:0];
        
        for (int i = 0; i < 1; i++) {
            [years insertObject:[NSString stringWithFormat:@"%d年", [currentYear intValue] - i - 1] atIndex:0];
        }
    }
    return years;
}

- (NSArray *)months {
    if (months == nil) {
        months = [NSMutableArray array];
        for (int i = 0; i < 12; i++) {
            [months addObject:[NSString stringWithFormat:@"%d月", i + 1]];
        }
    }
    return months;
}

- (NSArray *)days{
    if (days == nil) {
        days = [NSMutableArray array];
        for (int i = 0; i < 31; i++) {
            [days addObject:[NSString stringWithFormat:@"%d日", i + 1]];
        }
    }
    return days;
}

- (NSDate *)date {
    UILabel *yearLabel = (UILabel *)[pickerView viewForRow:[pickerView selectedRowInComponent:0] forComponent:0];
    UILabel *monthLabel = (UILabel *)[pickerView viewForRow:[pickerView selectedRowInComponent:1] forComponent:1];
    UILabel *dayLabel = (UILabel *)[pickerView viewForRow:[pickerView selectedRowInComponent:2] forComponent:2];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@%@%@", yearLabel.text, monthLabel.text, dayLabel.text];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateformatter setDateFormat:@"yyyy年M月d日"];
    NSDate * date = [dateformatter dateFromString:dateStr];
    
    return date;
}

- (NSDate *)seletedDate {
    UILabel *yearLabel = (UILabel *)[pickerView viewForRow:[pickerView selectedRowInComponent:0] forComponent:0];
    UILabel *monthLabel = (UILabel *)[pickerView viewForRow:[pickerView selectedRowInComponent:1] forComponent:1];
    UILabel *dayLabel = (UILabel *)[pickerView viewForRow:[pickerView selectedRowInComponent:2] forComponent:2];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@%@%@", yearLabel.text, monthLabel.text, dayLabel.text];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateformatter setDateFormat:@"yyyy年M月d日"];
    NSDate * date = [dateformatter dateFromString:dateStr];
    
    return date;
}


- (NSString *)titleWithRow:(NSInteger)row component:(NSInteger)component {
    NSString *ret = nil;
    
    switch (component) {
        case 0:
            ret = [self.years objectAtIndex:row];
            break;
        case 1:
            ret = [self.months objectAtIndex:row];
            break;
        case 2:
            ret = [self.days objectAtIndex:row];
            break;
        default:
            break;
    }
    return ret;
}

@end
