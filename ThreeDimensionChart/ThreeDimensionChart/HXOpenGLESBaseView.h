//
//  HXOpenGLESBaseView.h
//  ThreeDimensionChart
//
//  Created by zwc on 16/3/9.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLES_C_Func.h"

@interface HXOpenGLESBaseView : UIView

@property (nonatomic, readonly) MEVertex *lightPosition;
@property (nonatomic, readonly) MEColor *ambient;
@property (nonatomic, readonly) MEColor *diffuse;
@property (nonatomic, readonly) MEColor *specular;
@property (nonatomic, assign) GLfloat shininess;
@property (nonatomic, assign) GLfloat scaleY;
@property (nonatomic, assign) GLfloat scaleX;
@property (nonatomic, assign) GLuint columnNum;
@property (nonatomic, assign) GLuint rowNum;

- (void)render:(CADisplayLink*)displayLink;

- (UIImage *)drawDate:(NSString *)string;

- (void)updateVertexData;

@end
