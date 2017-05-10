//
//  HXCorePlotLayerDelegate.h
//  tysx
//
//  Created by zwc on 14-7-22.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCorePlotLayerDelegate : NSObject

@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingBottom;
@property (nonatomic, assign) CGFloat insetLeft;
@property (nonatomic, assign) CGFloat insetRight;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat rightMaxValue;
@property (nonatomic, assign) CGFloat rightMinValue;

@end
