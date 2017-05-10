//
//  HXLegendInfo.h
//  tysx
//
//  Created by zwc on 14/11/17.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LegendType_Bar,
    LegendType_Line
}LegendType;

@interface HXLegendInfo : NSObject

@property (nonatomic, copy) NSString *legendTitle;
@property (nonatomic, assign) CGFloat fillWidth;
@property (nonatomic, assign) CGFloat fillHeight;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat intervalX;
@property (nonatomic, assign) LegendType legendType;

@property (nonatomic, readonly) CGFloat titleWidth;
@property (nonatomic, readonly) CGFloat titleTopOffset;

@end
