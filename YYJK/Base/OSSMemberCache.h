//
//  OSSMemberCache.h
//  tysx
//
//  Created by zwc on 14/10/30.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    OrganizationType_None,
    OrganizationType_Guest,
    OrganizationType_HUANGJIA,
    OrganizationType_TYSX,
    OrganizationType_IPTV
} OrganizationType;

@interface OSSMemberCache : NSObject

@property (nonatomic, assign) OrganizationType organizationType;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) NSArray *chartAuthList;

//@property (nonatomic, readonly) NSArray *viewControllerClasses;
//@property (nonatomic, readonly) NSArray *titles;
//@property (nonatomic, readonly) NSArray *defaultImageNames;

@property (nonatomic, readonly) NSArray *selectedKeyList;
@property (nonatomic, readonly) NSArray *classNameList;
@property (nonatomic, readonly) NSArray *titleList;
@property (nonatomic, readonly) NSArray *imageNameList;
@property (nonatomic, assign) NSInteger selectedSegment;

+ (OSSMemberCache *)shareCache;

+ (OrganizationType)typeWithSafeCode:(NSString *)safeCode;

- (void)saveMember;
- (void)deleteMember;


@end
