//
//  HXTableChartCell.h
//  tysx
//
//  Created by zwc on 14-8-13.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXTableChartCell;

@protocol HXTableChartCellDataSource <NSObject>

- (NSInteger)numberOfColumnInTableChartCell:(HXTableChartCell *)cell;
- (NSString *)contentInTableChartCell:(HXTableChartCell *)cell atColumn:(NSInteger)column;
- (CGFloat)widthOfColumnInTableChartCell:(HXTableChartCell *)cell atColumn:(NSInteger)column;
- (UIFont *)fontOfColumnInTableChartCell:(HXTableChartCell *)cell atColumn:(NSInteger)column;

@end

@interface HXTableChartCell : UITableViewCell

@property (nonatomic, weak) id<HXTableChartCellDataSource> dataSource;
@property (nonatomic, assign) UIEdgeInsets chartInsets;

@end
