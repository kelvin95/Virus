//
//  MainViewController.h
//  cocos2d-1.x-ARC-iOS
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Virus.h"
#import "MainLayer.h"
#import "StatsManager.h"
#import "vActionView.h"

@class MainLayer;
@class CCScene;
@class vProfileView;
@class ProfileLayer;
@class Virus;
@protocol MainLayerProtocol;

@interface MainViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, VirusProtocol, MainLayerProtocol, StatsManagerProtocol>

@property (nonatomic, strong) UILabel *energyCountLabel;
@property (nonatomic, strong) UIView *energyBarView;
@property (nonatomic, strong) ProfileLayer *profileLayer;

@property (nonatomic, strong) CCScene *mainScene;
@property (nonatomic, strong) MainLayer *mainLayer;
@property (nonatomic, strong) vProfileView *profileView;
@property (nonatomic, strong) vActionView *actionView;

// Peripheral
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;
@property (strong, nonatomic) NSData *dataToSend;
@property (nonatomic, readwrite) NSInteger sendDataIndex;


// Central
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSMutableArray *prevConnectedPeripheralArray;

- (void)setEnergyBar:(int)current andMax:(int)maximum;

- (void)showProfileOfVirus:(Virus *)virusObj;

@end
