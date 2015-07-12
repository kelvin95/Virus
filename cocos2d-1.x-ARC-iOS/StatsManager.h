//
//  StatsManager.h
//  Virus Final
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol StatsManagerProtocol <NSObject>

- (void)energyDidUpdateFrom:(int)fromEnergy to:(int)toEnergy;

@end

@class MainViewController;
@class Virus;
@class EAGLView;
@class Reachability;

@interface StatsManager : NSObject <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;
@property (strong, nonatomic) NSData *dataToSend;
@property (nonatomic, readwrite) NSInteger sendDataIndex;

@property (nonatomic, strong) MainViewController *mainViewController;
@property (nonatomic, strong) Virus *personalVirus;
@property (nonatomic) NSData *virusIDData;

@property (nonatomic, strong) EAGLView *glView;

@property (nonatomic) int personalVirusEnergy;
@property (strong, nonatomic) id delegate;

@property (nonatomic, strong) Reachability *reach;

+(StatsManager *)sharedManager;

- (void)loadWifiPage;
- (void)loadBluetoothPage;
- (void)closeWifiPage;
- (void)closeBluetoothPage;

@end
