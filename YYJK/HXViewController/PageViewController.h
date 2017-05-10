//
//  PageViewController.h
//  PageViewControllerTest
//
//  Created by zwc on 14-5-30.
//  Copyright (c) 2014年 7tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBaseViewController.h"

@interface PageViewController : HXBaseViewController

@property (nonatomic, strong) NSArray *viewControllers;

- (void)gotoPageWithIndex:(NSInteger)index;

@end
