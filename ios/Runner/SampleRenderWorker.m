//
//  SampleRender.m
//  opengl_texture
//
//  Created by German Saprykin on 22/4/18.
//

#import "SampleRenderWorker.h"
#import <OpenGLES/ES3/gl.h>
#include "esUtil.h"
#import "FileWrapper.h"

@interface SampleRenderWorker() {
    GLuint _program;
    GLuint _VAO;
    GLuint _VBO;
    GLuint _EBO;
    GLuint _Texture;
}
@end
@implementation SampleRenderWorker

- (void)onCreateWithRenderSize:(CGSize)viewPort {
    NSString *vertexShaderPath = [NSString stringWithCString:GetBundleFileName("vs01.vs") encoding:NSASCIIStringEncoding];
    const char *vsSrc = [[NSString stringWithContentsOfFile:vertexShaderPath encoding:NSASCIIStringEncoding error:NULL] cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSString *fragShaderPath = [NSString stringWithCString:GetBundleFileName("fs01.fs") encoding:NSASCIIStringEncoding];
    const char *fsSrc = [[NSString stringWithContentsOfFile:fragShaderPath encoding:NSASCIIStringEncoding error:NULL] cStringUsingEncoding:NSASCIIStringEncoding];
    
    _program = esLoadProgram(vsSrc, fsSrc);
    if (_program == 0) {
        NSLog(@"program create faild");
    }
    
    GLfloat vertices[] = {
    //     ---- 位置 ----      - 纹理坐标 -
          0.5f,  0.5f, 0.0f,  1.0f, 1.0f,   // 右上
          0.5f, -0.5f, 0.0f,  1.0f, 0.0f,   // 右下
         -0.5f, -0.5f, 0.0f,  0.0f, 0.0f,   // 左下
         -0.5f,  0.5f, 0.0f,  0.0f, 1.0f    // 左上
    };
    
    GLushort indices[] = {
        0, 1, 3, // 第一个三角形
        1, 2, 3  // 第二个三角形
    };
    
    glGenVertexArrays(1, &_VAO);
    glBindVertexArray(_VAO);
    
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), (void*)(0));
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);
    glBindVertexArray(0);
    glViewport(0, 0, viewPort.width, viewPort.height);
}

- (BOOL)onDraw {
    
    glClearColor(0.5, 0.6, 0.7, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glUseProgram(_program);
    glBindVertexArray(_VAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (const void*)0);
    
    return YES;
}

- (void)onDispose {
    
}

@end
