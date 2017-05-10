//
//  OpenGLESLocalLightView.m
//  ThreeDimensionChart
//
//  Created by zwc on 16/4/15.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import "OpenGLESLocalLightView.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "CC3GLMatrix.h"
#import "OpenGLESLight.h"
#import "OpenGLESFileManager.h"
#import "HXOpenGLESLightDisplayView.h"

#define kVertexGLSLFileName @"FirstVertex"
#define kFragmentGLSLFileName @"FirstFragment"

#define barEdgeNum 20
#define barNum 6

#define kDeleteBtnBaseTag 'dbbt'

#define kRowNum 4
#define kColumnNmu 5

@interface OpenGLESLocalLightView()<HXOpenGLESLightDisplayViewDelegate>

@end

@implementation OpenGLESLocalLightView {
    EAGLContext *ctx;
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
    
    GLuint *vertexBuffer;
    GLuint vertexTopBuffer;
    GLuint indiceBuffer;
    GLuint normalBuffer;
    
    MEVertex *_lightPosition;
    NSArray *lightList;
    CADisplayLink *displayLink;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initContext];
        
        [self initRenderBuffer];
        
        [self linkProgram];
        
        [self getSlots];
        
        [self produceData];
        
        _lightPosition = (MEVertex *)malloc(sizeof(MEVertex));
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        addBtn.frame = CGRectMake(self.bounds.size.width - 80 - 20, self.bounds.size.height - 80 - 60, 80, 80);
        [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        delBtn.frame = CGRectMake(addBtn.frame.origin.x - 80 - 20, self.bounds.size.height - 80 - 60, 80, 80);
        [delBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delBtn];
        
        ((CAEAGLLayer *)self.layer).opaque = YES;
        [self render:nil];
    }
    return self;
}

- (void)addAction {
    [self removeDeleteBtn];
    HXOpenGLESLightDisplayView *view = [[HXOpenGLESLightDisplayView alloc] initWithFrame:self.bounds];
    view.delegate = self;
    [self addSubview:view];
}

- (void)addDeleteBtn {
    CGFloat everyWidth = self.frame.size.width / kColumnNmu;
    CGFloat everyHeight = self.frame.size.height / kRowNum;
    for (int i = 0; i < [lightList count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = kDeleteBtnBaseTag + i;
        [button setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(everyWidth * (i % kColumnNmu) + 20, everyHeight * (i / 5) + 20, 40, 40);
        [self addSubview:button];
    }
}

- (void)removeDeleteBtn {
    for (UIView *subView in [self subviews]) {
        if (subView.tag >= kDeleteBtnBaseTag) {
            [subView removeFromSuperview];
        }
    }
}

- (void)removeAction:(UIButton *)sender {
    [OpenGLESFileManager removeLightAtIndex:sender.tag - kDeleteBtnBaseTag];
    lightList = [OpenGLESFileManager lightList];
    [self removeDeleteBtn];
    [self addDeleteBtn];
    [self render:nil];
}

- (void)deleteAction {
    static BOOL show = YES;
    if (show) {
        [self addDeleteBtn];
    }
    else {
        [self removeDeleteBtn];
    }
    
    show = !show;
}

- (void)lightUpdate {
     [EAGLContext setCurrentContext:ctx];
    lightList = [OpenGLESFileManager lightList];
    [self render:nil];
}

- (GLuint)vertexCount {
    return barEdgeNum * 2;
}

- (GLuint)indiceCount {
    return barEdgeNum * 6 + 2 * (barEdgeNum - 2) * 3;
}

- (void)setupLights:(OpenGLESLight *)light {
    _lightPosition->x = 0.0;
    _lightPosition->y = 10.0;
    _lightPosition->z = 20.0;
    
    glUniform3f(lightPositionSlot, _lightPosition->x, _lightPosition->y, _lightPosition->z);
    glUniform4f(ambientSlot, light.ambient->r, light.ambient->g, light.ambient->b, light.ambient->a);
    glUniform4f(specularSlot, light.specular->r, light.specular->g, light.specular->b, light.specular->a);
    glVertexAttrib4f(diffuseSlot, light.diffuse->r, light.diffuse->g, light.diffuse->b, light.diffuse->a);
    glUniform1f(shininessSlot, light.shininess);
}

- (void)produceData {
    lightList = [OpenGLESFileManager lightList];
    glGenBuffers(1, &vertexTopBuffer);
    glGenBuffers(1, &indiceBuffer);
    glGenBuffers(1, &normalBuffer);

    MEPoint basePoint = {0,0,0};
    MEVertex *vertexTops = malloc([self vertexCount]  * sizeof(MEVertex));
    GLubyte *indices = malloc([self indiceCount] * sizeof(GLubyte));
    MENormal *normals = malloc([self vertexCount] * sizeof(MENormal));
    
    basePoint.x = 0;
    basePoint.y = 4;
    
    produceBarDataToVertex(vertexTops, indices, basePoint, 6, 4, barEdgeNum);
    produceNormalDataWithVertex(normals, vertexTops, [self vertexCount], indices, [self indiceCount]);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexTopBuffer);
    glBufferData(GL_ARRAY_BUFFER, [self vertexCount] * sizeof(MEVertex), vertexTops, GL_STREAM_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indiceBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self indiceCount] * sizeof(GLubyte), indices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
    glBufferData(GL_ARRAY_BUFFER, [self vertexCount] * sizeof(MENormal), normals, GL_STATIC_DRAW);
    
    free(indices);
    free(normals);
    free(vertexTops);
}

- (void)render:(CADisplayLink*)displayLink {
    glClearColor(0.8, 0.8, 0.8, 1.0);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    [self configCamera];
    static int y = 0;
    y++;
    
    CGFloat everyWidth = self.frame.size.width / kColumnNmu;
    CGFloat everyHeight = self.frame.size.height / kRowNum;
    CGFloat currentHeight = self.frame.size.height;
    for (int i = 0; i < [lightList count]; i++) {
        if (i % kColumnNmu == 0) {
            currentHeight -= everyHeight;
        }
        glViewport(everyWidth * (i % kColumnNmu), currentHeight, everyWidth, everyHeight);
        [self setupLights:lightList[i]];
        glEnableVertexAttribArray(positionSlot);
        glEnableVertexAttribArray(normalSlot);
        
        glBindBuffer(GL_ARRAY_BUFFER, vertexTopBuffer);
        glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(MEVertex), 0);
        glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
        glVertexAttribPointer(normalSlot, 3, GL_FLOAT, GL_FALSE, sizeof(MENormal), 0);
        glDrawElements(GL_TRIANGLES, [self indiceCount], GL_UNSIGNED_BYTE, 0);
        
        glDisableVertexAttribArray(positionSlot);
        glDisableVertexAttribArray(normalSlot);
    }
    
    
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
    [projection rotateByX:M_PI_2 * 10];
    //[projection rotateByY:M_PI_2 * i];
    glUniformMatrix4fv(projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    [modelView populateFromRotation:CC3VectorMake(0 , 0, 0)];
    [modelView scaleBy:CC3VectorMake(1, 1, 1)];
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

