//
//  MainLayer.h
//  cocos2d-1.x-ARC-iOS
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import "CCLayer.h"
#import "cocos2d.h"

@class VirusParticleSystem;
@class Virus;
@class MainViewController;
@protocol VirusProtocol;
@class MainLayer;

@protocol MainLayerProtocol <NSObject>

- (void)mainLayer:(MainLayer *)mainLayer didTargetVirusObj:(Virus *)virusObj;
- (void)mainLayer:(MainLayer *)mainLayer didRequestProfileForVirusObj:(Virus *)virusObj;

@end

@interface MainLayer : CCLayer <VirusProtocol>

@property id delegate;
@property (nonatomic, strong) VirusParticleSystem *personalVirus;
@property (nonatomic, strong) NSMutableArray *virusArray;
@property (nonatomic, strong) NSArray *virusLocations;

@property (nonatomic, strong) MainViewController *parentVC;


@property (nonatomic) BOOL ownVirusSelected;
@property (nonatomic, strong) VirusParticleSystem *targetVirus; // red
@property (nonatomic, strong) VirusParticleSystem *touchedOtherVirus; // white

@property (nonatomic, strong) NSArray *infectLinePointsArray;

+(CCScene *) scene;
- (void)loadNewVirusWith:(Virus *)virusObj;
- (void)exitVirusFromDirection:(int)direction;

@end
