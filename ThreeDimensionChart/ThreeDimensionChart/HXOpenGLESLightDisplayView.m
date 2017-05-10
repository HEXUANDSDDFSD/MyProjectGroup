//
//  HXOpenGLESBaseView.m
//  ThreeDimensionChart
//
//  Created by zwc on 16/3/9.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import "HXOpenGLESLightDisplayView.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "CC3GLMatrix.h"
#import "OpenGLESLight.h"
#import "OpenGLESFileManager.h"

#define kVertexGLSLFileName @"FirstVertex"
#define kFragmentGLSLFileName @"FirstFragment"

#define barEdgeNum 20
#define barNum 6

#define kSliderBaseTag 'ksbt'

@implementation HXOpenGLESLightDisplayView {
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
    OpenGLESLight *light;
    
    UIView *controlMenuView;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addControlMenu];
        [self initContext];
        
        [self initRenderBuffer];
        
        [self linkProgram];
        
        [self getSlots];
        
        [self produceData];
        
        _lightPosition = (MEVertex *)malloc(sizeof(MEVertex));
        
        light = [[OpenGLESLight alloc] init];
        
        [self initLights];
        
        [self updateSliderValue];
        
        ((CAEAGLLayer *)self.layer).opaque = YES;
        [self render:nil];
    }
    return self;
}

- (void)addControlMenu {
    controlMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height)];
    controlMenuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self addSubview:controlMenuView];
    
    CGFloat offsetTop = 40;
    NSArray *names = @[@"shininess:",@"ambient_r",@"ambient_g",@"ambient_b",@"specular_r",@"specular_g",@"specular_b",@"diffuse_r",@"diffuse_g",@"diffuse_b"];
    for (int i = 0; i < 10; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetTop, 85, 20)];
        label.text = names[i];
        label.textColor = [UIColor whiteColor];
        [controlMenuView addSubview:label];
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20 + label.bounds.size.width, label.frame.origin.y, controlMenuView.bounds.size.width - (20 + label.bounds.size.width) - 10, 40)];
        slider.tag = i + kSliderBaseTag;
        [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [controlMenuView addSubview:slider];
        offsetTop += 70;
    }
    
    CGFloat btnWidth = 80;
    CGFloat offsetRight = 30;
    CGFloat offsetBottom = 30;
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(self.bounds.size.width - btnWidth - offsetRight, self.bounds.size.height - offsetBottom - btnWidth, btnWidth, btnWidth);
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exitBtn];
    
    offsetRight += btnWidth + 60;
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(self.bounds.size.width - btnWidth - offsetRight, self.bounds.size.height - offsetBottom - btnWidth, btnWidth, btnWidth);
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveBtn];
    
    offsetRight += btnWidth + 60;
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(self.bounds.size.width - btnWidth - offsetRight, self.bounds.size.height - offsetBottom - btnWidth, btnWidth, btnWidth);
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refreshBtn];
}

- (void)saveAction {
    [OpenGLESFileManager saveLightData:light];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存成功！" message:@"" delegate:self cancelButtonTitle:@"继续编辑" otherButtonTitles:@"退出", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    if (buttonIndex == 1) {
        [self exitAction];
    }
}

- (void)exitAction {
    if ([self.delegate respondsToSelector:@selector(lightUpdate)]) {
        [self.delegate lightUpdate];
    }
    [self removeFromSuperview];
}

- (void)refreshAction {
    [self randomLights];
    [self updateSliderValue];
    [self render:nil];
}

- (void)updateSliderValue {
    for (int i = 0; i < 10; i++) {
        UISlider *slider = (UISlider *)[controlMenuView viewWithTag:kSliderBaseTag + i];
        switch (i) {
            case 0:
                slider.value = light.shininess;
                break;
            case 1:
                slider.value = light.ambient->r;
                break;
            case 2:
                slider.value = light.ambient->g;
                break;
            case 3:
                slider.value = light.ambient->b;
                break;
            case 4:
                slider.value = light.specular->r;
                break;
            case 5:
                slider.value = light.specular->g;
                break;
            case 6:
                slider.value = light.specular->b;
                break;
            case 7:
                slider.value = light.diffuse->r;
                break;
            case 8:
                slider.value = light.diffuse->g;
                break;
            case 9:
                slider.value = light.diffuse->b;
                break;
                
            default:
                break;
        }

    }
}

- (void)sliderValueChange:(UISlider *)slider {
    switch (slider.tag - kSliderBaseTag) {
        case 0:
            light.shininess = slider.value;
            break;
        case 1:
            light.ambient->r = slider.value;
            break;
        case 2:
            light.ambient->g = slider.value;
            break;
        case 3:
            light.ambient->b = slider.value;
            break;
        case 4:
            light.specular->r = slider.value;
            break;
        case 5:
            light.specular->g = slider.value;
            break;
        case 6:
            light.specular->b = slider.value;
            break;
        case 7:
            light.diffuse->r = slider.value;
            break;
        case 8:
            light.diffuse->g = slider.value;
            break;
        case 9:
            light.diffuse->b = slider.value;
            break;
            
        default:
            break;
    }
    [self render:nil];
}


- (GLuint)vertexCount {
    return barEdgeNum * 2;
}

- (GLuint)indiceCount {
    return barEdgeNum * 6 + 2 * (barEdgeNum - 2) * 3;
}

- (void)initLights {
    _lightPosition->x = 0.0;
    _lightPosition->y = 10.0;
    _lightPosition->z = 20.0;
    
    light.ambient->r = 0.3;
    light.ambient->g = 0.1;
    light.ambient->b = 0.0;
    light.ambient->a = 0.0;
    
    light.specular->r = 1.0;
    light.specular->b = 1.0;
    light.specular->g = 1.0;
    light.specular->a = 0.0;
    
    light.diffuse->r = 0.5;
    light.diffuse->g = 0.4;
    light.diffuse->b = 0.0;
    light.diffuse->a = 0.0;
    
    light.shininess = 1.0;
}

- (void)randomLights {
    
    light.ambient->r = arc4random() % 101 / 100.0;
    light.ambient->g = arc4random() % 101 / 100.0;
    light.ambient->b = arc4random() % 101 / 100.0;
    light.ambient->a = 1.0;
    
    light.specular->r = arc4random() % 101 / 100.0;
    light.specular->b = arc4random() % 101 / 100.0;
    light.specular->g = arc4random() % 101 / 100.0;
    light.specular->a = 1.0;
    
    light.diffuse->r = arc4random() % 101 / 100.0;
    light.diffuse->g = arc4random() % 101 / 100.0;
    light.diffuse->b = arc4random() % 101 / 100.0;
    light.diffuse->a = 1.0;
    
    light.shininess = arc4random() % 101 / 100.0;

}


- (void)setupLights {
    
    glUniform3f(lightPositionSlot, _lightPosition->x, _lightPosition->y, _lightPosition->z);
    glUniform4f(ambientSlot, light.ambient->r, light.ambient->g, light.ambient->b, light.ambient->a);
    glUniform4f(specularSlot, light.specular->r, light.specular->g, light.specular->b, light.specular->a);
    glVertexAttrib4f(diffuseSlot, light.diffuse->r, light.diffuse->g, light.diffuse->b, light.diffuse->a);
    glUniform1f(shininessSlot, light.shininess);
}
- (void)produceData {
    
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
}

- (void)render:(CADisplayLink*)displayLink {
    glClearColor(0.8, 0.8, 0.8, 1.0);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    [self configCamera];
    
    [self setupLights];
    
    glEnableVertexAttribArray(positionSlot);
    glEnableVertexAttribArray(normalSlot);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexTopBuffer);
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(MEVertex), 0);
    glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
    glVertexAttribPointer(normalSlot, 3, GL_FLOAT, GL_FALSE, sizeof(MENormal), 0);
    glDrawElements(GL_TRIANGLES, [self indiceCount], GL_UNSIGNED_BYTE, 0);
    
    glDisableVertexAttribArray(positionSlot);
    glDisableVertexAttribArray(normalSlot);
    
    
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
    
    glViewport(self.frame.size.width / 2, 0, self.frame.size.width / 2, self.frame.size.height);
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
