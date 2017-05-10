//
//  HXOpenGLESBaseView.m
//  ThreeDimensionChart
//
//  Created by zwc on 16/3/9.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import "HXOpenGLESBaseView.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "CC3GLMatrix.h"
#import "OpenGLESLight.h"

#define kVertexGLSLFileName @"FirstVertex"
#define kFragmentGLSLFileName @"FirstFragment"

#define barEdgeNum 20
#define barNum 6

@implementation HXOpenGLESBaseView {
    EAGLContext *ctx;
    CADisplayLink* displayLink;
    GLuint programHandle;
    
    GLuint projectionUniform;
    GLuint modelViewUniform;
    GLboolean useTextureUniform;
    GLuint positionSlot;
    GLuint colorSlot;
    
    GLuint normalMatrixSlot;
    GLuint lightPositionSlot;
    GLuint ambientSlot;
    GLuint specularSlot;
    GLuint shininessSlot;
    GLuint normalSlot;
    GLuint diffuseSlot;
    
    GLuint texture;
    GLuint texCoordSlot;
    GLuint textureUniform;
    GLuint *textureVertexBuffer;
    GLuint textureIndiceBuffer;
    GLuint textureCoordBuffer;
    
    GLuint *vertexBuffer;
    GLuint vertexTopBuffer;
    GLuint indiceBuffer;
    GLuint normalBuffer;
    
    CGFloat scale;
    
    MEVertex *_lightPosition;
    MEColor *_ambient;
    MEColor *_diffuse;
    MEColor *_specular;
    
    NSMutableArray *lightList;
}

//@synthesize lightPosition = _lightPosition;
//@synthesize ambient =_ambient;
//@synthesize diffuse = _diffuse;
//@synthesize specular = _specular;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initContext];
        
        [self initRenderBuffer];
        
        [self linkProgram];
        
        [self getSlots];
        
        
        [self initControl];
        [self produceData];
        
        _lightPosition = (MEVertex *)malloc(sizeof(MEVertex));
        _ambient = (MEColor *)malloc(sizeof(MEColor));
        _specular = (MEColor *)malloc(sizeof(MEColor));
        _diffuse = (MEColor *)malloc(sizeof(MEColor));
        
        [self setupLights];
        
        ((CAEAGLLayer *)self.layer).opaque = YES;
        
        //        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
        //        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
        [self addGestureRecognizer:pinchRecognizer];
        scale = 1.0;
        [self render:nil];
    }
    return self;
}

- (void)initControl {
    self.scaleY = 1;
    self.scaleX = 1;
    self.rowNum = 3;
    self.columnNum = 6;
    lightList = [NSMutableArray array];
}

- (void)scale:(UIPinchGestureRecognizer *)pinchRecognizer {
    static GLfloat _scale = 1.0;
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan) {
        _scale = scale;
    }
    scale = pinchRecognizer.scale * _scale;
}

- (GLuint)vertexCount {
    return barEdgeNum * 2;
}

- (GLuint)indiceCount {
    return barEdgeNum * 6 + 2 * (barEdgeNum - 2) * 3;
}

- (void)linkImage {
    CGImageRef spriteImage = [self drawDate:@"2016-12-13"].CGImage;
    //CGImageRef spriteImage = [UIImage imageNamed:@"left.png"].CGImage;
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
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    CGSize fontSize = [string sizeWithAttributes:attributes];
    UIGraphicsBeginImageContext(fontSize);
    CGContextRef tempCtx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(tempCtx, [UIColor whiteColor].CGColor);
    CGContextFillRect(tempCtx, CGRectMake(0, 0, fontSize.width, fontSize.height));
    [string drawAtPoint:CGPointMake(0, 0) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)setupLights {
    _lightPosition->x = 0.0;
    _lightPosition->y = 10.0;
    _lightPosition->z = 20.0;
    
    _ambient->r = 0.3;
    _ambient->g = 0.1;
    _ambient->b = 0.0;
    _ambient->a = 0.0;
    
    _specular->r = _specular->g = _specular->b = 1.0;
    _specular->a = 0.0;
    
    _diffuse->r = 0.5;
    _diffuse->g = 0.4;
    _diffuse->b = 0.0;
    _diffuse->a = 0.0;
    
    self.shininess = 1.0;
}

- (void)updateLights {
    glUniform3f(lightPositionSlot, _lightPosition->x, _lightPosition->y, _lightPosition->z);
    glUniform4f(ambientSlot, arc4random() % 101 / 100.0, arc4random() % 101 / 100.0, arc4random() % 101 / 100.0, _ambient->a);
    glUniform4f(specularSlot, arc4random() % 101 / 100.0, arc4random() % 101 / 100.0, arc4random() % 101 / 100.0, _specular->a);
    glVertexAttrib4f(diffuseSlot, arc4random() % 101 / 100.0, arc4random() % 101 / 100.0, arc4random() % 101 / 100.0, _diffuse->a);
    glUniform1f(shininessSlot, self.shininess);
}

//- (void)updateVertex {
//    static BOOL isIncrease = YES;
//    GLfloat currentHeight =  vertexs[1].y;
//    if (currentHeight > 8) {
//        isIncrease = NO;
//    }
//    else if (currentHeight < 0.5) {
//        isIncrease = YES;
//    }
//    if (isIncrease) {
//        for (int j = 0; j < barEdgeNum; j++) {
//            vertexs[j * 2 + 1].y += 0.1;
//        }
//    }
//    else {
//        for (int j = 0; j < barEdgeNum; j++) {
//            vertexs[j * 2 + 1].y -= 0.1;
//        }
//    }
//}

- (void)updateVertexData {
    if (vertexBuffer != NULL) {
        glDeleteBuffers(self.rowNum * self.columnNum, vertexBuffer);
        free(vertexBuffer);
        vertexBuffer = NULL;
    }
    
    [lightList removeAllObjects];
    for (int i = 0; i < self.rowNum; i++) {
        OpenGLESLight *light = [[OpenGLESLight alloc] init];
        light.ambient->r = arc4random() % 101 / 100.0;
        light.ambient->g = arc4random() % 101 / 100.0;
        light.ambient->b = arc4random() % 101 / 100.0;
        light.specular->r = arc4random() % 101 / 100.0;
        light.specular->g = arc4random() % 101 / 100.0;
        light.specular->b = arc4random() % 101 / 100.0;
        light.diffuse->r = arc4random() % 101 / 100.0;
        light.diffuse->g = arc4random() % 101 / 100.0;
        light.diffuse->b = arc4random() % 101 / 100.0;
        [lightList addObject:light];
    }
    
    vertexBuffer = malloc(sizeof(GLuint) * self.rowNum * self.columnNum);
    glGenBuffers(self.rowNum * self.columnNum, vertexBuffer);
    MEPoint basePoint = {0,0,0};
    for (int i = 0; i < self.rowNum; i++) {
        for (int j = 0; j < self.columnNum; j++) {
            MEVertex *vertexs = malloc([self vertexCount]  * sizeof(MEVertex));
            produceBarDataToVertex(vertexs, NULL, basePoint, 1, 4, barEdgeNum);
            glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer[i * self.columnNum + j]);
            glBufferData(GL_ARRAY_BUFFER, [self vertexCount] * sizeof(MEVertex), vertexs, GL_STREAM_DRAW);
            free(vertexs);
            vertexs = NULL;
            basePoint.x += 2.5;
        }
        basePoint.x = 0;
        basePoint.y += 4;
    }
    
    if (textureVertexBuffer != NULL) {
        glDeleteBuffers(self.columnNum, textureVertexBuffer);
        free(textureVertexBuffer);
        textureVertexBuffer = NULL;
    }
    
    textureVertexBuffer = malloc(sizeof(GLuint) * self.columnNum);
    glGenBuffers(self.columnNum, textureVertexBuffer);
    for (int i = 0; i < self.columnNum; i++) {
        MEVertex textureVertexs[] = {{-1 + i * 2.5,0,2},{1+ i * 2.5,0,2},{1+ i * 2.5,0.5,2},{-1+ i * 2.5,0.5,2}};
        glBindBuffer(GL_ARRAY_BUFFER, textureVertexBuffer[i]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(MEVertex) * 4, textureVertexs, GL_STATIC_COPY);
        
    }
}

- (void)produceData {
//    vertexBuffer = malloc(sizeof(GLuint) * barNum);
//    glGenBuffers(barNum, vertexBuffer);
    
    [self updateVertexData];
    glGenBuffers(1, &vertexTopBuffer);
    glGenBuffers(1, &indiceBuffer);
    glGenBuffers(1, &normalBuffer);
    glGenBuffers(1, &textureIndiceBuffer);
    glGenBuffers(1, &textureCoordBuffer);
    
//    for (int i = 0; i < barNum; i++) {
//        vertexs[i] = malloc([self vertexCount]  * sizeof(MEVertex));
//        produceBarDataToVertex(vertexs[i], NULL, basePoint, 1, 4, barEdgeNum);
//        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer[i]);
//        glBufferData(GL_ARRAY_BUFFER, [self vertexCount] * sizeof(MEVertex), vertexs[i], GL_STREAM_DRAW);
//        basePoint.x += 2.5;
//    }
    
    
    MEPoint basePoint = {0,0,0};
    MEVertex *vertexTops = malloc([self vertexCount]  * sizeof(MEVertex));
    GLubyte *indices = malloc([self indiceCount] * sizeof(GLubyte));
    MENormal *normals = malloc([self vertexCount] * sizeof(MENormal));
    
    basePoint.x = 0;
    basePoint.y = 4;
    produceBarDataToVertex(vertexTops, indices, basePoint, 1, 4, barEdgeNum);
    produceNormalDataWithVertex(normals, vertexTops, [self vertexCount], indices, [self indiceCount]);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexTopBuffer);
    glBufferData(GL_ARRAY_BUFFER, [self vertexCount] * sizeof(MEVertex), vertexTops, GL_STREAM_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indiceBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self indiceCount] * sizeof(GLubyte), indices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
    glBufferData(GL_ARRAY_BUFFER, [self vertexCount] * sizeof(MENormal), normals, GL_STATIC_DRAW);
    
    free(indices);
    free(normals);
    
    [self linkImage];
    
    GLubyte textureIndice[] = {0,1,2,0,2,3};
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, textureIndiceBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLubyte) * 6, textureIndice, GL_STATIC_COPY);
    
    METextureCoord textureCoord[] = {{0.0,1.0},{1.0,1.0},{1.0,0.0},{0.0,0.0}};
    glBindBuffer(GL_ARRAY_BUFFER, textureCoordBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(METextureCoord) * 4, textureCoord, GL_STATIC_COPY);
}

- (void)render:(CADisplayLink*)displayLink {
    glClearColor(0.8, 0.8, 0.8, 1.0);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    [self configCamera];
    
    
    glUniform1ui(useTextureUniform, 0);
    for (int i = 0; i < self.rowNum; i++) {
        OpenGLESLight *light = lightList[i];
        glUniform3f(lightPositionSlot, _lightPosition->x, _lightPosition->y, _lightPosition->z);
        glUniform4f(ambientSlot, light.ambient->r, light.ambient->g, light.ambient->b, _ambient->a);
        glUniform4f(specularSlot, light.specular->r, light.specular->r, light.specular->r, _specular->a);
        glVertexAttrib4f(diffuseSlot, light.diffuse->r, light.diffuse->r, light.diffuse->r, _diffuse->a);
        glUniform1f(shininessSlot, self.shininess);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indiceBuffer);
        for (int j = 0; j < self.columnNum; j++) {
            glEnableVertexAttribArray(positionSlot);
            //glEnableVertexAttribArray(colorSlot);
            glEnableVertexAttribArray(normalSlot);
            
            glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer[i * self.columnNum + j]);
            //  [self updateVertex];
            //    glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(MEVertex) * [self vertexCount], vertexs);
            glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(MEVertex), 0);
            //    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(MEVertexColor), (GLvoid*)(sizeof(float) * 3));
            glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
            glVertexAttribPointer(normalSlot, 3, GL_FLOAT, GL_FALSE, sizeof(MENormal), 0);
            glDrawElements(GL_TRIANGLES, [self indiceCount], GL_UNSIGNED_BYTE, 0);
            
            glDisableVertexAttribArray(positionSlot);
            //glDisableVertexAttribArray(colorSlot);
            glDisableVertexAttribArray(normalSlot);
        }
    }
    
    glUniform1ui(useTextureUniform, 1);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    [modelView populateFromRotation:CC3VectorMake(0 , 0, 0)];
    [modelView scaleBy:CC3VectorMake(self.scaleX, self.scaleX, 1)];
    glUniformMatrix4fv(modelViewUniform, 1, 0, modelView.glMatrix);
    
    for (int i = 0; i < self.columnNum; i++) {
        glEnableVertexAttribArray(positionSlot);
        glEnableVertexAttribArray(texCoordSlot);
        
        glBindBuffer(GL_ARRAY_BUFFER, textureVertexBuffer[i]);
        glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(MEVertex), 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, textureIndiceBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, textureCoordBuffer);
        glVertexAttribPointer(texCoordSlot, 2, GL_FLOAT, GL_FALSE,
                              sizeof(METextureCoord), 0);
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texture);
        glUniform1i(textureUniform, 0);
        
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
        glDisableVertexAttribArray(texCoordSlot);
        glDisableVertexAttribArray(positionSlot);
    }
    
    
//    glUniform3f(lightPositionSlot, _lightPosition->x, _lightPosition->y, _lightPosition->z);
//    glUniform4f(ambientSlot, _ambient->r, _ambient->g, 0.8, _ambient->a);
//    glUniform4f(specularSlot, _specular->r, _specular->g, _specular->b, _specular->a);
//    glVertexAttrib4f(diffuseSlot, _diffuse->r, _diffuse->g, _diffuse->b, _diffuse->a);
//    glUniform1f(shininessSlot, self.shininess);
//    glEnableVertexAttribArray(positionSlot);
//    //glEnableVertexAttribArray(colorSlot);
//    glEnableVertexAttribArray(normalSlot);
//    
//    glBindBuffer(GL_ARRAY_BUFFER, vertexTopBuffer);
//    //  [self updateVertex];
//    //    glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(MEVertex) * [self vertexCount], vertexs);
//    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(MEVertex), 0);
//    //    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(MEVertexColor), (GLvoid*)(sizeof(float) * 3));
//    glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
//    glVertexAttribPointer(normalSlot, 3, GL_FLOAT, GL_FALSE, sizeof(MENormal), 0);
//    glDrawElements(GL_TRIANGLES, [self indiceCount], GL_UNSIGNED_BYTE, 0);
//    
//    glDisableVertexAttribArray(positionSlot);
//    //glDisableVertexAttribArray(colorSlot);
//    glDisableVertexAttribArray(normalSlot);
    
    
    [ctx presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)initRenderBuffer {
    GLuint depthRenderBuffer;
    glGenRenderbuffers(1, &depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.bounds.size.width, self.bounds.size.height);
    
    GLuint colorRenderBuffer;
    glGenRenderbuffers(1, &colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    [ctx renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
    
    glEnable(GL_DEPTH_TEST);
    
    glEnable(GL_BLEND_DST_ALPHA);
    glBlendFunc(GL_ONE, GL_ZERO);
}

- (void)getSlots {
    positionSlot = glGetAttribLocation(programHandle, "Position");
    colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    projectionUniform = glGetUniformLocation(programHandle, "Projection");
    modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    
    normalMatrixSlot = glGetUniformLocation(programHandle, "normalMatrix");
    lightPositionSlot = glGetUniformLocation(programHandle, "vLightPosition");
    ambientSlot = glGetUniformLocation(programHandle, "vAmbientMaterial");
    specularSlot = glGetUniformLocation(programHandle, "vSpecularMaterial");
    shininessSlot = glGetUniformLocation(programHandle, "shininess");
    
    useTextureUniform = glGetUniformLocation(programHandle, "useTexture");
    
    normalSlot = glGetAttribLocation(programHandle, "vNormal");
    diffuseSlot = glGetAttribLocation(programHandle, "vDiffuseMaterial");
    
    texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    textureUniform = glGetUniformLocation(programHandle, "Texture");
}

- (void)configCamera {
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    float width = 18;
    float h = width * self.frame.size.height / self.frame.size.width;
    static int i = 0;
    i++;
    
    [projection populateOrthoFromFrustumLeft:-width / 2 andRight:width / 2 andBottom:-h/2 andTop:h/2 andNear:5 andFar:50];
    //[projection populateFromFrustumLeft:-width / 2 andRight:width / 2 andBottom:-h/2 andTop:h/2 andNear:6 andFar:50];
    [projection translateByZ:-18];
     [projection translateByY:-5];
    [projection translateByX:-7];
    [projection rotateByX:M_PI_2 * 10];
    //[projection rotateByY:M_PI_2 * i];
    glUniformMatrix4fv(projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    [modelView populateFromRotation:CC3VectorMake(0 , 0, 0)];
    [modelView scaleBy:CC3VectorMake(self.scaleX, self.scaleY, 1)];
    glUniformMatrix4fv(modelViewUniform, 1, 0, modelView.glMatrix);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
}

- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType {
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (shaderString.length == 0) {
        NSLog(@"error loading shader:%@", error.localizedDescription);
        return 0;
    }
    const char* shaderStringUTF8 = [shaderString UTF8String];
    GLint shaderStringLength = (GLint)[shaderString length];

    return compileShader(shaderStringUTF8, &shaderStringLength, shaderType);
}

- (void)linkProgram {
    programHandle = glCreateProgram();
    GLuint vertexShader = [self compileShader:kVertexGLSLFileName withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:kFragmentGLSLFileName withType:GL_FRAGMENT_SHADER];
    linkShader(programHandle, vertexShader, fragmentShader);
    glUseProgram(programHandle);
}

- (void)initContext {
    ctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:ctx];
    
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

@end
