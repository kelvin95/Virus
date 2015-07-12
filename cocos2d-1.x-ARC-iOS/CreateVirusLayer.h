//
//  CreateVirusScene.h
//  Virus
//
//  Created by Ulysses Zheng on 1/18/2014.
//  Copyright (c) 2014 Ulysses Zheng. All rights reserved.
//

#import "CCLayer.h"
#import <GameKit/GameKit.h>


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class VirusParticleSystem;

@interface CreateVirusLayer : CCLayer
{

}

@property (nonatomic, strong) VirusParticleSystem *virusParticle;

+(CCScene *) scene;

@end
