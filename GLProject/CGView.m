//
//  CGView.m
//  GLProject
//
//  Created by Enrique Bermudez on 20/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGView.h"
#import "CC3GLMatrix.h"
#import "CGObject3D.h"
#import "CGMesh.h"
#import "MeshFactory.h"
#import "CGArray.h"
#import "CGUtils.h"



@implementation CGView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupLayer];

        engine = [[CGEngine alloc] initWithLayer:_eaglLayer];


        
    }
    return self;
}

/*  To set up a view to display OpenGL content, you need to set it’s default layer to a special kind of layer called a CAEAGLLayer. The way you set the default layer is to simply overwrite the layerClass method, like you just did above. */
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

/*  By default, CALayers are set to non-opaque (i.e. transparent). However, this is bad for performance reasons (especially with OpenGL), so it’s best to set this as opaque when possible.*/
- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
    
    if ([CGUtils isRetinaDisplay]) {
        
        // Set contentScale Factor to 2
        self.contentScaleFactor = 2.0;
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.contentsScale=2;
    }
}

-(CGEngine*) engine{
    
    return engine;
}




@end
