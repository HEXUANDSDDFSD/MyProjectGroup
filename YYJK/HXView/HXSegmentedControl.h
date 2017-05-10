//
//  HXSegmentedControl.h
//  MeasureTool
//
//  Created by zwc on 14-6-13.
//  Copyright (c) 2014年 MYSTERIOUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSegmentedControl;

@protocol HXSegmentedControlDelegate <NSObject>

- (void)segmentedControlValueChanged:(HXSegmentedControl *)control;

@end

@interface HXSegmentedControl : UIView

- (id)initWithItems:(NSArray *)_items;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIColor *normalTitleColor;

@property (nonatomic, assign) BOOL needBorder;

@property (nonatomic, weak) id<HXSegmentedControlDelegate> delegate;

@end
