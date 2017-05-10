//
//  TYSXLoginUserChannelCtr.h
//  tysx
//
//  Created by zwc on 14/11/26.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "OSSCachePlotCtr.h"

#define kChannelIdKey @"channelId"
#define kChannelNameKey @"channelName"
#define kLoginTimesKey @"loginTimes"

@interface TYSXLoginUserChannelCtr : OSSCachePlotCtr

@property (nonatomic, assign) NSInteger currentChannelIndex;
@property (nonatomic, readonly) NSArray *channelList;
@property (nonatomic, readonly) NSArray *selectedChannelLoginTimes;
@property (nonatomic, readonly) NSArray *sumChannelLoginTimes;

@end
