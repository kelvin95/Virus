//
//  vActionView.m
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import "vActionView.h"
#import "vActionStatsView.h"
#import "StatsManager.h"
#include <math.h>

@interface vActionView()

@property (strong, nonatomic) vActionStatsView *energyStatsView;
@property (strong, nonatomic) vActionStatsView *successRateView;

@end

@implementation vActionView

@synthesize energyStatsView = _energyStatsView;
@synthesize successRateView = _successRateView;

- (vActionStatsView *)energyStatsView
{
    if (!_energyStatsView) {
        _energyStatsView = [[vActionStatsView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-370)/4., 200, 175)];
        [_energyStatsView setCenter:CGPointMake(160, _energyStatsView.center.y)];
        _energyStatsView.statsName = @"ENERGY USED";
        _energyStatsView.stats = @"0";
        [_energyStatsView updatePositions];
    }
    return _energyStatsView;
}

- (vActionStatsView *)successRateView
{
    if (!_successRateView) {
        _successRateView = [[vActionStatsView alloc]initWithFrame:CGRectMake(0, self.energyStatsView.frame.origin.y+self.energyStatsView.frame.size.height+20, 200, 175)];
        [_successRateView setCenter:CGPointMake(160, _successRateView.center.y)];
        _successRateView.statsName = @"SUCCESS RATE";
        _successRateView.stats = @"0";
        [_successRateView updatePositions];
    }
    return _successRateView;
}

@synthesize infectButton = _infectButton;
@synthesize healButton = _healButton;

- (UIButton *)infectButton
{
    if (!_infectButton) {
        _infectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 295/2., 125/2.)];
        [_infectButton setCenter:CGPointMake(80, self.frame.size.height-(125/4.)-10)];
        [_infectButton setImage:[UIImage imageNamed:@"infect_button.png"] forState:UIControlStateNormal];
    }
    return _infectButton;
}

- (UIButton *)healButton
{
    if (!_healButton) {
        _healButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 295/2., 125/2.)];
        [_healButton setImage:[UIImage imageNamed:@"heal_button.png"] forState:UIControlStateNormal];
        [_healButton setCenter:CGPointMake(240, self.frame.size.height-(125/4.)-10)];

    }
    return _healButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [_closeButton setCenter:CGPointMake(15, 15)];
        [_closeButton setContentMode:UIViewContentModeCenter];
        [_closeButton setImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIButton *)increaseButton
{
    if (!_increaseButton) {
        _increaseButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-45-(60*0.7), self.energyStatsView.frame.origin.y+80, 60*0.7, 100*0.7)];
        [_increaseButton setImage:[UIImage imageNamed:@"increase_button.png"] forState:UIControlStateNormal];
        [_increaseButton addTarget:self action:@selector(increaseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _increaseButton;
}

- (UIButton *)decreaseButton
{
    if (!_decreaseButton) {
        _decreaseButton = [[UIButton alloc]initWithFrame:CGRectMake(45, self.energyStatsView.frame.origin.y+80, 60*0.7, 100*0.7)];
        [_decreaseButton setImage:[UIImage imageNamed:@"decrease_button.png"] forState:UIControlStateNormal];
        [_decreaseButton addTarget:self action:@selector(decreaseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _decreaseButton;
}

- (void)increaseButtonPressed
{
    if ((self.energy+1 >=5) || (self.energy+1 >= [[StatsManager sharedManager]personalVirusEnergy])) {
        self.energy = MIN(5, [[StatsManager sharedManager]personalVirusEnergy]);
    } else {
        self.energy += 1;
    }
    [self updateStats];
}

- (void)decreaseButtonPressed
{
    if ((self.energy-1 <= 0)) {
        self.energy = 0;
    } else {
        self.energy -= 1;
    }
    [self updateStats];
}

- (void)updateStats
{
    self.energyStatsView.stats = [NSString stringWithFormat:@"%d", self.energy];
    self.successRate = self.energy * 20;
    self.successRateView.stats = [NSString stringWithFormat:@"%d%%", self.successRate];
    if (self.successRate == 0) {
        [self.infectButton setHighlighted:YES];
        [self.infectButton setUserInteractionEnabled:NO];
        [self.healButton setHighlighted:YES];
        [self.healButton setUserInteractionEnabled:NO];
    } else {
        [self.infectButton setHighlighted:NO];
        [self.infectButton setUserInteractionEnabled:YES];
        [self.healButton setHighlighted:NO];
        [self.healButton setUserInteractionEnabled:YES];
    }
}

- (id)initWithFrame:(CGRect)frame andVirus:(Virus *)virus
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setAlpha:0.9];
        self.virus = virus;
        [self addSubview:self.infectButton];
        [self addSubview:self.healButton];
        [self addSubview:self.energyStatsView];
        [self addSubview:self.successRateView];
        [self addSubview:self.increaseButton];
        [self addSubview:self.decreaseButton];
        [self addSubview:self.closeButton];
        self.energy = 0;
        self.successRate = 0;
        [self updateStats];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.infectButton];
        [self addSubview:self.healButton];
        [self addSubview:self.energyStatsView];
        [self addSubview:self.successRateView];
        [self addSubview:self.closeButton];
        [self addSubview:self.increaseButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
