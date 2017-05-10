//
//  OpenGLES_C_Func.h
//  ThreeDimensionChart
//
//  Created by zwc on 16/3/10.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#ifndef OpenGLES_C_Func_h
#define OpenGLES_C_Func_h

#include <stdio.h>
#import <OpenGLES/ES3/gl.h>

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
}MEVertex;

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
}MEPoint;

typedef struct {
    GLfloat r;
    GLfloat g;
    GLfloat b;
    GLfloat a;
}MEColor;

typedef struct {
    MEVertex vertex;
    MEColor color;
}MEVertexColor;

typedef struct{
    GLfloat x;
    GLfloat y;
    GLfloat z;
} MENormal;

typedef struct {
    MEVertex vertex;
    MENormal normal;
}MEVertexNormal;

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
}MEVector3D;

typedef struct {
    GLfloat x;
    GLfloat y;
}METextureCoord;

GLuint compileShader(const char *shaderString, GLint* shaderPathLength, GLenum shaderType);
void linkShader(GLuint programHandle,GLuint vertexShader,GLuint fragmentShader);

void produceBarData(MEVertexColor *vertexColors,GLubyte *indices, GLfloat xOffset, GLfloat radius, GLfloat height, GLushort edgeNum);

void produceBarDataToVertex(MEVertex *vertexs,GLubyte *indices, MEPoint basePoint, GLfloat radius, GLfloat height, GLushort edgeNum);

void produceNormalData(MENormal * normals,
                       const MEVertexColor * const vertexs,
                       GLushort vertexNum,
                       const  GLubyte * const indices,
                       GLushort indiceNum);

void produceNormalDataWithVertexNormal(MENormal * normals,
                                       const MEVertexNormal * const vertexs,
                                       GLushort vertexNum,
                                       const  GLubyte * const indices,
                                       GLushort indiceNum);

void produceNormalDataWithVertex(MENormal * normals,
                                 const MEVertex * const vertexs,
                                 GLushort vertexNum,
                                 const  GLubyte * const indices,
                                 GLushort indiceNum);

#endif /* OpenGLES_C_Func_h */
