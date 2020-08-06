//
//  SampleRender.m
//  opengl_texture
//
//  Created by German Saprykin on 22/4/18.
//

#import "SampleRenderWorker.h"
#import <OpenGLES/ES3/gl.h>
#include "esUtil.h"
#include "tex_image.hpp"
#include "Vertices.h"
#include "glm.hpp"
#include "type_ptr.hpp"
#include "matrix_transform.hpp"

const char *GetBundleFileName( const char *fileName )
{
    NSString* fileNameNS = [NSString stringWithUTF8String:fileName];
    NSString* baseName = [fileNameNS stringByDeletingPathExtension];
    NSString* extension = [fileNameNS pathExtension];
    NSString *path = [[NSBundle mainBundle] pathForResource: baseName ofType: extension ];
    fileName = [path cStringUsingEncoding:1];
    
    return fileName;
}

@interface SampleRenderWorker()
{
    GLuint _program;
    GLuint _VAO;
    GLuint _VBO;
    GLuint _EBO;
    GLuint _Texture1;
    GLuint _Texture2;
    CGSize _viewPort;
    float _count;
    glm::vec3 _cubePositions[10];
    glm::vec3 cameraUp;
    glm::vec3 cameraPos;
    glm::vec3 cameraRight;
    glm::vec3 cameraFront;
    glm::vec3 Up;
    
    float yaw;
    float pitch;
}
@end
@implementation SampleRenderWorker

- (void)onCreateWithRenderSize:(CGSize)viewPort {
    NSString *vertexShaderPath = [NSString stringWithCString:GetBundleFileName("vs01.vs") encoding:NSASCIIStringEncoding];
    const char *vsSrc = [[NSString stringWithContentsOfFile:vertexShaderPath encoding:NSASCIIStringEncoding error:NULL] cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSString *fragShaderPath = [NSString stringWithCString:GetBundleFileName("fs01.fs") encoding:NSASCIIStringEncoding];
    const char *fsSrc = [[NSString stringWithContentsOfFile:fragShaderPath encoding:NSASCIIStringEncoding error:NULL] cStringUsingEncoding:NSASCIIStringEncoding];
    _viewPort = viewPort;
    yaw = -90.0;
    pitch = 0.0;
    
    _program = esLoadProgram(vsSrc, fsSrc);
    if (_program == 0) {
        NSLog(@"program create faild");
    }
    
    _cubePositions[0] = glm::vec3( 0.0f,  0.0f,  0.0f);
    _cubePositions[1] = glm::vec3( 2.0f,  5.0f, -15.0f);
    _cubePositions[2] = glm::vec3(-1.5f, -2.2f, -2.5f);
    _cubePositions[3] = glm::vec3(-3.8f, -2.0f, -12.3f);
    _cubePositions[4] = glm::vec3( 2.4f, -0.4f, -3.5f);
    _cubePositions[5] = glm::vec3(-1.7f,  3.0f, -7.5f);
    _cubePositions[6] = glm::vec3( 1.3f, -2.0f, -2.5f);
    _cubePositions[7] = glm::vec3( 1.5f,  2.0f, -2.5f);
    _cubePositions[8] = glm::vec3( 1.5f,  0.2f, -1.5f);
    _cubePositions[9] = glm::vec3(-1.3f,  1.0f, -1.5f);
    
    cameraUp = glm::vec3(0.0,1.0,0.0);
    cameraPos = glm::vec3(0.0,0.0,6.0);
    cameraRight = glm::vec3(0.0);
    
    //顶点缓存数组
    glGenVertexArrays(1, &_VAO);
    glBindVertexArray(_VAO);
    
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cubeVertices), cubeVertices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(0));
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);
    glBindVertexArray(0);
    
    //
    glViewport(0, 0, viewPort.width, viewPort.height);
    
    //纹理
    glGenTextures(1, &_Texture1);
    glBindTexture(GL_TEXTURE_2D, _Texture1);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    int width, height, nrChannel;
//    stbi_set_flip_vertically_on_load(true);
    unsigned char *data = stbi_load([[[NSBundle mainBundle] pathForResource:@"container" ofType:@"jpg"] cStringUsingEncoding:NSASCIIStringEncoding], &width, &height, &nrChannel, 0);
    if (data) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);
    }else{
        NSLog(@"container texture load faild");
    }
    stbi_image_free(data);
    
    glGenTextures(1, &_Texture2);
    glBindTexture(GL_TEXTURE_2D, _Texture2);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
//    stbi_set_flip_vertically_on_load(true);
    data = stbi_load([[[NSBundle mainBundle] pathForResource:@"awesomeface" ofType:@"png"] cStringUsingEncoding:NSASCIIStringEncoding], &width, &height, &nrChannel, 0);
    if (data) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
        glGenerateMipmap(GL_TEXTURE_2D);
    }else{
        NSLog(@"face texture load faild");
    }
    stbi_image_free(data);
    
    glUseProgram(_program);
    glUniform1i(glGetUniformLocation(_program, "texture1"), 0);
    glUniform1i(glGetUniformLocation(_program, "texture2"), 1);
    glEnable(GL_DEPTH_TEST);
    
    CADisplayLink *dl = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerRun)];
    dl.preferredFramesPerSecond = 60;
    [dl addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)timerRun{
    _count += 0.01;
}

- (BOOL)onDraw {
    
    glClearColor(0.7, 0.7, 0.7, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glUseProgram(_program);
    glBindVertexArray(_VAO);
    
    //变换矩阵
    glm::mat4 view = glm::mat4(1.0);
    glm::mat4 projection = glm::mat4(1.0);
    
    for (int i = 0; i < 10; i++) {
        glm::mat4 model = glm::mat4(1.0);
        glm::vec3 position = _cubePositions[i];
        model = glm::translate(model, position);
        model = glm::rotate(model, glm::radians(25.0f * (i + 1)) * _count, glm::vec3(1.0f,0.3f,0.5f));
        glUniformMatrix4fv(glGetUniformLocation(_program, "model"), 1, GL_FALSE, glm::value_ptr(model));
        
        glDrawArrays(GL_TRIANGLES, 0, 36);
    }
    
    view = glm::translate(view, glm::vec3(0.0f, 0.0f,-6.0f));
//    view = glm::lookAt(cameraPos, cameraPos + cameraFront, Up);
    glUniformMatrix4fv(glGetUniformLocation(_program, "view"), 1, GL_FALSE, glm::value_ptr(view));
    
    projection = glm::perspectiveFov(glm::radians(45.0f), (float)_viewPort.width, (float)_viewPort.height, 0.1f, 100.0f);
    glUniformMatrix4fv(glGetUniformLocation(_program, "projection"), 1, GL_FALSE, glm::value_ptr(projection));
    
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _Texture1);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _Texture2);
    
    return YES;
}

- (void)onDispose {
    
}

- (void)updateDragPoint:(CGPoint)point{
    float sensetive = 0.001;
    CGFloat dx = point.x * sensetive;
    CGFloat dy = point.y * sensetive;
    
    yaw += dx;
    pitch += dy;
    
    if (pitch > 89.0) {
        pitch = 89.0;
    }else if (pitch < -89.0){
        pitch = -89.0;
    }
    
    glm::vec3 front;
    front.x = cos(glm::radians(yaw)) * cos(glm::radians(pitch));
    front.y = sin(glm::radians(pitch));
    front.z = sin(glm::radians(yaw)) * cos(glm::radians(pitch));
    front = glm::normalize(front);
    cameraFront = front;
    cameraRight = glm::normalize(glm::cross(front, cameraUp));
    Up = glm::normalize(glm::cross(cameraRight, front));
}
@end

