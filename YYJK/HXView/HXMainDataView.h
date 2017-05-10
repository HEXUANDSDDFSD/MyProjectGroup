//
//  HXMainDataView.h
//  tysx
//
//  Created by zwc on 13-11-14.
//  Copyright (c) 2013年 huangjia. All rights reserved.

#import <UIKit/UIKit.h>

@interface HXMainDataView : UIView

@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *currentDayStr;
@property (nonatomic, copy) NSString *weakBottomTitle;
@property (nonatomic, copy) NSString *dayBottomTitle;

@property (nonatomic, copy) NSString *unitStr;
@property (nonatomic, assign) BOOL needChangeBigUnit;

@property (nonatomic, assign) long long currentValue;
@property (nonatomic, assign) long long compareValue;
@property (nonatomic, assign) long long weakCompareValue;
@property (nonatomic, assign) long long dayCompareValue;

@property (nonatomic, assign) BOOL isCompareWeek;

@end
