//
//  Virus.h
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import <Foundation/Foundation.h>
@class Virus;
@protocol VirusProtocol <NSObject>

- (void)virus:(Virus *)virus didCompleteDownloadWithSuccess:(BOOL)success;
- (void)virus:(Virus *)virus didUpgradeWithSuccess:(BOOL)success;

@end

@interface Virus : NSObject

- (id)initWithAttributes:(NSMutableDictionary *)attributes;
- (id)initWithVirusID:(int)virusID;
- (id)initFromUserDefaults;
- (void)upgradeEnergy:(int)energy andLongevity:(int)longevity withPointsRequired:(int)pointsRequired;
- (void)infectEnemyWithID:(int)enemyID;
- (void)healEnemyWithID:(int)enemyID;
- (void)saveVirusToUserDefaults;

@property id delegate;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL isPersonal;

@property (nonatomic) int virusID;
@property (nonatomic) int maxEnergy;
@property (nonatomic) int longevity;
@property (nonatomic) int points;
@property (nonatomic) int rank;
@property (nonatomic) int infections;
@property (nonatomic) int transmissions;

@property (nonatomic) int pointsForEnergyUpgrade;
@property (nonatomic) int pointsForLongevityUpgrade;
@end
