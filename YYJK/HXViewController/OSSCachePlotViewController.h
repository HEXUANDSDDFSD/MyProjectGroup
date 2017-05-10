//
//  OSSCachePlotViewController.h
//  tysx
//
//  Created by zwc on 14/11/24.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSSCachePlotCtr.h"
#import "MYDrawContentView.h"

@interface OSSCachePlotViewController : UIViewController {
    MYDrawContentView *bgDrawView;
    OSSCachePlotCtr *cachePlotCtr;
    NSString *plotName;
}

+ (Class)cachePlotCtr;
+ (CacheType)cacheType;

- (id)initWithPlotName:(NSString *)_plotName;
- (void)backAction;
- (void)refreshAllView;
- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect;
- (void)contentView:(MYDrawContentView*)view touchBeginAtPoint:(CGPoint)p;

@end
