//
//  MEDragSegmentedControl.h
//  tysx
//
//  Created by zwc on 14/12/5.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ShowOrientation_Vertical,
    ShowOrientation_Horizonal
}ShowOrientation;

@interface MEDragSegmentedControl : UIControl

@property (nonatomic, assign)ShowOrientation orientation;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectedFont;

@property (nonatomic, strong)NSArray *itemTitles;
@property (nonatomic, assign)CGFloat everyHeight;
@property (nonatomic, assign)CGFloat everyWidth;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, readonly) NSString *selectedTitle;

@end
