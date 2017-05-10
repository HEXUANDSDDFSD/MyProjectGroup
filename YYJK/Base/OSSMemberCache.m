//
//  OSSMemCache.m
//  tysx
//
//  Created by zwc on 14/10/30.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "OSSMemberCache.h"
#import "HXChartMainViewController.h"
#import "HXTransformRateViewController.h"
#import "HXPlatformDataViewController.h"
#import "TYSXLoginUserViewController.h"
#import "HXAAAFailureViewController.h"
#import "HXIPOrderAbnormalViewController.h"
#import "HXSuccessRateViewController.h"
#import "HXMapButtonViewController.h"
#import "IPTVActiveUsersViewController.h"
#import "TYSXStreamMediaMonitorViewController.h"
#import "IPTVPowerUsersViewController.h"
#import "IPTVHDUsersViewController.h"
#import "IPTVTempViewController.h"

@implementation OSSMemberCache {
    NSArray *classKeyList;
}

+ (OSSMemberCache *)shareCache {
    static OSSMemberCache *memberCache = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        memberCache = [[self alloc] init];
    });
    return memberCache;
}

+ (OrganizationType)typeWithSafeCode:(NSString *)safeCode {
    OrganizationType type = OrganizationType_None;
    if ([safeCode isEqualToString:@"HUANGJIA"]) {
        type = OrganizationType_HUANGJIA;
    }
    else if ([safeCode isEqualToString:@"TYSX"]) {
        type = OrganizationType_TYSX;
    }
    else if ([safeCode isEqualToString:@"IPTV"]) {
        type = OrganizationType_IPTV;
    }
    return type;
}

- (id)init {
    if (self = [super init]) {
        NSDictionary *memCache = [NSDictionary dictionaryWithContentsOfFile:[self cachePath]];
        [self processAuth];
        if (memCache != nil) {
            self.userName = memCache[@"user_name"];
            self.organizationType = (OrganizationType)[[memCache objectForKey:@"organization_type"] integerValue];
            self.chartAuthList = [memCache objectForKey:@"chartAuthList"];
        }
    }
    return self;
}

- (void)processAuth {
    if (kNeedVirtualData) {
        if (_selectedSegment == 0) {
            classKeyList = @[@"2-1", @"2-2", @"2-3", @"2-4", @"2-5", @"2-6"];
        }
        else {
            classKeyList = @[@"1-1", @"1-5"];
        }
        return;
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    switch (_selectedSegment) {
        case 0:
            for (NSString *key in self.chartAuthList) {
                if ([key hasPrefix:@"2-"]) {
                    [tempArr addObject:key];
                }
            }
            break;
        case 1:
            for (NSString *key in self.chartAuthList) {
                if ([key hasPrefix:@"1-"]) {
                    [tempArr addObject:key];
                }
            }
            break;
            
        default:
            break;
    }
    [tempArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
       return [obj1 compare:obj2];
    }];
    classKeyList = [tempArr copy];
}

- (void)setSelectedSegment:(NSInteger)selectedSegment {
    if (_selectedSegment != selectedSegment) {
        _selectedSegment = selectedSegment;
        [self processAuth];
    }
}

- (void)saveMember {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.userName forKey:@"user_name"];
    [dict setValue:[NSNumber numberWithInteger:self.organizationType] forKey:@"organization_type"];
    
    //    if (kNeedVirtualData) {
    //        self.chartAuthList = @[@1, @2, @3, @4, @5, @6];
    //    }
    
    if (self.chartAuthList != nil) {
        [dict setValue:self.chartAuthList forKey:@"chartAuthList"];
    }
    [dict writeToFile:[self cachePath] atomically:NO];
    [self processAuth];
}

- (void)deleteMember {
    [[NSFileManager defaultManager] removeItemAtPath:[self cachePath] error:nil];
}

- (NSString *)cachePath {
    return [KCachePath stringByAppendingPathComponent:@"mem_cache"];
}

- (NSArray *)selectedKeyList {
    return classKeyList;
}

- (NSArray *)classNameList {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < [classKeyList count]; i++) {
        [tempArray addObject:[self classNameDic][classKeyList[i]]];
    }
    return tempArray;
}

- (NSArray *)titleList {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < [classKeyList count]; i++) {
        [tempArray addObject:[self titleNameDic][classKeyList[i]]];
    }
    return tempArray;
}

- (NSArray *)imageNameList {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < [classKeyList count]; i++) {
        [tempArray addObject:[self imageNameDic][classKeyList[i]]];
    }
    return tempArray;
}

- (NSDictionary *)classNameDic {
    return @{@"1-1":@"TYSXLoginUserViewController",
             @"1-2":@"TYSXLoginUserChannelViewController",
             @"1-3":@"TYSXStreamMediaMonitorViewController",
             @"1-4":@"TYSXProductPackageOrderViewController",
             @"1-5":@"TYSXProductPackageUnsubscribeViewController",
             @"2-1":@"TYSXOrderAndUnViewController",
             @"2-2":@"TYSXPlatLoginPlayViewController",
             @"2-3":@"TYSXClientViewController",
             @"2-4":@"TYSXKeyProductPackageViewController",
             @"2-5":@"TYSXLoveLook4GViewController",
             @"2-6":@"TYSXSplitScreenRealTimeViewController"};
}

- (NSDictionary *)titleNameDic {
    return @{@"1-1":@"登录用户数统计",
             @"1-2":@"登录用户渠道统计",
             @"1-3":@"流媒体监控",
             @"1-4":@"产品包订购监控",
             @"1-5":@"产品包退订监控",
             @"2-1":@"订购退订",
             @"2-2":@"平台登录播放",
             @"2-3":@"客户端5",
             @"2-4":@"重点产品包",
             @"2-5":@"爱看4G",
             @"2-6":@"分屏实时"};
}

- (NSDictionary *)imageNameDic {
    return  @{@"2-1":@"order_un.png",
              @"2-2":@"plat_login_play.png",
              @"2-3":@"client5.png",
              @"2-4":@"key_product_package.png",
              @"2-5":@"love_look_4g.png",
              @"2-6":@"split_real_time.png"};
}

@end
