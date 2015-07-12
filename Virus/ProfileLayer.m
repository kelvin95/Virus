//
//  ProfileLayer.m
//  Virus Final
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import "ProfileLayer.h"
#import "cocos2d.h"
#import "VirusParticleSystem.h"


@implementation ProfileLayer

@synthesize virusParticle = _virusParticle;
@synthesize colorLayer = _colorLayer;

- (id)init {
    if (self = [super init]) {
        self.colorLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)];
        [self.colorLayer setPosition:CGPointZero];
        [self addChild:self.colorLayer];
        
        self.virusParticle = [[VirusParticleSystem alloc] initWithScale:2.0];
        //[self.virusParticle randomizeVirus];
        
        [self.virusParticle.virusNameLabel setPosition:CGPointMake(0, -50*self.virusParticle.virusScale)];

        
        [self addChild:self.virusParticle];
        
        
    }
    return self;
}

- (void)enterScreen {
    [self.virusParticle setPosition:CGPointMake(160, 370-[UIScreen mainScreen].bounds.size.height)];
    [self.virusParticle runAction:[CCMoveTo actionWithDuration:0.5 position:CGPointMake(160, 370)]];
    [self.colorLayer runAction:[CCFadeTo actionWithDuration:0.5 opacity:0.9*255]];
}

- (void)exitScreen {
    [self.virusParticle resetSystem];
    [self.virusParticle runAction:[CCMoveTo actionWithDuration:0.5 position:CGPointMake(160, 370-370-[UIScreen mainScreen].bounds.size.height)]];
    [self.colorLayer runAction:[CCFadeTo actionWithDuration:0.5 opacity:0]];
}

@end
