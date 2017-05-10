//
//  CFunction.h
//  tysx
//
//  Created by zwc on 13-12-11.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

typedef enum{
    DrawDirection_None = 0,
    DrawDirection_Up = 1,
    DrawDirection_Down = 2,
    DrawDirection_Left = 3,
    DrawDirection_Right = 4,
}eDrawDirection;

void drawTriangle(UIColor* color, CGPoint centerPoint, CGFloat side, eDrawDirection direction);

void showPrompt(NSString *title, CGFloat keepTime, BOOL isHorizonal);
void showStatusView(BOOL isHorizonal);
void dismissStatusView();

NSString *stringWithDate(NSDate *date);

NSString *nowWeekStr();
NSString *nowDateStr();
NSString *nowTimeStr();

CGFloat degreeBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End);
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second);
CGFloat angleBetweenPoints(CGPoint first, CGPoint second);
CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End);

void drawLineText(CGPoint startPoint, NSArray *textList, NSArray *colorList, NSArray *fontList);

BOOL isNetworkNormal();

BOOL needLogin();

BOOL isGuest();

NSString *percentageChange(long long lastValue, long long currentValue);