//
//  HXSectionMenuView.h
//  tysx
//
//  Created by zwc on 13-12-17.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSectionMenuView;

@protocol HXSectionMenuViewDataSource <NSObject>

- (NSInteger)numberOfSectionsInSectionMenuView:(HXSectionMenuView *)menuView;
- (NSInteger)sectionMenuView:(HXSectionMenuView *)sectionMenuView numberOfRowsInSection:(NSInteger)section;
- (NSString *)sectionMenuView:(HXSectionMenuView *)sectionMenuView titleInSection:(NSInteger)section;
- (NSString *)sectionMenuView:(HXSectionMenuView *)sectionMenuView titleForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol HXSectionMenuViewDelegate <NSObject>

@optional

- (void)sectionMenuView:(HXSectionMenuView *)sectionMenuView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HXSectionMenuView : UIView

@property (nonatomic, weak) id<HXSectionMenuViewDataSource> dataSource;
@property (nonatomic, weak) id<HXSectionMenuViewDelegate> delegate;

@end
