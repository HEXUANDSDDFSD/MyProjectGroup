//
//  LoginCtr.h
//  tysx
//
//  Created by zwc on 14-6-6.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "NetworkBase.h"

@interface LoginCtr : NetworkBase

@property (nonatomic, readonly) NSArray *chartAuthList;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

@end
