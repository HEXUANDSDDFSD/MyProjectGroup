//
//  TYSXBindAPNTokenCtr.h
//  tysx
//
//  Created by zwc on 15/1/14.
//  Copyright (c) 2015年 huangjia. All rights reserved.
//

#import "NetworkBase.h"

@interface TYSXBindAPNTokenCtr : NetworkBase

@property (nonatomic, readonly) NSArray *chartAuthList;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *token;

@end
