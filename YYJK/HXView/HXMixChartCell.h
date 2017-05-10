//
//  HXMixChartCell.h
//  tysx
//
//  Created by zwc on 14-2-26.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ChartType_None = 0,
    ChartType_Bar = 1,
    ChartType_Line = 2
}ChartType;

@interface HXMixChartCell : NSObject

@property (nonatomic, copy) NSArray *datas;
@property (nonatomic, assign) ChartType type;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) NSString *name;

@end
