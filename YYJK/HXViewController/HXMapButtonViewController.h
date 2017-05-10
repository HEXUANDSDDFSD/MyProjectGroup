//
//  HXMapButtonViewController.h
//  tysx
//
//  Created by zwc on 13-11-25.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPlotBaseViewController.h"

@interface HXMapButtonViewController : HXBaseViewController;

- (id)initWithPlotName:(NSString *)name;

- (IBAction)pressdown:(UIButton *)sender;

@end
