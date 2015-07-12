//
//  MainViewController.m
//  cocos2d-1.x-ARC-iOS
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import "MainViewController.h"
#import "GameConfig.h"
#import "cocos2d.h"
#import "CreateVirusLayer.h"
#import "MainLayer.h"
#import "Constants.h"
#import "StatsManager.h"
#import "ProfileLayer.h"
#import "vProfileView.h"
#import "VirusParticleSystem.h"
#import "Virus.h"
#import "vActionView.h"


@interface MainViewController ()

@end

@implementation MainViewController

@synthesize mainLayer = _mainLayer;
@synthesize mainScene = _mainScene;
@synthesize profileView = _profileView;
@synthesize profileLayer = _profileLayer;

@synthesize centralManager = _centralManager;
@synthesize discoveredPeripheral = _discoveredPeripheral;
@synthesize data = _data;
@synthesize prevConnectedPeripheralArray = _prevConnectedPeripheralArray;




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
	// Do any additional setup after loading the view.
    
    
    // Central setup
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.data = [[NSMutableData alloc] init];
    self.prevConnectedPeripheralArray = [[NSMutableArray alloc] init];
    
    [[StatsManager sharedManager] setMainViewController:self];
    [[StatsManager sharedManager] setPersonalVirus:[[Virus alloc] initFromUserDefaults]];
    [[StatsManager sharedManager] setDelegate:self];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    if (director.runningScene) {
        EAGLView *glView = [[StatsManager sharedManager] glView];
        [glView setFrame:CGRectMake(0, 0, 320, 455)];
        [self.view addSubview:glView];
        self.mainScene = [MainLayer scene];
        self.mainLayer = [MainLayer node];
        [self.mainLayer setParentVC:self];
        [self.mainScene addChild: self.mainLayer];

        [director replaceScene:self.mainScene];
    } else {
        EAGLView *glview = [EAGLView viewWithFrame:CGRectMake(0, 0, 320, 455)];
        [self.view addSubview:glview];
        [director setOpenGLView:glview];
        
        self.mainScene = [MainLayer scene];
        self.mainLayer = [MainLayer node];
        [self.mainLayer setParentVC:self];
        [self.mainScene addChild: self.mainLayer];
        
        [director runWithScene:self.mainScene];
    }
    
    [self.mainLayer setDelegate:self];
    self.energyBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    [self.energyBarView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:self.energyBarView];

    
    self.energyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 0)];
    [self.energyCountLabel setFont:[UIFont fontWithName:@"League Gothic" size:30]];
    [self.energyCountLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.energyCountLabel];
    [self setEnergyBar:[StatsManager sharedManager].personalVirusEnergy andMax:[StatsManager sharedManager].personalVirus.maxEnergy];
    
    
   // [self showProfileOfVirus:0];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)setEnergyBar:(int)current andMax:(int)maximum {
    [UIView animateWithDuration:0.5 animations:^ {
        [self.energyBarView setFrame:CGRectMake(0, 0, 320*current/(float)maximum, self.energyBarView.bounds.size.height)];
    }];
    
    [self.energyCountLabel setText:[NSString stringWithFormat:@"ENERGY: %d", current]];
    [self.energyCountLabel sizeToFit];
    [self.energyCountLabel setCenter:CGPointMake(self.energyCountLabel.center.x, 20)];
}

- (void)showProfileOfVirus:(Virus *)virusObj {
    if (!self.profileView) {
        [self.energyBarView setHidden:YES];
        [self.energyCountLabel setHidden:YES];
        self.profileLayer = [ProfileLayer node];
        [self.profileLayer.virusParticle setVirusObj:virusObj];
        [self.profileLayer.virusParticle setWithAttributes:virusObj.attributes];
        [self.profileLayer.virusParticle.virusNameLabel setString:virusObj.name];
        [self.mainScene addChild:self.profileLayer];
        
        NSLog(@"VIRUS %@ %@", virusObj, virusObj.attributes);
        
        [self.profileLayer enterScreen];
        
        self.profileView = [[vProfileView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) andVirus:virusObj];
        //self.profileView = [[vProfileView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView animateWithDuration:0.5 animations:^ {
            [self.profileView setFrame:CGRectMake(0, 0, self.profileView.bounds.size.width, self.profileView.bounds.size.height)];
        }];
        [self.profileView.longevityButton addTarget:self action:@selector(onIncreaseLongevity) forControlEvents:UIControlEventTouchUpInside];
        [self.profileView.energyButton addTarget:self action:@selector(onIncreaseEnergy) forControlEvents:UIControlEventTouchUpInside];
        [self.profileView.closeButton addTarget:self action:@selector(onCloseProfile) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.profileView];
    }
}

- (void)onIncreaseLongevity {
    [self.profileView.virus setDelegate:self];
    [self.profileView.virus upgradeEnergy:self.profileView.virus.maxEnergy andLongevity:(2*self.profileView.virus.longevity) withPointsRequired:self.profileView.virus.pointsForLongevityUpgrade];

    NSLog(@"toch");
}

- (void)onIncreaseEnergy {
    NSLog(@"virus = %@ %i", self.profileView.virus, self.profileView.virus.pointsForEnergyUpgrade);
    [self.profileView.virus setDelegate:self];
    [self.profileView.virus upgradeEnergy:(2*self.profileView.virus.maxEnergy) andLongevity:self.profileView.virus.longevity withPointsRequired:self.profileView.virus.pointsForEnergyUpgrade];

    NSLog(@"touch 2");
}

- (void)onCloseProfile {
    [self.profileLayer exitScreen];
    [self.energyBarView setHidden:NO];
    [self.energyCountLabel setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^ {
        [self.profileView setFrame:CGRectMake(0, self.view.frame.size.height, self.profileView.bounds.size.width, self.profileView.bounds.size.height)];
    } completion:^(BOOL finished) {
        [self.profileView removeFromSuperview];
        self.profileView = nil;
        
        [self.mainScene removeChild:self.profileLayer cleanup:YES];
    }];
}

- (void)virus:(Virus *)virus didUpgradeWithSuccess:(BOOL)success
{
    NSLog(@"Success");
    if (success) {
        NSLog(@"Success");
        [self.profileView redrawWithNewVirus];
        if (self.profileView.virus.pointsForEnergyUpgrade > self.profileView.virus.points) [self.profileView.energyButton setUserInteractionEnabled:NO];
        if (self.profileView.virus.pointsForLongevityUpgrade > self.profileView.virus.points) [self.profileView.longevityButton setUserInteractionEnabled:NO];
    } else {
        NSLog(@"Error here");
    }
}

- (void)showActionViewOfVirus:(Virus *)virusObj andTargetVirus:(Virus *)targetVirus
{
    [self.energyBarView setHidden:YES];
    [self.energyCountLabel setHidden:YES];
    
    
    self.actionView = [[vActionView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) andVirus:virusObj];
    [self.view addSubview:self.actionView];
    self.actionView.targetVirus = targetVirus;
    [UIView animateWithDuration:0.5 animations:^ {
        [self.actionView setFrame:CGRectMake(0, 0, self.actionView.bounds.size.width, self.actionView.bounds.size.height)];
    }];
    
    [self.actionView.infectButton addTarget:self action:@selector(onInfect) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView.healButton addTarget:self action:@selector(onHeal) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView.closeButton addTarget:self action:@selector(onCloseActionView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onCloseActionView
{
    [self.energyBarView setHidden:NO];
    [self.energyCountLabel setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^ {
        [self.actionView setFrame:CGRectMake(0, self.view.frame.size.height, self.actionView.bounds.size.width, self.actionView.bounds.size.height)];
    } completion:^(BOOL finished) {
        [self.actionView removeFromSuperview];
        self.actionView = nil;
        
    }];
}

- (void)onInfect {
    int successRate = self.actionView.successRate;
    int success = rand() % 100;
    if (success < successRate) {
        NSLog(@"Success infect");
        [self.actionView.virus infectEnemyWithID:self.actionView.targetVirus.virusID];
    } else {
        NSLog(@"Failed infect");
    }
    [self sendAwayVirus:self.actionView.targetVirus];
    [StatsManager sharedManager].personalVirusEnergy -= successRate/20;
    [self onCloseActionView];
}

- (void)onHeal {
    int successRate = self.actionView.successRate;
    int success = rand() % 100;
    if (success < successRate) {
        NSLog(@"Success heal");
        [self.actionView.virus healEnemyWithID:self.actionView.targetVirus.virusID];
    } else {
        NSLog(@"Failed heal");
    }
    [self sendAwayVirus:self.actionView.targetVirus];
    [StatsManager sharedManager].personalVirusEnergy -= successRate/20;
    [self onCloseActionView];
}

- (void)sendAwayVirus:(Virus *)virusObj {
    BOOL found = NO;
    for (int i = 0; i < 6; i++) {
        VirusParticleSystem *currVirus = (VirusParticleSystem *)[self.mainLayer.virusArray objectAtIndex:i];
        if (![currVirus isKindOfClass:[NSString class]]) {
            if ([currVirus.virusObj isEqual:virusObj]) {
                found = YES;
                [self.mainLayer exitVirusFromDirection:i];
                break;
            }
        }
    }
    if (!found) {
        NSLog(@"Never found'");
    }
}

#pragma mark - Central delegates

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // You should test all scenarios
    if (central.state != CBCentralManagerStatePoweredOn) {
        NSLog(@"Blue tooth not on");
        //[[StatsManager sharedManager] loadBluetoothPage];
        return;
    }
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:nil];
        //[self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        NSLog(@"Scanning started");
        [[StatsManager sharedManager] closeBluetoothPage];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if (self.discoveredPeripheral != peripheral) {
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        self.discoveredPeripheral = peripheral;
        // And connect
        

        if ([self.prevConnectedPeripheralArray containsObject:peripheral]) {
            NSLog(@"Already conntect");
            return;
        }
        [self.centralManager connectPeripheral:peripheral options:nil];
        [self.prevConnectedPeripheralArray addObject:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Failed to connect");
    [self cleanup];
}

- (void)cleanup {
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                }
            }
        }
    }
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Connected");
    //[self.centralManager stopScan];
    //NSLog(@"Scanning stopped");
    [_data setLength:0];
    peripheral.delegate = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
    // Discover other characteristics
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    NSLog(@"Didd discover characters");
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
            
            [peripheral readValueForCharacteristic:characteristic];
            //[peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error");
        return;
    }
    int newVirusID;
    [characteristic.value getBytes:&newVirusID length:sizeof(newVirusID)];
    // Have we got everything we need?

    Virus *v = [[Virus alloc] initWithVirusID:newVirusID];
    [v setDelegate:self.mainLayer];
    
    
    [self.centralManager cancelPeripheralConnection:peripheral];
    
    
    /*
    NSLog(@"REPLIED");
    NSData *reply = [@"BYE" dataUsingEncoding:NSUTF8StringEncoding];
    [peripheral writeValue:reply forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    [_data appendData:characteristic.value];
    */
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Announcement" message:@"Did respond/write" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"did write maybe?");
    if (error) {
        NSLog(@"error while writing %@", [error localizedDescription]);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    } else {
        // Notification has stopped
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    self.discoveredPeripheral = nil;
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.centralManager stopScan];
}

#pragma mark - Main Layer protocol
-(void)mainLayer:(MainLayer *)mainLayer didTargetVirusObj:(Virus *)virusObj {
    NSLog(@"Target PRESSED");
    [self showActionViewOfVirus:[[StatsManager sharedManager]personalVirus] andTargetVirus:virusObj];
}

-(void)mainLayer:(MainLayer *)mainLayer didRequestProfileForVirusObj:(Virus *)virusObj {
    [self showProfileOfVirus:virusObj];
}

#pragma mark - Stats Manager protocol
- (void)energyDidUpdateFrom:(int)fromEnergy to:(int)toEnergy {
    [UIView animateWithDuration:1.0 animations:^{
        [self.energyBarView setFrame:CGRectMake(0, 0, 320*toEnergy/(float)[StatsManager sharedManager].personalVirus.maxEnergy, self.energyBarView.frame.size.height)];
    }];
    [self.energyCountLabel setText:[NSString stringWithFormat:@"ENERGY: %d", toEnergy]];
    [self.energyCountLabel sizeToFit];
    [self.energyCountLabel setCenter:CGPointMake(self.energyCountLabel.center.x, 20)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
