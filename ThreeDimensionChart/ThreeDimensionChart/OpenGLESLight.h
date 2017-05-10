//
//  OpenGLESLight.h
//  ThreeDimensionChart
//
//  Created by zwc on 16/4/13.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import "OpenGLES_C_Func.h"

@interface OpenGLESLight : NSObject

@property (nonatomic, readonly) MEColor *ambient;
@property (nonatomic, readonly) MEColor *diffuse;
@property (nonatomic, readonly) MEColor *specular;
@property (nonatomic, assign) GLfloat shininess;

@end
