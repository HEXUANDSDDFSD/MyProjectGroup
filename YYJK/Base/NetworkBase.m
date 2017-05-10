//
//  NetworkBase.m
//  tysx
//
//  Created by zwc on 14-6-6.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "NetworkBase.h"
#import "MKNetworkEngine.h"
#import "OSSMemberCache.h"
#import "NSString+JSONCategory.h"
#import "FMDB.h"

@implementation NetworkBase {
    MKNetworkEngine *engine;
}

@synthesize finishBlock;
@synthesize resultInfo;

+ (NSString *)friendShowStrWithParamError:(NetworkBaseParamError)paramError {
    return nil;
}

+ (NSString *)path {
    return nil;
}

+ (NSString *)hostStr {
    //return kTestServerUrl;
    NSString *serverUrl = nil;
    switch ([OSSMemberCache shareCache].organizationType) {
        case OrganizationType_Guest:
        case OrganizationType_HUANGJIA:
            serverUrl = kDefaultServerUrl;
            break;
        case OrganizationType_TYSX:
            serverUrl = kTYSXServerUrl;
            break;
            
        default:
            break;
    }
    return serverUrl;
}

+ (CFStringEncodings)encodingType{
    return 0;
}

- (NSDictionary *)configParams {
    return nil;
}

- (NetworkBaseParamError)checkParams {
    return kNetworkBaseParamError_NoError;
}

- (NetworkBaseParamError)sendRequestWith:(NetworkFinish)_finishBlock {
    return nil;
    NetworkBaseParamError paramError = [self checkParams];
    
    _result = NetworkBaseResult_None;
    if (kNetworkBaseParamError_NoError != paramError) {
        _resultInfo = [[self class] friendShowStrWithParamError:paramError];
        return paramError;
    }
    else if(!isNetworkNormal()) {
        _resultInfo = @"当前网络不可用，请检查网络连接！";
        return NetworkBaseResult_No_NetWork;
    }
    
    self.finishBlock = _finishBlock;
    _resultInfo = nil;
    
    
    engine = [[MKNetworkEngine alloc] initWithHostName:[[self class] hostStr] customHeaderFields:nil];
    [engine useCache];
    MKNetworkOperation *op = [engine operationWithPath:[[self class] path] params:[self configParams] httpMethod:@"GET" ssl:NO];
    
    if ([[self class] encodingType] != 0) {
        op.stringEncoding = CFStringConvertEncodingToNSStringEncoding([[self class] encodingType]);
    }
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        [self successWithResponse:[operation.responseString JSONValue]];
        [self finishAction];
        self.finishBlock = nil;
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        _result = NetworkBaseResult_Failure;
        _resultInfo = @"连接失败";
        NSLog(@"MKNetwork request error : %@", [err localizedDescription]);
        [self finishAction];
        self.finishBlock = nil;
    }];
    [engine enqueueOperation:op];
    
    return paramError;
}

- (void)successWithResponse:(id)responseDic {
    
}


- (void)finishAction {
    if (self.finishBlock) {
        self.finishBlock();
    }
}

- (NetworkBaseResult)result {
    return _result;
}

- (NSString *)resultInfo {
    return _resultInfo;
}

@end
