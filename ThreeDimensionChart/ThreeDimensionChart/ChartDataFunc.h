//
//  ShapeDataFunc.h
//  ThreeDimensionChart
//
//  Created by zwc on 16/3/1.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import "CC3Foundation.h"

typedef struct {
    float Position[3];
    float Color[4];
}Vertex;

typedef struct{
    GLfloat x;
    GLfloat y;
    GLfloat z;
}Normal;

typedef struct{
    GLfloat x;
    GLfloat y;
    GLfloat z;
} Vector3D;

@interface ShapeDataFunc : NSObject

+ (void)ProduceBarData:(Vertex *)vertexs indice:(GLubyte*)indices xOffset:(GLfloat)xOffset radius:(GLfloat)radius height:(GLfloat)height edgeNum:(GLushort) edgeNum;

+ (void)ProduceNormalData:(Normal *)normals vertexs:(Vertex *)vertexs vertexNum:(GLushort)vertexNum indices:(GLubyte *)indices indiceNum:(GLushort)indiceNum;


@end
