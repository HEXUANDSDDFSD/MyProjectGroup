//
//  MyListSelectorView.h
//  tysx
//
//  Created by zwc on 14-6-25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyListSelectorView;

@protocol MyListSelectorViewDataSource <NSObject>

- (NSString *)rowTitleWithRow:(int)row section:(int)number;
- (int)rowNumberOfSection:(int)number;

@end

@protocol MyListSelectorViewDelegate <NSObject>

- (void)listSelectorViewDidSelect:(MyListSelectorView *)view;

@end

@interface MyListSelectorView : UIView

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *sectionTitles;
//@property (nonatomic, assign) int currentSelectIndex;
@property (nonatomic, assign) int currentSection;
@property (nonatomic, assign) int currentRow;
@property (nonatomic, weak) id<MyListSelectorViewDelegate> delegate;
@property (nonatomic, weak) id<MyListSelectorViewDataSource> dataSource;

@end
