//
//  ProfileLayer.h
//  Virus Final
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import "CCLayer.h"

@class VirusParticleSystem;

@interface ProfileLayer : CCLayer

@property (nonatomic, strong) CCLayerColor *colorLayer;
@property (nonatomic, strong) VirusParticleSystem *virusParticle;

- (void)enterScreen;
- (void)exitScreen;

@end
