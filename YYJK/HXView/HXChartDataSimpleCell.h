//
//  HXChartDataSimpleCell.h
//  tysx
//
//  Created by zwc on 13-11-25.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXChartDataSimpleCell : UITableViewCell

@property (nonatomic, assign) BOOL isIncrease;
@property (nonatomic, copy) NSString *dayStr;
@property (nonatomic, assign) int unusualNumber;
@property (nonatomic, assign) CGFloat unusualRate;
@property (nonatomic, assign) int index;

@end
