//
//  CGDefaultShader.m
//  GLProject
//
//  Created by Enrique Bermudez on 09/09/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGDefaultShader.h"
#import "CGTexture.h"

#define  CGShaderParameter_position     "Position"
#define  CGShaderParameter_projection   "Projection"
#define  CGShaderParameter_modelView    "Modelview"
#define  CGShaderParameter_SourceColor  "SourceColor"
#define  CGShaderParameter_TextCoord    "TexCoordIn"
#define  CGShaderParameter_Texture      "Texture"

@interface CGDefaultShader (){
    
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _texCoordSlot;
    
    
    //Globals
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    GLuint _textureUniform;
}

@end


@implementation CGDefaultShader


-(id)init{

    self = [self initWithVertexShader:@"SimpleVertex" fragmentShader:@"SimpleFragment"];
    
    [self setupParameters];
    
    return self;
}

-(void)drawObject:(CGObject3D*) object usingEngine:(CGEngine*)engine{
    
    glUseProgram(self.handler);
    
    glEnableVertexAttribArray(_projectionUniform);
    glEnableVertexAttribArray(_modelViewUniform);
    
    glEnableVertexAttribArray(_colorSlot);
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_texCoordSlot);
    
    CGTexture* t = [object.textures objectAtIndex:0];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, t.handler);
    glUniform1i(_textureUniform, 0);
    
    
    glUniformMatrix4fv(_modelViewUniform, 1, 0, object.matrix.glMatrix);
    
    
    CC3GLMatrix * pvm = [engine.camera.porjectionMatrix copy];//TODO: Optimizar...
    [pvm multiplyByMatrix:engine.camera.matrix];
    
    
    glUniformMatrix4fv(_projectionUniform, 1, 0, pvm.glMatrix);
    
    //Calls glVertexAttribPointer to feed the correct values to the two input variables for the vertex shader – the Position and SourceColor attributes.
    
    glVertexAttribPointer(_positionSlot, object.mesh.positionOffset/*cantidad de elementos del atributo*/, GL_FLOAT, GL_FALSE,
                          object.mesh.stride ,  0);
    glVertexAttribPointer(_colorSlot, object.mesh.colorOffset, GL_FLOAT, GL_FALSE,
                          object.mesh.stride,(GLvoid*) ( sizeof(float) * object.mesh.positionOffset));
    //#ifdef TEXTURE_MAPPING_ENABLED
    glVertexAttribPointer(_texCoordSlot, object.mesh.uvOffset, GL_FLOAT, GL_FALSE,
                          object.mesh.stride,/*Este es el parametro configutable!!!*/(GLvoid*) (sizeof(float) *( object.mesh.positionOffset + object.mesh.colorOffset )));
    
    //#ifdef KEYFRAME_ANIMATION
    
    //glVertexAttribPointer(_positionSlot/*_nextFramePositionSlot*/, object.mesh.positionOffset/*cantidad de elementos del atributo*/,
    //                      GL_FLOAT, GL_FALSE, object.mesh.stride ,
    //                      (GLvoid*) (sizeof(float) *( object.mesh.positionOffset + object.mesh.colorOffset+object.mesh.uvOffset )));
    
    
    glBindBuffer(GL_ARRAY_BUFFER, [object.mesh VBOHandler]);
    
    if (object.mesh.indices) {
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, [object.mesh indicesHandler]);
        
        glDrawElements(object.mesh.drawMode, object.mesh.indices.capacity ,GL_UNSIGNED_BYTE, 0);
    }else{
        glDrawArrays(object.mesh.drawMode, object.frameIndex*object.mesh.stride*(object.mesh.vertexCount/object.mesh.frameCount) , object.mesh.vertexCount/object.mesh.frameCount);
    }
    
    
    glDisableVertexAttribArray(_colorSlot);
    glDisableVertexAttribArray(_positionSlot);
    glDisableVertexAttribArray(_texCoordSlot);
    
    glDisableVertexAttribArray(_projectionUniform);
    glDisableVertexAttribArray(_modelViewUniform);
}

-(void)setupParameters{
    
    _positionSlot = glGetAttribLocation(self.handler, CGShaderParameter_position);
    _projectionUniform = glGetUniformLocation(self.handler, CGShaderParameter_projection);
    _modelViewUniform = glGetUniformLocation(self.handler,  CGShaderParameter_modelView);
    _colorSlot = glGetAttribLocation(self.handler, CGShaderParameter_SourceColor);
    _texCoordSlot = glGetAttribLocation(self.handler, CGShaderParameter_TextCoord);
    _textureUniform = glGetUniformLocation(self.handler, CGShaderParameter_Texture);
}

@end
