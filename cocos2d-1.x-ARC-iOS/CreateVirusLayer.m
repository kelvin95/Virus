//
//  CreateVirusScene.m
//  Virus
//
//  Created by Ulysses Zheng on 1/18/2014.
//  Copyright (c) 2014 Ulysses Zheng. All rights reserved.
//

#import "CreateVirusLayer.h"
#import "AppDelegate.h"
#import "VirusParticleSystem.h"

@implementation CreateVirusLayer

@synthesize virusParticle = _virusParticle;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		

		//[self loadDefaultVirus];
        //[self randomizeVirus];
        self.virusParticle = [[VirusParticleSystem alloc] initWithScale:2.0];
        [self.virusParticle setPosition:ccp(160, 240)];
        [self.virusParticle randomizeVirus];
        [self addChild:self.virusParticle];

        
	}
	return self;
}


@end
