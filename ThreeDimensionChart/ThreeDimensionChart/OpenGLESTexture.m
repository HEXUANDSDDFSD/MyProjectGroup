//
//  OpenGLESTexture.m
//  ThreeDimensionChart
//
//  Created by zwc on 16/4/14.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import "OpenGLESTexture.h"
#import "OpenGLES_C_Func.h"

@implementation OpenGLESTexture {
    GLuint texture;
    GLuint texCoordSlot;
    GLuint textureUniform;
}

- (instancetype)initWithProgramHandle:(GLuint)programHandle {
    if (self = [super init]) {
        [self linkImage];
        texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
        textureUniform = glGetUniformLocation(programHandle, "Texture");
    }
    return self;
}

- (void)linkImage {
    CGImageRef spriteImage = [self drawDate:@"2016-12-13"].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load imge");
    }
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    GLubyte *spriteData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    free(spriteData);

}


- (UIImage *)drawDate:(NSString *)string {
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:30]};
    UIGraphicsBeginImageContext([string sizeWithAttributes:attributes]);
    [string drawAtPoint:CGPointMake(0, 0) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
