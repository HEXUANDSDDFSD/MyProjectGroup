//
//  PageCellViewController.h
//  tysx
//
//  Created by zwc on 14-6-10.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXBaseViewController.h"
#import "PageViewController.h"

@interface PageCellViewController : UIViewController

@property (nonatomic, copy) NSString *bgImageName;
@property (nonatomic, strong) NSArray *controlframes;
@property (nonatomic, strong) NSArray *controlImagesNames;
@property (nonatomic, weak) PageViewController *pageViewController;

@property (nonatomic, assign) BOOL isCataloguePage;

@end
