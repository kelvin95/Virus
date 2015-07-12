//
//  VirusParticleSystem.m
//  cocos2d-1.x-ARC-iOS
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import "VirusParticleSystem.h"
#import "cocos2d.h"
#import "Constants.h"
#import "Virus.h"

@implementation VirusParticleSystem

@synthesize virusNameLabel = _virusNameLabel;
@synthesize virusScale = _virusScale;
@synthesize hasCircle = _hasCircle;
@synthesize virusObj = _virusObj;

- (id)initWithScale:(float)scale {
    if (self = [super initWithTotalParticles:200]) {
        
        //CCLayerColor *back = [CCLayerColor layerWithColor:ccc4(0, 1, 1, 1)];
        //[back setContentSize:CGSizeMake(80, 80)];
        
        //[self addChild:back];
        self.virusScale = scale;
        [self setEmitterMode:kCCParticleModeRadius];
        
        [self setContentSize:CGSizeMake(80, 80)];
        [self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"star.png"]];
        
        
        [self setAutoRemoveOnFinish:NO];
        
        [self setDuration:-1];
        [self setAngleVar:360];
        
        [self setEmissionRate:80];
        [self setBlendFunc:(ccBlendFunc) {GL_SRC_ALPHA, GL_ONE}];
        
        self.virusNameLabel = [CCLabelTTF labelWithString:@"VIRUS 1" fontName:@"LeagueGothic-Regular" fontSize:15*scale];
        [self.virusNameLabel setPosition:ccp(0, 50*scale)];
        [self addChild:self.virusNameLabel];
    }
    return self;
}


- (void)randomizeVirus {
    [self setLife:[self randIntBetweenA:1 andB:20]/10. * self.virusScale];
    [self setLifeVar:[self randIntBetweenA:1 andB:10]/10. * self.virusScale];
    [self setStartSize:[self randIntBetweenA:200 andB:400]/10. * self.virusScale];
    [self setStartSizeVar:[self randIntBetweenA:50 andB:200]/10. * self.virusScale];
    [self setEndSize:[self randIntBetweenA:200 andB:400]/10. * self.virusScale];
    [self setEndSizeVar:[self randIntBetweenA:50 andB:200]/10. * self.virusScale];
    [self setStartRadius:[self randIntBetweenA:200 andB:400]/10. * self.virusScale];
    [self setStartRadiusVar:[self randIntBetweenA:0 andB:MIN(200, 200-self.startRadius*10)]/10. * self.virusScale];
    [self setEndRadius:[self randIntBetweenA:0 andB:100]/10. * self.virusScale];
    [self setEndRadiusVar:[self randIntBetweenA:0 andB:MIN(100, 100-self.endRadius*10)]/10. * self.virusScale];
    [self setRotatePerSecond:[self randIntBetweenA:0 andB:360]];
    [self setRotatePerSecondVar:[self randIntBetweenA:5 andB:20]];
    
    
    
    // color of particles
    ccColor4F vStartColor = ccc4f(([self randIntBetweenA:20 andB:255]/255.),
                                 ([self randIntBetweenA:20 andB:255]/255.),
                                 ([self randIntBetweenA:20 andB:255]/255.),
                                 1);
    ccColor4F vStartColorVar = ccc4f(([self randIntBetweenA:0 andB:50]/255.),
                                    ([self randIntBetweenA:0 andB:50]/255.),
                                    ([self randIntBetweenA:0 andB:50]/255.),
                                    1);
    [self setStartColor:vStartColor];
    [self setStartColorVar:vStartColorVar];
    [self setEndColor:vStartColor];
    [self setEndColorVar:vStartColorVar];
    //[spotLight setBlendFunc:(ccBlendFunc) {GL_ONE, GL_ONE}];
    
}

- (void)setWithAttributes:(NSDictionary *)attributes {
    //@[@"radius", @"speed", @"speed_variance", @"start_size", @"start_size_variance", @"finish_size", @"finish_size_variance", @"lifespan", @"lifespan_variance", @"start_color", @"start_color_variance", @"end_color", @"end_color_variance", @"name"]];
    
    
    [self setRotatePerSecond:[[attributes objectForKey:@"speed"] floatValue] * self.virusScale];
    [self setRotatePerSecondVar:[[attributes objectForKey:@"speed_variance"] floatValue] * self.virusScale];
    [self setStartRadius:[[attributes objectForKey:@"radius"] floatValue] * self.virusScale];
    [self setStartSize:[[attributes objectForKey:@"start_size"] floatValue] * self.virusScale];
    [self setStartSizeVar:[[attributes objectForKey:@"start_size_variance"] floatValue] * self.virusScale];
    [self setEndSize:[[attributes objectForKey:@"finish_size"] floatValue] * self.virusScale];
    [self setEndSizeVar:[[attributes objectForKey:@"finish_size_variance"] floatValue] * self.virusScale];
    [self setLife:[[attributes objectForKey:@"lifespan"] floatValue] * self.virusScale];
    [self setLifeVar:[[attributes objectForKey:@"lifespan_variance"] floatValue] * self.virusScale];
    
    
    NSArray *colorSplit = [[attributes objectForKey:@"start_color"] componentsSeparatedByString:@","];
    [self setStartColor:ccc4f([[colorSplit objectAtIndex:0] floatValue],
                              [[colorSplit objectAtIndex:1] floatValue],
                              [[colorSplit objectAtIndex:2] floatValue],
                              1)];
    colorSplit = [[attributes objectForKey:@"start_color_variance"] componentsSeparatedByString:@","];
    [self setStartColorVar:ccc4f([[colorSplit objectAtIndex:0] floatValue],
                              [[colorSplit objectAtIndex:1] floatValue],
                              [[colorSplit objectAtIndex:2] floatValue],
                              1)];
    colorSplit = [[attributes objectForKey:@"end_color"] componentsSeparatedByString:@","];
    [self setEndColor:ccc4f([[colorSplit objectAtIndex:0] floatValue],
                              [[colorSplit objectAtIndex:1] floatValue],
                              [[colorSplit objectAtIndex:2] floatValue],
                              1)];
    colorSplit = [[attributes objectForKey:@"end_color_variance"] componentsSeparatedByString:@","];
    [self setEndColorVar:ccc4f([[colorSplit objectAtIndex:0] floatValue],
                              [[colorSplit objectAtIndex:1] floatValue],
                              [[colorSplit objectAtIndex:2] floatValue],
                              1)];
    NSLog(@"startcolor %@", colorSplit);
}

- (void)enableCircleForVirusType:(int)type {
    [self disableCircle];
    
    CCSprite *circle;
    if (type == kCircleGreen) {
        circle = [CCSprite spriteWithFile:@"GreenCircle.png"];
    } else if (type == kCircleRed) {
        circle = [CCSprite spriteWithFile:@"RedCircle.png"];
    } else if (type == kCircleWhite) {
        circle = [CCSprite spriteWithFile:@"WhiteCircle.png"];
    }
    [circle setScale:80./circle.contentSize.width];
    [circle setPosition:CGPointMake(self.contentSize.width/2., self.contentSize.height/2.)];
    [circle setPosition:CGPointZero];
    [circle setTag:kCircleGeneral];
    [self addChild:circle];
    self.hasCircle = YES;

}

- (void)setNoNameLabel {
    [self.virusNameLabel setString:@""];
}

- (void)disableCircle {
    CCSprite *prevCircle = (CCSprite *)[self getChildByTag:kCircleGeneral];
    if (prevCircle) {
        [self removeChild:prevCircle cleanup:YES];
    }
    self.hasCircle = NO;
}



- (int)randIntBetweenA:(int)a andB:(int)b {
    return (rand() % (b-a)) + a;
}




@end
