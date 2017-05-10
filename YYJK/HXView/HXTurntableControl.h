//
//  HXTurntableControl.h
//  tysx
//
//  Created by zwc on 14-7-7.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXTurntableControl;

@protocol HXTurntableControlDelegate <NSObject>

- (void)turntableControlDidChangeIndex:(HXTurntableControl *)control;

@end

@interface HXTurntableControl : UIView

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, readonly) CGFloat currentRate;
@property (nonatomic, weak) id<HXTurntableControlDelegate> delegate;

@end
