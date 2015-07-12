//
//  VirusParticleSystem.h
//  cocos2d-1.x-ARC-iOS
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import "CCParticleSystemQuad.h"
#import "cocos2d.h"

@class Virus;
@protocol VirusProtocol;

@interface VirusParticleSystem : CCParticleSystemQuad 

@property (nonatomic, strong) CCLabelTTF *virusNameLabel;
@property (nonatomic) float virusScale;
@property (nonatomic) BOOL hasCircle;
@property (nonatomic, strong) Virus *virusObj;

- (id)initWithScale:(float)scale;

- (void)setWithAttributes:(NSDictionary *)attributes;


- (void)randomizeVirus;

- (void)enableCircleForVirusType:(int)type;
- (void)disableCircle;
- (void)setNoNameLabel;
@end
