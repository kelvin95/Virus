//
//  vUpgradeButton.h
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import <UIKit/UIKit.h>

@interface vUpgradeButton : UIButton

@property (strong, nonatomic) NSString *upgradeString;
@property (strong, nonatomic) NSString *statString;

- (void)updatePositions;
- (void)disableButtonForUpgrade:(BOOL)disable;

@end
