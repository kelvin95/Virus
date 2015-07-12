//
//  vActionView.h
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import <UIKit/UIKit.h>
#import "Virus.h"

@interface vActionView : UIView

@property (strong, nonatomic) UIButton *infectButton;
@property (strong, nonatomic) UIButton *healButton;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *increaseButton;
@property (strong, nonatomic) UIButton *decreaseButton;

@property (strong, nonatomic) Virus *virus;
@property (strong, nonatomic) Virus *targetVirus;
@property (nonatomic) int energy;
@property (nonatomic) int successRate;

- (id)initWithFrame:(CGRect)frame andVirus:(Virus *)virus;

@end
