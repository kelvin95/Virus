//
//  StatsManager.m
//  Virus Final
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import "StatsManager.h"
#import "Constants.h"
#import "MainViewController.h"
#import "MainLayer.h"
#include <math.h>
#import "Reachability.h"
#import "vWifiView.h"
#import "vBluetoothView.h"

#define kBluetoothPage -13
#define kWifiPage -14

@interface StatsManager()

@property (strong, nonatomic) NSTimer *timer;

@end


@implementation StatsManager

@synthesize timer = _timer;

- (void)setPersonalVirusEnergy:(int)personalVirusEnergy
{
    _personalVirusEnergy = personalVirusEnergy;
    [self.delegate energyDidUpdateFrom:0 to:personalVirusEnergy];
}

- (void)setPersonalVirus:(Virus *)personalVirus
{
    _personalVirus = personalVirus;
    self.personalVirusEnergy = [[[NSUserDefaults standardUserDefaults] objectForKey:@"personalVirusEnergy"]intValue];
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"timestampWhenAppClosed"];
    if (date) {
        NSLog(@"TIME INTERVAL = %f", [[NSDate date]timeIntervalSinceDate:date]);
        int energy = floor((double)([[NSDate date]timeIntervalSinceDate:date]/(3600.0/self.personalVirus.maxEnergy)));
        NSLog(@"ENERGY = %f", [[NSDate date]timeIntervalSinceDate:date]);
        NSLog(@"ENERGY = %d", energy);
        if (self.personalVirusEnergy+energy >= self.personalVirus.maxEnergy) {
            self.personalVirusEnergy = self.personalVirus.maxEnergy;
        } else {
            self.personalVirusEnergy += energy;
        }
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3600.0/self.personalVirus.maxEnergy target:self selector:@selector(addEnergy:) userInfo:nil repeats:YES];
    //self.personalVirusEnergy = 6;
    //self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(addEnergy:) userInfo:nil repeats:YES];
    


}

- (void)addEnergy:(NSTimer *)timer
{
    int energy = 1;
    if (self.personalVirusEnergy + energy >= self.personalVirus.maxEnergy) {
        [self.delegate energyDidUpdateFrom:self.personalVirusEnergy to:self.personalVirus.maxEnergy];
        self.personalVirusEnergy = self.personalVirus.maxEnergy;
        
    } else {
        [self.delegate energyDidUpdateFrom:self.personalVirusEnergy to:self.personalVirusEnergy+1];
        self.personalVirusEnergy += 1;
    }
    NSLog(@"New energy %d", self.personalVirusEnergy);
}

@synthesize personalVirus = _personalVirus;
@synthesize glView = _glView;



+(StatsManager *)sharedManager
{
    static StatsManager *sharedManager;
    
    @synchronized (self)
    {
        if (!sharedManager) {
            sharedManager = [[StatsManager alloc] init];
        }
        return sharedManager;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int virusID = [[defaults objectForKey:@"virusID"] intValue];
        self.virusIDData = [NSData dataWithBytes:&virusID length:sizeof(virusID)];
        
        self.reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        self.reach.reachableOnWWAN = YES;
        NSLog(@"Enabled notication");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        [self.reach startNotifier];
    }
    return self;
}

- (void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        NSLog(@"Wifi enabled");
        [self closeWifiPage];
        
    }
    else
    {
        NSLog(@"wifi disabled");
        [self loadWifiPage];
    }
}

- (void)loadWifiPage {
    CGSize size = self.mainViewController.view.bounds.size;
    vWifiView *wifi = [[vWifiView alloc] initWithFrame:CGRectMake(0, -size.height, size.width, size.height)];
    [self.mainViewController.view addSubview:wifi];
    [UIView animateWithDuration:1.0 animations:^{
        [wifi setFrame:CGRectMake(0, 0, size.width, size.height)];
    }];
    [wifi setTag:kWifiPage];
    [wifi.tryAgainButton addTarget:self action:@selector(tryWifi) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadBluetoothPage {
    CGSize size = self.mainViewController.view.bounds.size;
    vBluetoothView *bluetooth = [[vBluetoothView alloc] initWithFrame:CGRectMake(0, -size.height, size.width, size.height)];
    [self.mainViewController.view addSubview:bluetooth];
    [UIView animateWithDuration:1.0 animations:^{
        [bluetooth setFrame:CGRectMake(0, 0, size.width, size.height)];
    }];
    [bluetooth setTag:kBluetoothPage];
    [bluetooth.tryAgainButton addTarget:self action:@selector(tryBluetooth) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tryBluetooth {
    if (self.mainViewController.centralManager.state == CBCentralManagerStatePoweredOn) {
        [self closeBluetoothPage];
    }
}

- (void)tryWifi {
    if ([self.reach isReachable]) {
        [self closeWifiPage];
    }
}


- (void)closeWifiPage {
    CGSize size = self.mainViewController.view.bounds.size;
    
    UIView *view = [self.mainViewController.view viewWithTag:kWifiPage];
    if (view) {
        [UIView animateWithDuration:1.0 animations:^{
            [view setFrame:CGRectMake(0, -size.height, size.width, size.height)];
        }completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    
}

- (void)closeBluetoothPage {
    CGSize size = self.mainViewController.view.bounds.size;
    UIView *view = [self.mainViewController.view viewWithTag:kBluetoothPage];
    if (view) {
        [UIView animateWithDuration:1.0 animations:^{
            [view setFrame:CGRectMake(0, -size.height, size.width, size.height)];
        }completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"power off");
        return;
    }
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyRead|CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsReadable|CBAttributePermissionsWriteable];
        
        CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID] primary:YES];
        transferService.characteristics = @[_transferCharacteristic];
        [_peripheralManager addService:transferService];
        NSLog(@"power on");
        
        [_peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"send datata");
    _dataToSend = [@"VIRUS" dataUsingEncoding:NSUTF8StringEncoding];
    _sendDataIndex = 0;
    [self sendData];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"Handling read request");
    if ([request.characteristic.UUID isEqual:self.transferCharacteristic.UUID]) {
        NSLog(@"Responded");
        request.value = self.virusIDData;
        [self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    }
    NSLog(@"End of handling");
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests {
    NSLog(@"Received feedback");
    /*
    for (CBATTRequest *req in requests) {
        NSString *stringFromData = [[NSString alloc] initWithData:req.value encoding:NSUTF8StringEncoding];
        NSLog(@"stringg recv %@", stringFromData);
        [peripheral respondToRequest:req withResult:CBATTErrorSuccess];
        [self.mainViewController.mainLayer loadNewVirus];
    }
     */
}

- (void)sendData {
    static BOOL sendingEOM = NO;
    // end of message?
    if (sendingEOM) {
        BOOL didSend = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        if (didSend) {
            // It did, so mark it as sent
            sendingEOM = NO;
        }
        // didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
        return;
    }
    // We're sending data
    // Is there any left to send?
    if (self.sendDataIndex >= self.dataToSend.length) {
        // No data left.  Do nothing
        return;
    }
    // There's data left, so send until the callback fails, or we're done.
    BOOL didSend = YES;
    while (didSend) {
        // Work out how big it should be
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        // Can't be longer than 20 bytes
        if (amountToSend > NOTIFY_MTU) amountToSend = NOTIFY_MTU;
        // Copy out the data we want
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
        didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        // If it didn't work, drop out and wait for the callback
        if (!didSend) {
            return;
        }
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);
        // It did send, so update our index
        self.sendDataIndex += amountToSend;
        NSLog(@"index count %d, %d", self.sendDataIndex, self.dataToSend.length);
        // Was it the last one?
        if (self.sendDataIndex >= self.dataToSend.length) {
            // Set this so if the send fails, we'll send it next time
            sendingEOM = YES;
            BOOL eomSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
            NSLog(@"EOM sent? %d", eomSent);
            if (eomSent) {
                // It sent, we're all done
                sendingEOM = NO;
                NSLog(@"Sent: EOM");
            }
            return;
        }
    }
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    [self sendData];
}


@end
