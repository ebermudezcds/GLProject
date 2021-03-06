//
//  CGModel.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGMesh.h"

@interface CGMesh (){
    
    GLuint VBOHandler;
    GLuint indicesHandler;
    
    int strideFloatsCount;

}

@end


@implementation CGMesh

-(id)initWithVertexData:(CGFloatArray*)vertexData{

    self = [super init];
    
    if(self){
        [self configureWithVertexData:vertexData];
    }
    
    return self;
}

-(id)initWithVertexData:(CGFloatArray*)vertexData indices: (CGFloatArray*)indices{

    self = [super init];
    
    if(self){
        
        [self configureWithVertexData:vertexData];

        _indices = indices;
        
        [self loadIndicesData:indices.array capacity:indices.capacity];
    }
    
    return self;
}

-(void)configureWithVertexData:(CGFloatArray*)vertexData{
    
    _frameCount = 1;

    _vertexData = vertexData;
    
    self.positionOffset = 0;
    self.normalOffset = sizeof(float) * VBO_POSITION_SIZE;
    self.uvOffset = sizeof(float) * (VBO_POSITION_SIZE + VBO_NORMAL_SIZE);
    
    self.drawMode = GL_TRIANGLES;
    
    [self updateVertexCountAndStride];
    
    [self loadVertexData: vertexData.array capacity:vertexData.capacity];
    
    _animations = [[NSMutableArray alloc] init];
}



-(void)loadVertexData:(GLfloat *)vertexData capacity:(int)cpacity{

    glGenBuffers(1, [self VBOHandlerRef] );
    glBindBuffer(GL_ARRAY_BUFFER, [self VBOHandler]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(float)*cpacity, vertexData, GL_STATIC_DRAW);
}

-(void)loadIndicesData:(GLubyte* )indices capacity:(int)cpacity{
    
    glGenBuffers(1, [self indicesHandlerRef]);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, [self indicesHandler]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLubyte)*cpacity, indices, GL_STATIC_DRAW); 
}

-(GLuint) VBOHandler{

    return VBOHandler;
}
-(GLuint*) VBOHandlerRef{

    return &VBOHandler;
}

-(GLuint) indicesHandler{

    return indicesHandler;
}

-(GLuint*) indicesHandlerRef{
    return &indicesHandler;
}

-(void)setPositionOffset:(int)positionOffset{
    _positionOffset = positionOffset;
    [self updateVertexCountAndStride];
}

-(void)setNormalOffset:(int)normalOffset{
    _normalOffset = normalOffset;
    [self updateVertexCountAndStride];
}

-(void)setUvOffset:(int)uvOffset{
    _uvOffset = uvOffset;
    [self updateVertexCountAndStride];
}


-(void)setFrameCount:(int)frameCount{
    _frameCount = frameCount;
    [self updateVertexCountAndStride];
}

-(void)updateVertexCountAndStride{

    strideFloatsCount = ((self.positionOffset!=VBO_NULL_ELEMENT)?VBO_POSITION_SIZE:0) +
                        ((self.uvOffset!=VBO_NULL_ELEMENT)?VBO_UV_SIZE:0) +
                        ((self.normalOffset!=VBO_NULL_ELEMENT)?VBO_NORMAL_SIZE:0);
    
    _stride = sizeof(float)*strideFloatsCount;
    _vertexCount = (strideFloatsCount!=0)?((self.vertexData.capacity/strideFloatsCount)/self.frameCount):0;
}

-(bool)isAnimated{
    return (self.animations)?([self.animations count]>0?TRUE:FALSE):FALSE;
}

@end
