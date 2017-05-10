//
//  HXSeparateBarView.h
//  tysx
//
//  Created by zwc on 13-12-29.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSeparateBarViewDelegate <NSObject>

@end

@interface HXSeparateBarView : UIView

@property (nonatomic, weak) id<HXSeparateBarViewDelegate> delegate;
@property (nonatomic, assign) CGFloat maxValue;

@end
