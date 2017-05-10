//
//  HXPlotBaseViewController.h
//  tysx
//
//  Created by zwc on 14-7-25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXBaseViewController.h"
#import "MYDrawContentView.h"

@interface HXPlotBaseViewController : HXBaseViewController {
    MYDrawContentView *drawView;
}

- (id)initWithPlotName:(NSString *)name;

- (void)dismissDatePickView;
- (void)changeDateAction:(NSDate *)date;
- (NSString *)lastDateStr;
- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect;
- (void)contentView:(MYDrawContentView *)view touchBeginAtPoint:(CGPoint)p;

@end
