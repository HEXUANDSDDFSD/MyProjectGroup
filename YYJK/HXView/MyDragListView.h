//
//  MyDragListView.h
//  tysx
//
//  Created by zwc on 14-6-27.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyDragListView;

@protocol MyDragListViewDelegate <NSObject>

- (void)dragListViewDidSeleted:(MyDragListView *)view;

@end

@interface MyDragListView : UIView

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) id<MyDragListViewDelegate> delegate;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *selectedColor;

@end
