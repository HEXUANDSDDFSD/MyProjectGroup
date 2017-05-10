//
//  ChartDataFunc.m
//  ThreeDimensionChart
//
//  Created by zwc on 16/3/1.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import "ChartDataFunc.h"

@implementation ShapeDataFunc

+ (void)logVertex:(Vertex)vertex {
    NSLog(@"%f %f %f %f %f %f %f",vertex.Position[0],vertex.Position[1],vertex.Position[2],vertex.Color[0],vertex.Color[1],vertex.Color[2],vertex.Color[3]);
}

+ (void)ProduceBarData:(Vertex *)vertexs indice:(GLubyte *)indices xOffset:(GLfloat)xOffset radius:(GLfloat)radius height:(GLfloat)height edgeNum:(GLushort) edgeNum{
    for (int i = 0; i < edgeNum; i++) {
        vertexs[i * 2].Position[0] = sinf(i * (M_PI * 2 / edgeNum)) * radius + xOffset;
        vertexs[i * 2].Position[1] = 0;
        vertexs[i * 2].Position[2] = cosf(i * (M_PI * 2 / edgeNum)) * radius;
        vertexs[i * 2].Color[0] = 0.0;
        vertexs[i * 2].Color[1] = 0.7;
        vertexs[i * 2].Color[2] = 0.0;
        vertexs[i * 2].Color[3] = 1;
        vertexs[i * 2 + 1].Position[0] = sinf(i * (M_PI * 2 / edgeNum)) * radius + xOffset;;
        vertexs[i * 2 + 1].Position[1] = height;
        vertexs[i * 2 + 1].Position[2] = cosf(i * (M_PI * 2 / edgeNum)) * radius;;
        vertexs[i * 2 + 1].Color[0] = 0.0;
        vertexs[i * 2 + 1].Color[1] = 0.0;
        vertexs[i * 2 + 1].Color[2] = 0.7;
        vertexs[i * 2 + 1].Color[3] = 1;
        //[self logVertex:vertexs[i * 2]];
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
//    
//    for (int i = 0; i < edgeNum * 6; i++) {
//        NSLog(@"%d",indices[i]);
//    }
}

+ (Vector3D)Vector3DMakeWithStartVertex:(Vertex)beginVertex endPoints:(Vertex)endVertex{
    Vector3D vector;
    vector.x = endVertex.Position[0] - beginVertex.Position[0];
    vector.y = endVertex.Position[1] - beginVertex.Position[1];
    vector.z = endVertex.Position[2] - beginVertex.Position[2];
    return vector;
}

+ (void)ProduceNormalData:(Normal *)normals
                  vertexs:(Vertex *)vertexs
                vertexNum:(GLushort)vertexNum
                  indices:(GLubyte *)indices
                indiceNum:(GLushort)indiceNum {
    GLushort surfaceNum = indiceNum / 3;
    Vector3D *surfaceNormals = (Vector3D *)malloc(sizeof(Vector3D) * surfaceNum);
    
    for (int i = 0; i < surfaceNum; i++) {
        Vertex v1 = vertexs[indices[i * 3]];
        Vertex v2 = vertexs[indices[i * 3 + 1]];
        Vertex v3 = vertexs[indices[i * 3 + 2]];
        
        Vector3D u = [self Vector3DMakeWithStartVertex:v2 endPoints:v1];
        Vector3D v = [self Vector3DMakeWithStartVertex:v3 endPoints:v1];
        
        Vector3D surfaceNormal;
        surfaceNormal.x = (u.y * v.z) - (u.z * v.y);
        surfaceNormal.y = (u.z * v.x) - (u.x * v.z);
        surfaceNormal.z = (u.x * v.y) - (u.y * v.x);
        
        GLfloat normalLength = sqrtf(surfaceNormal.x * surfaceNormal.x + surfaceNormal.y * surfaceNormal.y + surfaceNormal.z * surfaceNormal.z);
        surfaceNormal.x /= normalLength;
        surfaceNormal.y /= normalLength;
        surfaceNormal.z /= normalLength;
    }
    
    for (int i = 0; i < vertexNum; i++)
    {
        normals[i].x = 0;
        normals[i].y = 0;
        normals[i].z = 0;
        
        int faceCount = 0;
        for (int j = 0; j < surfaceNum; j++)
        {
            BOOL contains = NO;
            for (int k = 0; k < 3; k++)
            {
                if (indices[(j * 3) + k] == i)
                    contains = YES;
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
        //NSLog(@"%f %f %f", normals[i].x,normals[i].y,normals[i].z);
    }
}

@end
