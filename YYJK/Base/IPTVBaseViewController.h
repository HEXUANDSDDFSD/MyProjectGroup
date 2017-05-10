//
//  PPTVBaseViewController.h
//  tysx
//
//  Created by zwc on 14/10/22.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYDrawContentView.h"

@interface IPTVBaseViewController : UIViewController {
    BOOL useDefaultPlot;
}

- (id)initWithPlotName:(NSString *)plotName;

//- (NSInteger)numberOfSection;
//- (CGFloat)heightOfCell;

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect;

@end
