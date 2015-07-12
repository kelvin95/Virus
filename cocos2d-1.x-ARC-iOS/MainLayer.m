//
//  MainLayer.m
//  cocos2d-1.x-ARC-iOS
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import "MainLayer.h"
#import "cocos2d.h"
#import "VirusParticleSystem.h"
#import "Constants.h"
#import "Virus.h"
#import "StatsManager.h"

@implementation MainLayer

@synthesize personalVirus = _personalVirus;
@synthesize virusArray = _virusArray;
@synthesize targetVirus = _targetVirus;
@synthesize touchedOtherVirus = _touchedOtherVirus;
@synthesize parentVC = _parentVC;
@synthesize infectLinePointsArray = _infectLinePointsArray;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	
	
	// return the scene
	return scene;
}



// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        [self setIsTouchEnabled:YES];
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        
        self.virusArray = [[NSMutableArray alloc] initWithObjects: @"",@"",@"",@"",@"",@"", nil];
        self.virusLocations = @[[NSValue valueWithCGPoint:CGPointMake(160, 240+150-50)],
                                [NSValue valueWithCGPoint:CGPointMake(160-100, 240+75-50)],
                                [NSValue valueWithCGPoint:CGPointMake(160+100, 240+75-50)],
                                [NSValue valueWithCGPoint:CGPointMake(160-100, 240-75-50)],
                                [NSValue valueWithCGPoint:CGPointMake(160+100, 240-75-50)],
                                [NSValue valueWithCGPoint:CGPointMake(160, 240-150-50)],];
        self.ownVirusSelected = NO;
        [self setOwnVirus];
        
        
        /*
        CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0.8*255)];
        [layer setContentSize:CGSizeMake(320, 480)];
        [layer setPosition:ccp(0, 0)];
        NSLog(@"layyer %@", layer);
        [self addChild:layer];
         */

    }
    return self;
}

- (void)loadNewVirusWith:(Virus *)virusObj {
    for (int i = 0; i < 6; i++) {
        if ([[self.virusArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
            [self enterVirusFromDirection:i andObj:virusObj];
            break;
        }
    }
}


- (void)enterVirusFromDirection:(int)direction andObj:(Virus *)virusObj {
    VirusParticleSystem *newVirus = [[VirusParticleSystem alloc] initWithScale:1.0];
    CCMoveTo *moveAction = [CCMoveTo actionWithDuration:0.5 position:[[self.virusLocations objectAtIndex:direction] CGPointValue]];
    switch (direction) {
        case kVirusDirectionTop:
            [newVirus setPosition:ccp(160,500)];
            break;
        case kVirusDirectionTopLeft:
            [newVirus setPosition:ccp(-100,240+75)];
            break;
        case kVirusDirectionTopRight:
            [newVirus setPosition:ccp(420,240+75)];
            break;
        case kVirusDirectionBotLeft:
            [newVirus setPosition:ccp(-100,240-75)];
            break;
        case kVirusDirectionBotRight:
            [newVirus setPosition:ccp(420,240-75)];
            break;
        case kVirusDirectionBot:
            [newVirus setPosition:ccp(160,-100)];
            break;
        default:
            break;
    }
    
    //[newVirus.virusNameLabel setString:[NSString stringWithFormat:@"VIRUS %d", direction]];
    [newVirus setVirusObj:virusObj];
    [newVirus setWithAttributes:virusObj.attributes];
    [newVirus.virusNameLabel setString:virusObj.name];
    
    [self addChild:newVirus];
    [newVirus runAction:moveAction];
    [self.virusArray replaceObjectAtIndex:direction withObject:newVirus];
}

- (void)exitVirusFromDirection:(int)direction {
    VirusParticleSystem *virus = [self.virusArray objectAtIndex:direction];
    CGPoint endLoc;
    switch (direction) {
        case kVirusDirectionTop:
            endLoc = ccp(160,500);
            break;
        case kVirusDirectionTopLeft:
            endLoc = ccp(-100,240+75);
            break;
        case kVirusDirectionTopRight:
            endLoc = ccp(420,240+75);
            break;
        case kVirusDirectionBotLeft:
            endLoc = ccp(-100,240-75);
            break;
        case kVirusDirectionBotRight:
            endLoc = ccp(420,240-75);
            break;
        case kVirusDirectionBot:
            endLoc = ccp(160,-100);
            break;
        default:
            break;
    }
    NSLog(@"direction %@, %d", self.virusArray, direction);
    [virus runAction:[CCMoveTo actionWithDuration:0.5 position:endLoc]];
    [self.virusArray removeObject:virus];
    
}

- (void)setOwnVirus {
    self.personalVirus = [[VirusParticleSystem alloc] initWithScale:1.0];
    NSLog(@"set own virus %@", self.personalVirus);
    [self.personalVirus setPosition:CGPointMake(160, 240-50)];
    [self.personalVirus setWithAttributes:[StatsManager sharedManager].personalVirus.attributes];
    [self.personalVirus.virusNameLabel setString:[StatsManager sharedManager].personalVirus.name];
    [self.personalVirus setVirusObj:[[StatsManager sharedManager]personalVirus]];
    [self addChild:self.personalVirus];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    for (VirusParticleSystem *virus in self.virusArray) {
        if ([virus isKindOfClass:[NSString class]]) {
            continue;
        }
        if ([self distanceBetween:virus.position and:location] < 45) {
            [virus enableCircleForVirusType:kCircleWhite];
            self.touchedOtherVirus = virus;
            break;
        }
    }
    
    if ([self distanceBetween:self.personalVirus.position and:location] < 45) {
        [self.personalVirus enableCircleForVirusType:kCircleGreen];
        self.ownVirusSelected = YES;
    } else {
        self.ownVirusSelected = NO;
    }
    
    
    //NSLog(@"touching");
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    BOOL touched = NO;
    if (!self.touchedOtherVirus) {
        for (VirusParticleSystem *virus in self.virusArray) {
            if ([virus isKindOfClass:[NSString class]]) {
                continue;
            }
            //NSLog(@"bounding pos %@ point %@", NSStringFromCGPoint(virus.position), NSStringFromCGPoint(location));
            if ([self distanceBetween:virus.position and:location] < 45) {
                touched = YES;
                if (self.targetVirus && self.targetVirus == virus) {
                    break;
                } else if (self.targetVirus) {
                    [self.targetVirus disableCircle];
                }
                
                if (self.personalVirus.hasCircle) {
                    // only if own virus is selected
                    [virus enableCircleForVirusType:kCircleRed];
                    self.targetVirus = virus;
                    [self updateInfectLineBetweenVirusSystem:self.personalVirus andOtherSystem:virus];
                }
                break;
            }
        }
        if (!touched && self.targetVirus) {
            [self.targetVirus disableCircle];
            self.targetVirus = nil;
        }
        if (!touched && self.ownVirusSelected) {
            [self updateInfectLineBetweenVirusSystem:self.personalVirus andPoint:location];
        }
        
    } else {
        // logic for others
        for (VirusParticleSystem *virus in self.virusArray) {
            if ([virus isKindOfClass:[NSString class]]) {
                continue;
            }
            if ([self distanceBetween:virus.position and:location] < 45) {
                if (self.touchedOtherVirus) {
                    if ([self.touchedOtherVirus isEqual:virus]) {
                        break;
                    } else {
                        [self.touchedOtherVirus disableCircle];
                    }
                }
                [virus enableCircleForVirusType:kCircleWhite];
                self.touchedOtherVirus = virus;
                
            }
        }
        if (!touched && self.touchedOtherVirus) {
            [self.touchedOtherVirus disableCircle];
            self.touchedOtherVirus = nil;
        }
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.touchedOtherVirus) {
        // Show profile
        [self.touchedOtherVirus disableCircle];
        NSLog(@"Show profile");
        [self.delegate mainLayer:self didRequestProfileForVirusObj:self.touchedOtherVirus.virusObj];
    } else if (self.targetVirus){
        [self.targetVirus disableCircle];
        [self.personalVirus disableCircle];
        NSLog(@"Target virus");
        [self.delegate mainLayer:self didTargetVirusObj:self.targetVirus.virusObj];
    } else {
        // Check if click own self
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        if ([self distanceBetween:self.personalVirus.position and:location] < 45) {
            NSLog(@"Check own profile");
            [self.delegate mainLayer:self didRequestProfileForVirusObj:self.personalVirus.virusObj];
        }
        [self.personalVirus disableCircle];
    }
    self.infectLinePointsArray = nil;
    self.touchedOtherVirus = nil;
    self.targetVirus = nil;
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"cancel");
    [self.personalVirus disableCircle];
    [self.touchedOtherVirus disableCircle];
}

- (float) distanceBetween : (CGPoint) p1 and: (CGPoint)p2
{
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
}

- (void)updateInfectLineBetweenVirusSystem:(VirusParticleSystem *)virusSystem andPoint:(CGPoint)location {
    CGPoint p1 = virusSystem.position;
    CGPoint p2 = location;
    self.infectLinePointsArray = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p1],
                                  [NSValue valueWithCGPoint:p2], nil];
}

- (void)updateInfectLineBetweenVirusSystem:(VirusParticleSystem *)virusSystem andOtherSystem:(VirusParticleSystem *)otherVirusSystem {
    CGPoint p1 = virusSystem.position;
    CGPoint p2 = otherVirusSystem.position;
    CGPoint midPoint = CGPointMake((p1.x+p2.x)/2., (p1.y+p2.y)/2.);
    float distance = [self distanceBetween:p1 and:p2];
    float angle = atanf((p2.y-p1.y)/(p2.x-p1.x));
    
    self.infectLinePointsArray = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p1],
                                  [NSValue valueWithCGPoint:p2], nil];

}

#pragma mark - Virus protocol
- (void)virus:(Virus *)virus didCompleteDownloadWithSuccess:(BOOL)success {
    [self loadNewVirusWith:virus];
}

- (void)draw {
    [super draw];
    
    
    if ([self.infectLinePointsArray count] > 0) {
        glEnable(GL_LINE_SMOOTH);
        glColor4f(1, 0, 0, 1);
        //ccDrawColor4B(209, 75, 75, 255);
        
        //float lineWidth = 6.0 * CC_CONTENT_SCALE_FACTOR();
        
        glLineWidth(3);
        
        CGPoint pos1 = [[self.infectLinePointsArray objectAtIndex:0] CGPointValue];
        CGPoint pos2 = [[self.infectLinePointsArray objectAtIndex:1] CGPointValue];
        ccDrawLine(pos1, pos2);
        
        //[self drawCurPoint:pos1 PrevPoint:pos2];
        
    }
}

- (void) drawCurPoint:(CGPoint)curPoint PrevPoint:(CGPoint)prevPoint
{
    float lineWidth = 1.0;
    ccColor4F red = ccc4f(209.0/255.0, 75.0/255.0, 75.0/255.0, 1.0);
    
    //These lines will calculate 4 new points, depending on the width of the line and the saved points
    CGPoint dir = ccpSub(curPoint, prevPoint);
    CGPoint perpendicular = ccpNormalize(ccpPerp(dir));
    CGPoint A = ccpAdd(prevPoint, ccpMult(perpendicular, lineWidth / 2));
    CGPoint B = ccpSub(prevPoint, ccpMult(perpendicular, lineWidth / 2));
    CGPoint C = ccpAdd(curPoint, ccpMult(perpendicular, lineWidth / 2));
    CGPoint D = ccpSub(curPoint, ccpMult(perpendicular, lineWidth / 2));
    
    CGPoint poly[4] = {A, C, D, B};
    
    //Then draw the poly, and a circle at the curPoint to get smooth corners
    ccDrawSolidPoly(poly, 4, YES);
    //ccDrawSolidCircle(curPoint, lineWidth/2.0, 20);
}

        
@end
