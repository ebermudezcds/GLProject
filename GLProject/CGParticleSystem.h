//
//  CGParticleSystem.h
//  GLProject
//
//  Created by Enrique Bermudez on 28/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGNode.h"
#import "CGTexture.h"
#import "CGParticle.h"

#define MAX_PARTICELS 5000


@protocol CGParticleManager

@required

/**
 */
-(void)updateParticle: (CGParticle*)particle deltaTime: (float)dt;

@end


@interface CGParticleSystem : CGNode <CGDrawableNode>

/**
 */
@property NSMutableArray* particles;

@property(assign, nonatomic) float emissionRate;

#pragma mark -
#pragma mark Particles properties

@property float particlesSize;

@property float particlesMaxLifeTime;

@property (strong)CGTexture* particlesTexture;

@property (strong)NSMutableArray* particlesColors;

#pragma mark -

@property id<CGParticleManager> particleManager;


/**
 *  Updates all particles of the CGParticleSystem.
 */
-(void)update:(float)dt;

/**
 *  Adds a particle to the system.
 */
-(void)emitParticle;

/**
 *  Starts particles emission.
 */
-(void)startEmission;

/**
 *  Stops particles emission.
 */
-(void)stopEmission;

@end

@interface CGDefaultParticleManager : NSObject  <CGParticleManager>

@end
