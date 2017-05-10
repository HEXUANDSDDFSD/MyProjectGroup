//
//  TYSXBindAPNTokenCtr.m
//  tysx
//
//  Created by zwc on 15/1/14.
//  Copyright (c) 2015年 huangjia. All rights reserved.
//

#import "TYSXBindAPNTokenCtr.h"

@implementation TYSXBindAPNTokenCtr

+ (NSString *)path {
    return  @"/userAction!save.ds";
}

- (NSDictionary *)configParams {
    return @{@"name":self.userName,
             @"token":self.token};
}

@end
