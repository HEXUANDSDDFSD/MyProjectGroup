//
//  HXChartDataDetailCell.h
//  tysx
//
//  Created by zwc on 13-11-25.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXChartDataDetailCell : UITableViewCell

@property (nonatomic, assign) BOOL isIncrease;

@property (nonatomic, assign) long long currentValue;
@property (nonatomic, assign) long long compareValue;
@property (nonatomic, assign) long long weakCompareValue;
@property (nonatomic, assign) long long dayCompareValue;
@property (nonatomic, assign) int typeIndex;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *unitStr;
@property (nonatomic, assign) BOOL needChangeBigUnit;

@end
