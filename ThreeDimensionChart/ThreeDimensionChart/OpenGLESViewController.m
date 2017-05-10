//
//  OpenGLESViewController.m
//  OpenGLESTest
//
//  Created by zwc on 15/5/8.
//  Copyright (c) 2015年 MYSTERIOUS. All rights reserved.
//

#import "OpenGLESViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "CC3GLMatrix.h"
#import "ChartDataFunc.h"
#import "HXOpenGLESBaseView.h"
#import "OpenGLESLocalLightView.h"

#define barEdgeNum 4

const Vertex Vertices[] = {
    {{1, -2, 1}, {1, 0, 0, 1}},
    {{1, 1, 1}, {1, 0.5, 0, 1}},
    {{-1, 1, 1}, {0, 0.4, 0.8, 1}},
    {{-1, -1, 1}, {0.2, 1, 0, 1}},
    {{1, -1, -1}, {1, 0, 0, 1}},
    {{1, 1, -1}, {1, 0.4, 0, 1}},
    {{-1, 1, -1}, {0, 1, 0, 1}},
    {{-1, -1, -1}, {0.7, 1, 0, 1}}
};

const GLubyte Indices[] = {
//    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 6, 5,
    4, 7, 6,
    // Left
    2, 7, 3,
    7, 6, 2,
    // Right
    0, 4, 1,
    4, 1, 5,
    // Top
    6, 2, 1,
    1, 6, 5,
    // Bottom
    0, 3, 7,
    0, 7, 4
};

@interface OpenGLESView : UIView

@end

@implementation OpenGLESView {
    CAEAGLLayer *eaglLayer;
    EAGLContext *eaglCtx;
    GLuint colorRenderBuffer;
//    GLuint texture;
    //    GLuint texCoordSlot;
    //    GLuint textureUniform;
    GLuint depthRenderBuffer;
    GLuint positionSlot;
    GLuint colorSlot;
    GLuint projectionUniform;
    GLuint modelViewUniform;
    GLubyte *indices;
    Vertex *vertexList[10];
    GLuint *vertexBuffer;
    GLuint indexBuffer;
    GLuint lineVertexBuffer;
    GLuint lineIndiceBuffer;
    
    GLuint _normalMatrixSlot;
    GLuint _lightPositionSlot;
    
    GLint _normalSlot;
    GLint _ambientSlot;
    GLint _diffuseSlot;
    GLint _specularSlot;
    GLint _shininessSlot;
    
    ccVertex3F _lightPosition;
    ccColor4F _ambient;
    ccColor4F _diffuse;
    ccColor4F _specular;
    
    GLfloat _shininess;
    
    GLuint normalBuffer;
}

- (void)configVertex {
    vertexBuffer = malloc(sizeof(GLuint) * 10);
    glGenBuffers(10, vertexBuffer);
    glGenBuffers(1, &indexBuffer);
    indices = (GLubyte *)malloc(sizeof(GLubyte) * (barEdgeNum * 2 + (barEdgeNum - 2) * 2) * 3);
    for (int i = 0; i < 10; i++) {
        vertexList[i] = (Vertex *)malloc(sizeof(Vertex) * 2 * barEdgeNum);
        [ShapeDataFunc ProduceBarData:vertexList[i] indice:indices xOffset:-4 + i * 4 radius:1 height:5 edgeNum:barEdgeNum];
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer[i]);
        glBufferData(GL_ARRAY_BUFFER, barEdgeNum * sizeof(Vertex) * 2, vertexList[i], GL_STREAM_DRAW);
    }
    
    Normal *normals = malloc(sizeof(Normal) * 2 * barEdgeNum);
    [ShapeDataFunc ProduceNormalData:normals vertexs:vertexList[0] vertexNum:barEdgeNum * 2 indices:indices indiceNum:(barEdgeNum * 2 + (barEdgeNum - 2) * 2) * 3];
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, barEdgeNum * 6 + 2 * (barEdgeNum - 2) * 3, indices,GL_STATIC_DRAW);
    
    glGenBuffers(1,&lineIndiceBuffer);
    glGenBuffers(1, &lineVertexBuffer);
    glGenBuffers(1, &normalBuffer);
    
    Vertex *lineVertexList = malloc(sizeof(Vertex) * 2);
    GLubyte *lineIndiceList = malloc(sizeof(GLubyte) * 2);
    lineVertexList[0].Position[0] = -10;
    lineVertexList[0].Position[1] = 0;
    lineVertexList[0].Position[2] = 0;
    lineVertexList[0].Color[0] = 0;
    lineVertexList[0].Color[0] = 0;
    lineVertexList[0].Color[0] = 0;
    lineVertexList[0].Color[0] = 1.0;
    lineVertexList[1].Position[0] = 10;
    lineVertexList[1].Position[1] = 0;
    lineVertexList[1].Position[2] = 0;
    lineVertexList[1].Color[0] = 0;
    lineVertexList[1].Color[0] = 0;
    lineVertexList[1].Color[0] = 0;
    lineVertexList[1].Color[0] = 1.0;
    lineIndiceList[0] = 0;
    lineIndiceList[1] = 1;
    
    glBindBuffer(GL_ARRAY_BUFFER, lineVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex) * 2, lineVertexList, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, lineIndiceBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLubyte) * 2, lineIndiceList, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
    glBufferData(GL_ARRAY_BUFFER, barEdgeNum * sizeof(Vector3D) * 2, normals, GL_STATIC_DRAW);
    
    
    //glGenBuffers(3, vertexBuffer);
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = YES;
        
        eaglCtx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        [EAGLContext setCurrentContext:eaglCtx];
        
        glGenRenderbuffers(1, &depthRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, depthRenderBuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
        
        glGenRenderbuffers(1, &colorRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
        [eaglCtx renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
        
        GLuint frameBuffer;
        glGenFramebuffers(1, &frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderBuffer);
        
        //texture = [self setTexture:@"texture.jpeg"];
        
        [self compileShaders];
        [self setupLights];
        
        [self configVertex];
        glEnable(GL_DEPTH_TEST);
        [self setupDisplayLink];
    }
    return self;
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (GLuint)setTexture:(NSString *)fileName {
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load imge");
    }
    GLsizei width = (GLsizei)CGImageGetWidth(spriteImage);
    GLsizei height = (GLsizei)CGImageGetHeight(spriteImage);
    GLubyte *spriteData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    free(spriteData);
    return texName;
}

- (void)display4_4:(CGFloat *) glMatrix {
    for (int i = 0; i < 4; i++) {
        NSLog(@"%.2f  %.2f  %.2f  %.2f", glMatrix[4 * i + 0], glMatrix[4 * i + 1], glMatrix[4 * i + 2], glMatrix[4 * i + 3]);
    }
}

- (void)render:(CADisplayLink *)displayLink {
    glClearColor(1, 1, 1, 1.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    float width = 10;
    float h = width * self.frame.size.height / self.frame.size.width;
    [projection populateFromFrustumLeft:-width / 2 andRight:width / 2 andBottom:-h/2 andTop:h/2 andNear:6 andFar:50];
    //[projection populateOrthoFromFrustumLeft:-width / 2 andRight:width / 2 andBottom:-h/2 andTop:h/2 andNear:6 andFar:50];
    [projection translateByZ:-15];
    glUniformMatrix4fv(projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    
    static int time = 0;
    time++;
    [modelView populateFromRotation:CC3VectorMake(0 , 0, 0)];
    [modelView translateByZ:-2];
    [modelView translateByY:-4];
    glUniformMatrix4fv(modelViewUniform, 1, 0, modelView.glMatrix);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    static BOOL isIncrease = YES;
    GLfloat currentHeight =  vertexList[0][1].Position[1];
    if (currentHeight > 8) {
        isIncrease = NO;
    }
    else if (currentHeight < 0.5) {
        isIncrease = YES;
    }
    if (isIncrease) {
        for (int j = 0; j < barEdgeNum; j++) {
            vertexList[0][j * 2 + 1].Position[1] += 0.1;
        }
    }
    else {
        for (int j = 0; j < barEdgeNum; j++) {
            vertexList[0][j * 2 + 1].Position[1] -= 0.1;
        }
    }
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer[0]);
    glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(Vertex) * 2 * barEdgeNum, vertexList[0]);
    
    
    glEnableVertexAttribArray(positionSlot);
    glEnableVertexAttribArray(colorSlot);
    
    glEnableVertexAttribArray(_normalSlot);
    for (int i = 0; i < 4 ; i++) {
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer[i]);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
        glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*)(sizeof(float) * 3));
        glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
        glVertexAttribPointer(_normalSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vector3D), 0);
        
        glDrawElements(GL_TRIANGLES, barEdgeNum * 6 + 2 * (barEdgeNum - 2) * 3, GL_UNSIGNED_BYTE, 0);
    }
    
    
    glBindBuffer(GL_ARRAY_BUFFER, lineVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, lineIndiceBuffer);
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*)(sizeof(float) * 3));
    glDrawElements(GL_LINES, 2, GL_UNSIGNED_BYTE, 0);
    
    glDisableVertexAttribArray(positionSlot);
    glDisableVertexAttribArray(colorSlot);
    
        [self updateLights];
    glEnableVertexAttribArray(_normalMatrixSlot);
//    KSMatrix3 normalMatrix3;
//    CC3GLMatrix
//    ksMatrix4ToMatrix3(&normalMatrix3, &_modelViewMatrix);
    glUniformMatrix3fv(_normalMatrixSlot, 9, GL_FALSE, modelView.glMatrix);
    glDisableVertexAttribArray(_normalMatrixSlot);
    
    [eaglCtx presentRenderbuffer:GL_RENDERBUFFER];
    
    
    
    
    //glVertexAttribPointer(texCoordSlot, 2, GL_FLOAT, GL_FALSE,
                          //sizeof(Vertex), (GLvoid*) (sizeof(float) *7));
    
    //glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D, texture);
//    glUniform1i(textureUniform, 0);
    

}

- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType {
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (shaderString.length == 0) {
        NSLog(@"error loading shader:%@", error.localizedDescription);
        return 0;
    }
    GLuint shaderHandle = glCreateShader(shaderType);
    const char* shaderStringUTF8 = [shaderString UTF8String];
    GLint shaderStringLength = (GLint)[shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        NSLog(@"shader compile failure...");
        return 0;
    }
    
    return shaderHandle;
}

- (void)compileShaders {
    GLuint vertexShader = [self compileShader:@"FirstVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"FirstFragment" withType:GL_FRAGMENT_SHADER];
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        NSLog(@"link error....");
        return;
    }
    
    glUseProgram(programHandle);
   positionSlot = glGetAttribLocation(programHandle, "Position");
    colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    projectionUniform = glGetUniformLocation(programHandle, "Projection");
    modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    
    
    _normalMatrixSlot = glGetUniformLocation(programHandle, "normalMatrix");
    _lightPositionSlot = glGetUniformLocation(programHandle, "vLightPosition");
    _ambientSlot = glGetUniformLocation(programHandle, "vAmbientMaterial");
    _specularSlot = glGetUniformLocation(programHandle, "vSpecularMaterial");
    _shininessSlot = glGetUniformLocation(programHandle, "shininess");
    
    _normalSlot = glGetAttribLocation(programHandle, "vNormal");
    _diffuseSlot = glGetAttribLocation(programHandle, "vDiffuseMaterial");
    
//    texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
//    glEnableVertexAttribArray(texCoordSlot);
//    textureUniform = glGetUniformLocation(programHandle, "Texture");
}

- (void)setupLights
{
    // Initialize various state.
    //
    //glEnableVertexAttribArray(_normalSlot);
    
    // Set up some default material parameters.
    //
    _lightPosition.x = _lightPosition.y = 0;
    _lightPosition.z = 9;
    
    _ambient.r = _ambient.g = _ambient.b = 0.04;
    _ambient.a = 1.0;
    _specular.r = _specular.g = _specular.b = 0.5;
    _specular.a = 1.0;
    _diffuse.r = 0.0;
    _diffuse.g = 0.5;
    _diffuse.b = 1.0;
    _diffuse.a = 1.0;
    
    _shininess = 3;
}

- (void)updateLights
{
    glUniform3f(_lightPositionSlot, _lightPosition.x, _lightPosition.y, _lightPosition.z);
    glUniform4f(_ambientSlot, _ambient.r, _ambient.g, _ambient.b, _ambient.a);
    glUniform4f(_specularSlot, _specular.r, _specular.g, _specular.b, _specular.a);
    glVertexAttrib4f(_diffuseSlot, _diffuse.r, _diffuse.g, _diffuse.b, _diffuse.a);
    glUniform1f(_shininessSlot, _shininess);
}


+ (Class)layerClass {
    return [CAEAGLLayer class];
}

@end

#import "HXOpenGLESLightDisplayView.h"
#import "OpenGLESLocalLightView.h"

@interface OpenGLESViewController ()

@end

#define kColumnTextViewTag 'ctvt'
#define kRowTextViewTag 'rtvt'

@implementation OpenGLESViewController {
    HXOpenGLESBaseView *openGLESView;
    OpenGLESLocalLightView *localLightView;
    UIView *controlMenuView;
    NSInteger _tag;
}

- (instancetype)initWithTag:(NSInteger)tag {
    if (self = [super init]) {
        _tag = tag;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBarHidden = NO;
    //self.view = [[OpenGLESView alloc] initWithFrame:self.view.bounds];
    
    self.view.backgroundColor = [UIColor cyanColor];
    
//    OpenGLESLocalLightView *lightDisplayView = [[OpenGLESLocalLightView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:lightDisplayView];
//    return;
    
    if (_tag == 2) {
        localLightView = [[OpenGLESLocalLightView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:localLightView];
        return;
    }
    
    openGLESView = [[HXOpenGLESBaseView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:openGLESView];
    
    
    UIButton *setttingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setttingBtn setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    setttingBtn.frame = CGRectMake(self.view.bounds.size.width - 80 - 10, self.view.bounds.size.height - 80 - 10, 80, 80);
    [setttingBtn addTarget:self action:@selector(addControlMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setttingBtn];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 200, 100, 80)];
//    [self.view addSubview:imageView];
//    imageView.backgroundColor = [UIColor blueColor];
//    imageView.image = [openGLESView drawDate:@"2016-12-11"];
        // Do any additional setup after loading the view.
}

- (void)upBtnAction{
    openGLESView.scaleY += 0.1;
    [openGLESView render:nil];
}

- (void)downBtnAction{
    openGLESView.scaleY -= 0.1;
    [openGLESView render:nil];
}

- (void)leftBtnAction{
    openGLESView.scaleX -= 0.1;
    [openGLESView render:nil];
}

- (void)rightBtnAction{
    openGLESView.scaleX += 0.1;
    [openGLESView render:nil];
}

- (void)addControlMenu {
    controlMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    controlMenuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:controlMenuView];
    
    CGFloat offsetTop = 40;
    NSArray *names = @[@"shininess:",@"ambient_r",@"ambient_g",@"ambient_b",@"specular_r",@"specular_g",@"specular_b",@"diffuse_r",@"diffuse_g",@"diffuse_b"];
    for (int i = 0; i < 10; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, offsetTop, 80, 20)];
        label.text = names[i];
        label.textColor = [UIColor whiteColor];
        [controlMenuView addSubview:label];
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20 + label.bounds.size.width, label.frame.origin.y, controlMenuView.bounds.size.width / 2 - (20 + label.bounds.size.width) - 10, 40)];
        slider.tag = i;
        [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [controlMenuView addSubview:slider];
        offsetTop += 70;
        switch (i) {
            case 0:
                slider.value = openGLESView.shininess;
                break;
            case 1:
                slider.value = openGLESView.ambient->r;
                break;
            case 2:
                slider.value = openGLESView.ambient->g;
                break;
            case 3:
                slider.value = openGLESView.ambient->b;
                break;
            case 4:
                slider.value = openGLESView.specular->r;
                break;
            case 5:
                slider.value = openGLESView.specular->g;
                break;
            case 6:
                slider.value = openGLESView.specular->b;
                break;
            case 7:
                slider.value = openGLESView.diffuse->r;
                break;
            case 8:
                slider.value = openGLESView.diffuse->g;
                break;
            case 9:
                slider.value = openGLESView.diffuse->b;
                break;
                
            default:
                break;
        }
    }
    
    CGFloat offsetLeft = 200 + self.view.bounds.size.width / 2;
    offsetTop = 100;
    
    offsetLeft = controlMenuView.bounds.size.width / 2 + 40;
    UILabel *columnNumLabel = [self standardLabel:@"列数"];
    columnNumLabel.frame = CGRectMake(offsetLeft, offsetTop, 80, 40);
    [controlMenuView addSubview:columnNumLabel];
    
    UITextField *columnNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(offsetLeft + columnNumLabel.bounds.size.width  + 10, offsetTop, 200, 40)];
    columnNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    columnNumTextField.tag = kColumnTextViewTag;
    columnNumTextField.text = [NSString stringWithFormat:@"%d", openGLESView.columnNum];
    columnNumTextField.backgroundColor = [UIColor whiteColor];
    [controlMenuView addSubview:columnNumTextField];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    refreshBtn.frame = CGRectMake(columnNumTextField.frame.origin.x + columnNumTextField.bounds.size.width + 20, offsetTop + 20, 80, 80);
    [refreshBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [controlMenuView addSubview:refreshBtn];
    
    offsetTop += 60;
    UILabel *rowNumLabel = [self standardLabel:@"行数"];
    rowNumLabel.frame = CGRectMake(offsetLeft, offsetTop, 80, 40);
    [controlMenuView addSubview:rowNumLabel];
    
    UITextField *rowNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(offsetLeft + columnNumLabel.bounds.size.width  + 10, offsetTop, 200, 40)];
    rowNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    rowNumTextField.tag = kRowTextViewTag;
    rowNumTextField.text = [NSString stringWithFormat:@"%d", openGLESView.rowNum];
    rowNumTextField.backgroundColor = [UIColor whiteColor];
    [controlMenuView addSubview:rowNumTextField];
    
    CGFloat btnWidth = 60;
    offsetTop += 100;
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upBtn setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    upBtn.frame = CGRectMake(offsetLeft + 100, offsetTop, btnWidth, btnWidth);
    [upBtn addTarget:self action:@selector(upBtnAction) forControlEvents:UIControlEventTouchDown];
    [controlMenuView addSubview:upBtn];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [upBtn addGestureRecognizer:longPressGestureRecognizer];
    
    offsetTop += 100;
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downBtn setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    downBtn.frame = CGRectMake(offsetLeft + 100, offsetTop, btnWidth, btnWidth);
    [downBtn addTarget:self action:@selector(downBtnAction) forControlEvents:UIControlEventTouchDown];
    [controlMenuView addSubview:downBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(offsetLeft, offsetTop, btnWidth, btnWidth);
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchDown];
    [controlMenuView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(offsetLeft + 200, offsetTop, btnWidth, btnWidth);
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchDown];
    [controlMenuView addSubview:rightBtn];

    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
    exitBtn.frame = CGRectMake(controlMenuView.bounds.size.width - 80 - 10, controlMenuView.bounds.size.height - 80 - 10, 80, 80);
    [exitBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    [controlMenuView addSubview:exitBtn];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longGesture {
    [self upBtnAction];
}
- (UILabel *)standardLabel:(NSString *)text {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectZero];
    lable.textColor = [UIColor grayColor];
    lable.text = text;
    lable.backgroundColor = [UIColor whiteColor];
    return lable;
}

- (void)exitAction {
    [controlMenuView removeFromSuperview];
}

- (void)refreshAction {
    UITextField *columnInput = [controlMenuView viewWithTag:kColumnTextViewTag];
    UITextField *rowInput = [controlMenuView viewWithTag:kRowTextViewTag];
    openGLESView.columnNum = (GLuint)[columnInput.text integerValue];
    openGLESView.rowNum = (GLuint)[rowInput.text integerValue];
    [openGLESView updateVertexData];
    [openGLESView render:nil];
}

- (void)sliderValueChange:(UISlider *)slider {
    switch (slider.tag) {
        case 0:
        openGLESView.shininess = slider.value;
        break;
        case 1:
        openGLESView.ambient->r = slider.value;
        break;
        case 2:
        openGLESView.ambient->g = slider.value;
        break;
        case 3:
        openGLESView.ambient->b = slider.value;
        break;
        case 4:
            openGLESView.specular->r = slider.value;
        break;
        case 5:
            openGLESView.specular->g = slider.value;
        break;
        case 6:
            openGLESView.specular->b = slider.value;
        break;
        case 7:
            openGLESView.diffuse->r = slider.value;
        break;
        case 8:
            openGLESView.diffuse->g = slider.value;
        break;
        case 9:
            openGLESView.diffuse->b = slider.value;
        break;
        
        default:
        break;
    }
    [openGLESView render:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
