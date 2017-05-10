//
//  OpenGLESFileManager.h
//  ThreeDimensionChart
//
//  Created by zwc on 16/4/15.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLESLight.h"

@interface OpenGLESFileManager : NSObject

+ (void)saveLightData:(OpenGLESLight *)light;

+ (NSArray *)lightList;
+ (void)removeLightAtIndex:(NSInteger)index;

@end
