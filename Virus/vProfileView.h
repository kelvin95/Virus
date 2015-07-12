//
//  vProfileView.h
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import <UIKit/UIKit.h>
#import "vUpgradeButton.h"
#import "Virus.h"

@interface vProfileView : UIView

- (id)initWithFrame:(CGRect)frame andVirus:(Virus *)virus;

@property (strong, nonatomic) Virus *virus;

@property (strong, nonatomic) vUpgradeButton *longevityButton;
@property (strong, nonatomic) vUpgradeButton *energyButton;
@property (strong, nonatomic) UIButton *closeButton;

- (void)redrawWithNewVirus;



@end
