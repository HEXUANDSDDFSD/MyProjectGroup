//
//  NetworkBase.h
//  tysx
//
//  Created by zwc on 14-6-6.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kNetworkBaseParamError_NoError,
    kNetworkBaseParamError_UserName_Null,
    kNetworkBaseParamError_Password_Null,
}NetworkBaseParamError;

typedef enum{
    NeedOperateType_None,
    NeedOperateType_Update,
    NeedOperateType_Reload,
    NeedOperateType_OverDate
} NeedOperateType;

typedef enum{
    NetworkBaseResult_None,
    NetworkBaseResult_Failure,
    NetworkBaseResult_No_NetWork,
    NetworkBaseResult_ResultError,
    NetworkBaseResult_Success
}NetworkBaseResult;

typedef void (^NetworkFinish)();

typedef void (^RefreshViewAction)();

@interface NetworkBase : NSObject {
    NetworkBaseResult _result;
    NSString *_resultInfo;
}

@property (nonatomic, copy) NetworkFinish finishBlock;
@property (nonatomic, readonly) NSString *resultInfo;
@property (nonatomic, readonly) NetworkBaseResult result;


+ (NSString *)hostStr;
+ (NSString *)path;
+ (CFStringEncodings)encodingType;
+ (NSString *)friendShowStrWithParamError:(NetworkBaseParamError)paramError;

- (NetworkBaseParamError)sendRequestWith:(NetworkFinish)_finishBlock;
- (NetworkBaseParamError)checkParams;
- (NSDictionary *)configParams;
- (void)successWithResponse:(id)responseDic;
- (void)finishAction;

@end
