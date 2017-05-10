//
//  OpenGLES_C_Func.c
//  ThreeDimensionChart
//
//  Created by zwc on 16/3/10.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#include "OpenGLES_C_Func.h"
#include <math.h>
#include <stdlib.h>
#import <OpenGLES/ES3/glext.h>

GLuint compileShader(const char *shaderString, GLint *shaderPathLength, GLenum shaderType) {
    if (shaderPathLength == 0) {
        printf("shaderPathLength error");
        return 0;
    }
    GLuint shaderHandle = glCreateShader(shaderType);
    glShaderSource(shaderHandle, 1, &shaderString, shaderPathLength);
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        printf("shader compile failure...");
        return 0;
    }
    
    return shaderHandle;
}

void linkShader(GLuint programHandle,GLuint vertexColorshader,GLuint fragmentShader){
    glAttachShader(programHandle, vertexColorshader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        printf("link error....");
        return;
    }

}

void logVertex(MEVertexColor vertexColors) {
    printf("%f %f %f %f %f %f %f\n",vertexColors.vertex.x, vertexColors.vertex.y,vertexColors.vertex.z,vertexColors.color.r,vertexColors.color.g,vertexColors.color.b,vertexColors.color.a);
}

void produceBarDataToVertex(MEVertex *vertexs,GLubyte *indices, MEPoint basePoint, GLfloat radius, GLfloat height, GLushort edgeNum) {
    for (int i = 0; i < edgeNum; i++) {
        vertexs[i * 2].x = sinf(i * (M_PI * 2 / edgeNum)) * radius + basePoint.x;
        vertexs[i * 2].y = basePoint.y;
        vertexs[i * 2].z = cosf(i * (M_PI * 2 / edgeNum)) * radius;
        vertexs[i * 2 + 1].x = sinf(i * (M_PI * 2 / edgeNum)) * radius + basePoint.x;;
        vertexs[i * 2 + 1].y = height + basePoint.y;
        vertexs[i * 2 + 1].z = cosf(i * (M_PI * 2 / edgeNum)) * radius;;
        //logVertex(vertexColors[i * 2 + 1]);
        //[self logVertex:vertexColors[i * 2]];
    }
    
    if (indices == NULL) {
        return;
    }
    
    for (int i = 0; i < edgeNum; i++) {
        indices[i * 6] = i * 2;
        indices[i * 6 + 1] = (i * 2 + 2) % (edgeNum * 2);
        indices[i * 6 + 2] = i * 2 + 1;
        indices[i * 6 + 3] = (i * 2 + 3)  % (edgeNum * 2);
        indices[i * 6 + 4] = i * 2 + 1;
        indices[i * 6 + 5] = (i * 2 + 2) % (edgeNum * 2);
    }
    
    for (int i = edgeNum,j = 0; i < edgeNum + edgeNum - 2; i++,j++) {
        indices[i * 6] = 0;
        indices[i * 6 + 1] = 2 * j + 2;
        indices[i * 6 + 2] = 2 * j + 4;
        indices[i * 6 + 3] = 1;
        indices[i * 6 + 4] = 2 * j + 3;
        indices[i * 6 + 5] = 2 * j + 5;
    }
}

void produceBarData(MEVertexColor *vertexColors,GLubyte *indices, GLfloat xOffset, GLfloat radius, GLfloat height, GLushort edgeNum) {
    for (int i = 0; i < edgeNum; i++) {
        vertexColors[i * 2].vertex.x = sinf(i * (M_PI * 2 / edgeNum)) * radius + xOffset;
        vertexColors[i * 2].vertex.y = 0;
        vertexColors[i * 2].vertex.z = cosf(i * (M_PI * 2 / edgeNum)) * radius;
        vertexColors[i * 2].color.r = 0.0;
        vertexColors[i * 2].color.g = 0.7;
        vertexColors[i * 2].color.b = 0.0;
        vertexColors[i * 2].color.a = 1;
        vertexColors[i * 2 + 1].vertex.x = sinf(i * (M_PI * 2 / edgeNum)) * radius + xOffset;;
        vertexColors[i * 2 + 1].vertex.y = height;
        vertexColors[i * 2 + 1].vertex.z = cosf(i * (M_PI * 2 / edgeNum)) * radius;;
        vertexColors[i * 2 + 1].color.r = 0.0;
        vertexColors[i * 2 + 1].color.g = 0.0;
        vertexColors[i * 2 + 1].color.b = 0.7;
        vertexColors[i * 2 + 1].color.a = 1;
        //logVertex(vertexColors[i * 2 + 1]);
        //[self logVertex:vertexColors[i * 2]];
    }
    
    if (indices == NULL) {
        return;
    }
    
    for (int i = 0; i < edgeNum; i++) {
        indices[i * 6] = i * 2;
        indices[i * 6 + 1] = (i * 2 + 2) % (edgeNum * 2);
        indices[i * 6 + 2] = i * 2 + 1;
        indices[i * 6 + 3] = (i * 2 + 3)  % (edgeNum * 2);
        indices[i * 6 + 4] = i * 2 + 1;
        indices[i * 6 + 5] = (i * 2 + 2) % (edgeNum * 2);
    }
    
    for (int i = edgeNum,j = 0; i < edgeNum + edgeNum - 2; i++,j++) {
        indices[i * 6] = 0;
        indices[i * 6 + 1] = 2 * j + 2;
        indices[i * 6 + 2] = 2 * j + 4;
        indices[i * 6 + 3] = 1;
        indices[i * 6 + 4] = 2 * j + 3;
        indices[i * 6 + 5] = 2 * j + 5;
    }
}

MEVector3D calculateVector(MEVertex beginVertex, MEVertex endVertex){
    MEVector3D vector;
    vector.x = endVertex.x - beginVertex.x;
    vector.y = endVertex.y - beginVertex.y;
    vector.z = endVertex.z - beginVertex.z;
    return vector;
}

void produceNormalData(MENormal * normals,
const MEVertexColor * const vertexs,
GLushort vertexNum,
const  GLubyte * const indices,
GLushort indiceNum) {
    GLushort surfaceNum = indiceNum / 3;
    MENormal *surfaceNormals = (MENormal *)malloc(sizeof(MENormal) * surfaceNum);
    
    for (int i = 0; i < surfaceNum; i++) {
        MEVertex v1 = vertexs[indices[i * 3]].vertex;
        MEVertex v2 = vertexs[indices[i * 3 + 1]].vertex;
        MEVertex v3 = vertexs[indices[i * 3 + 2]].vertex;
        
        MEVector3D u = calculateVector(v2, v1);
        MEVector3D v = calculateVector(v3, v1);
        
        MENormal surfaceNormal;
        surfaceNormal.x = (u.y * v.z) - (u.z * v.y);
        surfaceNormal.y = (u.z * v.x) - (u.x * v.z);
        surfaceNormal.z = (u.x * v.y) - (u.y * v.x);
        
        GLfloat normalLength = sqrtf(surfaceNormal.x * surfaceNormal.x + surfaceNormal.y * surfaceNormal.y + surfaceNormal.z * surfaceNormal.z);
        surfaceNormal.x /= normalLength;
        surfaceNormal.y /= normalLength;
        surfaceNormal.z /= normalLength;
        surfaceNormals[i] = surfaceNormal;
    }
    
    for (int i = 0; i < vertexNum; i++)
    {
        normals[i].x = 0;
        normals[i].y = 0;
        normals[i].z = 0;
        
        int faceCount = 0;
        for (int j = 0; j < surfaceNum; j++)
        {
            GLboolean contains = GL_FALSE;
            for (int k = 0; k < 3; k++)
            {
                if (indices[(j * 3) + k] == i)
                    contains = GL_TRUE;
            }
            if (contains)
            {
                faceCount++;
                normals[i].x += surfaceNormals[j].x;
                normals[i].y += surfaceNormals[j].y;
                normals[i].z += surfaceNormals[j].z;
            }
        }
        
        normals[i].x /= (GLfloat)faceCount;
        normals[i].y /= (GLfloat)faceCount;
        normals[i].z /= (GLfloat)faceCount;
    }
     free(surfaceNormals);
}

void produceNormalDataWithVertexNormal(MENormal * normals,
                       const MEVertexNormal * const vertexs,
                       GLushort vertexNum,
                       const  GLubyte * const indices,
                       GLushort indiceNum) {
    GLushort surfaceNum = indiceNum / 3;
    MENormal *surfaceNormals = (MENormal *)malloc(sizeof(MENormal) * surfaceNum);
    
    for (int i = 0; i < surfaceNum; i++) {
        MEVertex v1 = vertexs[indices[i * 3]].vertex;
        MEVertex v2 = vertexs[indices[i * 3 + 1]].vertex;
        MEVertex v3 = vertexs[indices[i * 3 + 2]].vertex;
        
        MEVector3D u = calculateVector(v2, v1);
        MEVector3D v = calculateVector(v3, v1);
        
        MENormal surfaceNormal;
        surfaceNormal.x = (u.y * v.z) - (u.z * v.y);
        surfaceNormal.y = (u.z * v.x) - (u.x * v.z);
        surfaceNormal.z = (u.x * v.y) - (u.y * v.x);
        
        GLfloat normalLength = sqrtf(surfaceNormal.x * surfaceNormal.x + surfaceNormal.y * surfaceNormal.y + surfaceNormal.z * surfaceNormal.z);
        surfaceNormal.x /= normalLength;
        surfaceNormal.y /= normalLength;
        surfaceNormal.z /= normalLength;
        surfaceNormals[i] = surfaceNormal;
    }
    
    for (int i = 0; i < vertexNum; i++)
    {
        normals[i].x = 0;
        normals[i].y = 0;
        normals[i].z = 0;
        
        int faceCount = 0;
        for (int j = 0; j < surfaceNum; j++)
        {
            GLboolean contains = GL_FALSE;
            for (int k = 0; k < 3; k++)
            {
                if (indices[(j * 3) + k] == i)
                    contains = GL_TRUE;
            }
            if (contains)
            {
                faceCount++;
                normals[i].x += surfaceNormals[j].x;
                normals[i].y += surfaceNormals[j].y;
                normals[i].z += surfaceNormals[j].z;
            }
        }
        
        normals[i].x /= (GLfloat)faceCount;
        normals[i].y /= (GLfloat)faceCount;
        normals[i].z /= (GLfloat)faceCount;
        printf("%f %f %f\n", normals[i].x, normals[i].y, normals[i].z);
    }
    free(surfaceNormals);
}


void produceNormalDataWithVertex(MENormal * normals,
                                       const MEVertex * const vertexs,
                                       GLushort vertexNum,
                                       const  GLubyte * const indices,
                                       GLushort indiceNum) {
    GLushort surfaceNum = indiceNum / 3;
    MENormal *surfaceNormals = (MENormal *)malloc(sizeof(MENormal) * surfaceNum);
    
    for (int i = 0; i < surfaceNum; i++) {
        MEVertex v1 = vertexs[indices[i * 3]];
        MEVertex v2 = vertexs[indices[i * 3 + 1]];
        MEVertex v3 = vertexs[indices[i * 3 + 2]];
        
        MEVector3D u = calculateVector(v2, v1);
        MEVector3D v = calculateVector(v3, v1);
        
        MENormal surfaceNormal;
        surfaceNormal.x = (u.y * v.z) - (u.z * v.y);
        surfaceNormal.y = (u.z * v.x) - (u.x * v.z);
        surfaceNormal.z = (u.x * v.y) - (u.y * v.x);
        
        GLfloat normalLength = sqrtf(surfaceNormal.x * surfaceNormal.x + surfaceNormal.y * surfaceNormal.y + surfaceNormal.z * surfaceNormal.z);
        surfaceNormal.x /= normalLength;
        surfaceNormal.y /= normalLength;
        surfaceNormal.z /= normalLength;
        surfaceNormals[i] = surfaceNormal;
    }
    
    for (int i = 0; i < vertexNum; i++)
    {
        normals[i].x = 0;
        normals[i].y = 0;
        normals[i].z = 0;
        
        int faceCount = 0;
        for (int j = 0; j < surfaceNum; j++)
        {
            GLboolean contains = GL_FALSE;
            for (int k = 0; k < 3; k++)
            {
                if (indices[(j * 3) + k] == i)
                    contains = GL_TRUE;
            }
            if (contains)
            {
                faceCount++;
                normals[i].x += surfaceNormals[j].x;
                normals[i].y += surfaceNormals[j].y;
                normals[i].z += surfaceNormals[j].z;
            }
        }
        
        normals[i].x /= (GLfloat)faceCount;
        normals[i].y /= (GLfloat)faceCount;
        normals[i].z /= (GLfloat)faceCount;
    }
    free(surfaceNormals);
}


