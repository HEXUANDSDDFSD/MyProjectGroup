//
//  LoginCtr.m
//  tysx
//
//  Created by zwc on 14-6-6.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "LoginCtr.h"

@implementation LoginCtr {
    BOOL isSuccess_;
    NSArray *chartAuthArray;
}

@synthesize userName;
@synthesize password;

- (BOOL)isSuccess {
    return isSuccess_;
}

- (NSArray *)chartAuthList {
    return chartAuthArray;
}

+ (NSString *)path {
    return  @"/adminAction!login.ds";
}

+ (NSString *)friendShowStrWithParamError:(NetworkBaseParamError)paramError {
    NSString *showStr = nil;
    switch (paramError) {
        case kNetworkBaseParamError_UserName_Null:
            showStr = @"请输入用户名";
            break;
        case kNetworkBaseParamError_Password_Null:
            showStr = @"请输入密码";
            break;
            
        default:
            break;
    }
    return showStr;
}

- (NetworkBaseParamError)checkParams {
    NetworkBaseParamError *paramError = kNetworkBaseParamError_NoError;
    if (self.userName.length == 0) {
        paramError = kNetworkBaseParamError_UserName_Null;
    }
    else if (password.length == 0) {
        paramError = kNetworkBaseParamError_Password_Null;
    }
    return paramError;
}

- (NSDictionary *)configParams {
    return @{@"name":self.userName,
             @"pwd":self.password};
}

- (void)successWithResponse:(id)responseDic {
    int code = [[responseDic objectForKey:@"code"] intValue];
    if (code == 0) {
        _result = NetworkBaseResult_ResultError;
    }
    else if (code == 1){
        _result = NetworkBaseResult_Success;
        chartAuthArray = [[responseDic objectForKey:@"chartAuth"] componentsSeparatedByString:@","];
    }
    _resultInfo = [responseDic objectForKey:@"msgInfo"];
}

@end
