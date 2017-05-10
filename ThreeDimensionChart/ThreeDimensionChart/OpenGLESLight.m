//
//  OpenGLESLight.m
//  ThreeDimensionChart
//
//  Created by zwc on 16/4/13.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import "OpenGLESLight.h"

@implementation OpenGLESLight {
    MEColor *_ambient;
    MEColor *_specular;
    MEColor *_diffuse;
    GLfloat _shininess;
}

- (instancetype)init {
    if (self = [super init]) {
        _ambient = (MEColor *)malloc(sizeof(MEColor));
        _specular = (MEColor *)malloc(sizeof(MEColor));
        _diffuse = (MEColor *)malloc(sizeof(MEColor));
        
        _shininess = 1.0;
        _ambient->r = 1.0;
        _ambient->g = 1.0;
        _ambient->b = 1.0;
        _ambient->a = 1.0;
        
        _ambient->r = 1.0;
        _ambient->g = 1.0;
        _ambient->b = 1.0;
        _ambient->a = 1.0;
        
        _ambient->r = 1.0;
        _ambient->g = 1.0;
        _ambient->b = 1.0;
        _ambient->a = 1.0;
    }
    return self;
}

- (void)dealloc {
    free(_ambient);
    free(_specular);
    free(_diffuse);
}

@end
