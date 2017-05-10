//
//  OpenGLESFileManager.m
//  ThreeDimensionChart
//
//  Created by zwc on 16/4/15.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import "OpenGLESFileManager.h"

#define kAmbientRKey @"A_R"
#define kAmbientGKey @"A_G"
#define kAmbientBKey @"A_B"
#define kDiffuseRKey @"D_R"
#define kDiffuseGKey @"D_G"
#define kDiffuseBKey @"D_B"
#define kSpecularRKey @"S_R"
#define kSpecularGKey @"S_G"
#define kSpecularBKey @"S_B"
#define kShininessKey @"kShininessKey"

@implementation OpenGLESFileManager

+ (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    return [cachesDir stringByAppendingPathComponent:@"lightListPath"];
}

+ (void)saveLightData:(OpenGLESLight *)light {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self filePath]]) {
        NSLog(@"%@",[self filePath]);
        [fileManager createFileAtPath:[self filePath] contents:nil attributes:nil];
    };
    
    NSMutableArray *lightList = [NSMutableArray arrayWithContentsOfFile:[self filePath]];
    if (lightList == nil) {
        lightList = [NSMutableArray array];
    }
    [lightList addObject:
     @{kShininessKey:[NSNumber numberWithFloat:light.shininess],
       kAmbientRKey:[NSNumber numberWithFloat:light.ambient->r],
       kAmbientGKey:[NSNumber numberWithFloat:light.ambient->g],
       kAmbientBKey:[NSNumber numberWithFloat:light.ambient->b],
       kDiffuseRKey:[NSNumber numberWithFloat:light.diffuse->r],
       kDiffuseGKey:[NSNumber numberWithFloat:light.diffuse->g],
       kDiffuseBKey:[NSNumber numberWithFloat:light.diffuse->b],
       kSpecularRKey:[NSNumber numberWithFloat:light.specular->r],
       kSpecularGKey:[NSNumber numberWithFloat:light.specular->g],
       kSpecularBKey:[NSNumber numberWithFloat:light.specular->b],}
     ];
    [lightList writeToFile:[self filePath] atomically:YES];
}

+ (void)tranformDict:(NSDictionary *)lightDic toLight:(OpenGLESLight *)light {
    light.shininess = [lightDic[kShininessKey] floatValue];
    light.ambient->r = [lightDic[kAmbientRKey] floatValue];
    light.ambient->g = [lightDic[kAmbientGKey] floatValue];
    light.ambient->b = [lightDic[kAmbientBKey] floatValue];
    light.diffuse->r = [lightDic[kDiffuseRKey] floatValue];
    light.diffuse->g = [lightDic[kDiffuseGKey] floatValue];
    light.diffuse->b = [lightDic[kDiffuseBKey] floatValue];
    light.specular->r = [lightDic[kSpecularRKey] floatValue];
    light.specular->g = [lightDic[kSpecularGKey] floatValue];
    light.specular->b = [lightDic[kSpecularBKey] floatValue];
}

+ (void)removeLightAtIndex:(NSInteger)index {
     NSMutableArray *tempLightList = [NSMutableArray arrayWithContentsOfFile:[self filePath]];
    [tempLightList removeObjectAtIndex:index];
    [tempLightList writeToFile:[self filePath] atomically:YES];
}

+ (NSArray *)lightList {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self filePath]]) {
        [fileManager createFileAtPath:[self filePath] contents:nil attributes:nil];
    };
    
    NSArray *tempLightList = [NSMutableArray arrayWithContentsOfFile:[self filePath]];
    if (tempLightList != nil) {
        NSMutableArray *lightList = [NSMutableArray array];
        for (int i = 0; i < [tempLightList count]; i++) {
            NSDictionary *lightDic = tempLightList[i];
            OpenGLESLight *light = [[OpenGLESLight alloc] init];
            [self tranformDict:lightDic toLight:light];
            [lightList addObject:light];
        }
        return [lightList copy];
    }
    return nil;
}

@end
