//
//  CFunction.m
//  tysx
//
//  Created by zwc on 13-12-11.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "AppDelegate.h"
#import "OSSMemberCache.h"
#import "Reachability.h"

#define kStatusViewTag 12345

#include <math.h>

#define degreesToRadian(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / M_PI)
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};
CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat height = second.y - first.y;
    CGFloat width = first.x - second.x;
    CGFloat rads = atan(height/width);
    return radiansToDegrees(rads);
    //degs = degrees(atan((top - bottom)/(right - left)))
}
//
//CGFloat degreeBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
//    CGFloat a = line1End.x - line1Start.x;
//    CGFloat b = line1End.y - line1Start.y;
//    CGFloat c = line2End.x - line2Start.x;
//    CGFloat d = line2End.y - line2Start.y;
//    
//    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
//    return rads;
//}


CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
    
    NSLog(@"%@ %@ %@ %@", NSStringFromCGPoint(line1Start), NSStringFromCGPoint(line1End), NSStringFromCGPoint(line2Start), NSStringFromCGPoint(line2End));
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    return radiansToDegrees(rads);
}

CGFloat degreeBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
    CGFloat angle1 = atan2(line1End.y - line1Start.y, line1End.x - line1Start.x);
    // 2. calculate the angle from +x to v2
    CGFloat angle2 = atan2(line2End.y - line2Start.y, line2End.x - line2Start.x);
    // 3. calcualte the angle from v1 to v2
    CGFloat angle = angle2 - angle1;
    return angle;
}

void drawTriangle(UIColor* color, CGPoint centerPoint, CGFloat side, eDrawDirection direction) {
    if (direction == DrawDirection_None) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat height = side * sin(M_PI_2 * 2 / 3);
    
    switch (direction) {
        case DrawDirection_Left:
            CGContextMoveToPoint(context, centerPoint.x - height / 2, centerPoint.y);
            CGContextAddLineToPoint(context, centerPoint.x + height / 2, centerPoint.y - side / 2);
            CGContextAddLineToPoint(context, centerPoint.x + height / 2, centerPoint.y + side / 2);
            break;
        case DrawDirection_Right:
            CGContextMoveToPoint(context, centerPoint.x + height / 2, centerPoint.y);
            CGContextAddLineToPoint(context, centerPoint.x - height / 2, centerPoint.y - side / 2);
            CGContextAddLineToPoint(context, centerPoint.x - height / 2, centerPoint.y + side / 2);
            break;
        case DrawDirection_Up:
            CGContextMoveToPoint(context, centerPoint.x, centerPoint.y - height / 2);
            CGContextAddLineToPoint(context, centerPoint.x - side / 2, centerPoint.y + height / 2);
            CGContextAddLineToPoint(context, centerPoint.x + side / 2, centerPoint.y + height / 2);
            break;
        case DrawDirection_Down:
            CGContextMoveToPoint(context, centerPoint.x, centerPoint.y + height / 2);
            CGContextAddLineToPoint(context, centerPoint.x - side / 2, centerPoint.y - height / 2);
            CGContextAddLineToPoint(context, centerPoint.x + side / 2, centerPoint.y - height / 2);
            break;
        default:
            break;
    }
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextClosePath(context);
    CGContextFillPath(context);

}

void showPrompt(NSString *title, CGFloat keepTime, BOOL isHorizonal) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UIFont *font = [UIFont systemFontOfSize:18];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, titleSize.width, titleSize.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.font = font;
    label.textColor = [UIColor whiteColor];
    
    view.frame = CGRectMake(0, 0, label.bounds.size.width + 30, label.bounds.size.height + 30);
    view.layer.cornerRadius = 5;
    [view addSubview:label];
    view.backgroundColor = [UIColor blackColor];
    if (isHorizonal && kVersionValue < 8.0) {
        view.transform=CGAffineTransformMakeRotation(-M_PI*1.5);
    }
    view.center = kAppDelegate.window.center;
    [kAppDelegate.window addSubview:view];
    [UIView animateWithDuration:0.5 delay:keepTime options:UIViewAnimationCurveLinear animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL completed){
        if (completed) {
            [view removeFromSuperview];
        }
    }];
    
}

void showStatusView(BOOL isHorizonal) {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIView *statusBgView = [[UIView alloc] initWithFrame:CGRectMake((kScreenHeight - 150 ) / 2, (kScreenWidth - 150 ) / 2 - 100, 150, 150)];
    statusBgView.layer.cornerRadius = 10;
    statusBgView.backgroundColor = [UIColor blackColor];
    statusBgView.tag = kStatusViewTag;
    statusBgView.alpha = 0.8;
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.frame = CGRectMake(0, 0, statusBgView.bounds.size.width, 100);
    [activity startAnimating];
    [statusBgView addSubview:activity];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, statusBgView.bounds.size.width, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"请稍候...";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    [statusBgView addSubview:label];
    if (isHorizonal && kVersionValue < 8.0) {
        statusBgView.transform=CGAffineTransformMakeRotation(-M_PI*1.5);
    }
    statusBgView.center = kAppDelegate.window.center;
    [kAppDelegate.window addSubview:statusBgView];
}

void dismissStatusView() {
     [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    UIView *view = [kAppDelegate.window viewWithTag:kStatusViewTag];
    [view removeFromSuperview];
}

NSString *stringWithDate(NSDate *date) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return  [dateFormatter stringFromDate:date];
}

NSString *nowWeekStr() {
    NSInteger week;
    NSString *weekStr=nil;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:now];
    week = [comps weekday];
    
    if(week==1)
    {
        weekStr=@"星期天";
    }else if(week==2){
        weekStr=@"星期一";
        
    }else if(week==3){
        weekStr=@"星期二";
        
    }else if(week==4){
        weekStr=@"星期三";
        
    }else if(week==5){
        weekStr=@"星期四";
        
    }else if(week==6){
        weekStr=@"星期五";
        
    }else if(week==7){
        weekStr=@"星期六";
        
    }
    return weekStr;
}

NSString *nowDateStr() {
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy年MM月dd日"];
    return [dataFormatter stringFromDate:[NSDate date]];
}

NSString *nowTimeStr() {
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"HH:mm"];
    return [dataFormatter stringFromDate:[NSDate date]];
}

void drawLineText(CGPoint startPoint, NSArray *textList, NSArray *colorList, NSArray *fontList) {
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    CGFloat firstFontSize = ((UIFont *)fontList[0]).pointSize;
    
    for (int i = 0; i < [textList count]; i++) {
        UIColor *textColor = colorList[i];
        NSString *text = textList[i];
        UIFont *textFont = fontList[i];
        CGPoint drawPoint = CGPointMake(startPoint.x, startPoint.y + (firstFontSize - textFont.pointSize) * 0.5);
        
        [attr setValue:textColor forKey:NSForegroundColorAttributeName];
        [attr setValue:textFont forKey:NSFontAttributeName];
        [text drawAtPoint:drawPoint withAttributes:attr];
        startPoint.x += [text sizeWithAttributes:attr].width;
    }
}

BOOL isNetworkNormal(){
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    return YES;
}

BOOL needLogin() {
    return !kNeedVirtualData && [OSSMemberCache  shareCache].userName == nil;
}

BOOL isGuest(){
  return [OSSMemberCache shareCache].organizationType == OrganizationType_Guest ||
    [OSSMemberCache shareCache].organizationType == OrganizationType_HUANGJIA;
}

NSString *percentageChange(long long lastValue, long long currentValue) {
    NSString *ret = nil;
    if (lastValue == 0 || currentValue == 0 || lastValue == currentValue) {
        ret = @"0";
    }
    else {
        ret = [NSString stringWithFormat:@"%.2f%%", currentValue * 100.0 / lastValue];
    }
    return ret;
}