//
//  ChartMenuItemInfoCtr.h
//  tysx
//
//  Created by zwc on 14-10-17.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartMenuItemInfo : NSObject

@property (nonatomic, copy) NSString *chartName;
@property (nonatomic, assign) Class viewControllerClass;
@property (nonatomic, copy) NSString *backImageName;

@end

@interface ChartMenuItemInfoCtr : NSObject

@end
