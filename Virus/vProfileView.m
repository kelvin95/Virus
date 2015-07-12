//
//  vProfileView.m
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import "vProfileView.h"
#import "vStatsView.h"
#import "vUpgradeButton.h"

@interface vProfileView ()

@property (strong, nonatomic) UILabel *virusNameLabel;
@property (strong, nonatomic) vStatsView *rankView;
@property (strong, nonatomic) vStatsView *pointsView;
@property (strong, nonatomic) vStatsView *infectionsView;
@property (strong, nonatomic) vStatsView *transmissionsView;

@property (strong, nonatomic) UIView *statsView;
@property (strong, nonatomic) UIView *longevityView;
@property (strong, nonatomic) UIView *energyView;

@end

@implementation vProfileView

@synthesize rankView = _rankView;
@synthesize pointsView = _pointsView;
@synthesize infectionsView = _infectionsView;
@synthesize transmissionsView = _transmissionsView;

@synthesize statsView = _statsView;
@synthesize longevityView = _longevityView;
@synthesize energyView = _energyView;

- (vStatsView *)rankView
{
    if (!_rankView) {
        _rankView = [[vStatsView alloc]initWithFrame:CGRectZero];
        [_rankView setStat:[NSString stringWithFormat:@"%d", self.virus.rank]];
        [_rankView setStatName:@"RANKED"];
        [self.statsView addSubview:_rankView];
    }
    return _rankView;
}

- (vStatsView *)pointsView
{
    if (!_pointsView) {
        NSLog(@"%@", self.virus.name);
        _pointsView = [[vStatsView alloc]initWithFrame:CGRectZero];
        [_pointsView setStat:[NSString stringWithFormat:@"%d", self.virus.points]];
        [_pointsView setStatName:@"POINTS"];
        [self.statsView addSubview:_pointsView];
    }
    return _pointsView;
}

- (vStatsView *)infectionsView
{
    if (!_infectionsView) {
        _infectionsView = [[vStatsView alloc]initWithFrame:CGRectZero];
        [_infectionsView setStat:[NSString stringWithFormat:@"%d", self.virus.infections]];
        [_infectionsView setStatName:@"INFECTED BY"];
        [self.statsView addSubview:_infectionsView];
    }
    return _infectionsView;
}

- (vStatsView *)transmissionsView
{
    if (!_transmissionsView) {
        _transmissionsView = [[vStatsView alloc]initWithFrame:CGRectZero];
        [_transmissionsView setStat:[NSString stringWithFormat:@"%d", self.virus.transmissions]];
        [_transmissionsView setStatName:@"INFECTED"];
        [self.statsView addSubview:_transmissionsView];
    }
    return _transmissionsView;
}

- (UIView *)statsView
{
    if (!_statsView) {
        _statsView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 65)];
        }
    return _statsView;
}

- (UIView *)longevityView
{
    if (!_longevityView) {
        _longevityView = [[UIView alloc]initWithFrame:CGRectMake(20, self.statsView.frame.origin.y+self.statsView.frame.size.height+20, self.frame.size.width-40, 60)];
    
        UILabel *longevityLabel = [[UILabel alloc]initWithFrame:CGRectMake(_longevityView.bounds.origin.x, _longevityView.bounds.origin.y, 0, 0)];
        [longevityLabel setTextAlignment:NSTextAlignmentCenter];
        [longevityLabel setText:@"LONGEVITY"];
        [longevityLabel setFont:[UIFont fontWithName:@"League Gothic" size:96/2]];
        [longevityLabel setTextColor:[UIColor whiteColor]];
        [longevityLabel sizeToFit];
        
        [_longevityView addSubview:longevityLabel];
        
        vUpgradeButton *longevityUpgrade = [[vUpgradeButton alloc]initWithFrame:CGRectMake(_longevityView.frame.size.width-120, _longevityView.bounds.origin.y+5, 120., longevityLabel.frame.size.height-10)];
        longevityUpgrade.statString = [NSString stringWithFormat:@"%d HOURS", self.virus.longevity];
        longevityUpgrade.upgradeString = [NSString stringWithFormat:@"DOUBLE FOR %d POINTS", self.virus.pointsForLongevityUpgrade];
        [longevityUpgrade updatePositions];
        self.longevityButton = longevityUpgrade;
        if ((self.virus.pointsForLongevityUpgrade > self.virus.points) || (!self.virus.isPersonal)) [self.longevityButton setUserInteractionEnabled:NO];
        
        [_longevityView addSubview:longevityUpgrade];
        [_longevityView sizeToFit];
    }
    return _longevityView;
}

- (UIView *)energyView
{
    if (!_energyView) {
        _energyView = [[UIView alloc]initWithFrame:CGRectMake(20, self.longevityView.frame.origin.y+self.longevityView.frame.size.height+20, self.frame.size.width-40, 60)];
        
        UILabel *energyLabel = [[UILabel alloc]initWithFrame:CGRectMake(_energyView.bounds.origin.x, _energyView.bounds.origin.y, 0, 0)];
        [energyLabel setTextAlignment:NSTextAlignmentCenter];
        [energyLabel setText:@"ENERGY"];
        [energyLabel setFont:[UIFont fontWithName:@"League Gothic" size:96/2]];
        [energyLabel setTextColor:[UIColor whiteColor]];
        [energyLabel sizeToFit];
        
        [_energyView addSubview:energyLabel];
        
        vUpgradeButton *energyUpgrade = [[vUpgradeButton alloc]initWithFrame:CGRectMake(_energyView.frame.size.width-120, _energyView.bounds.origin.y+5, 120., energyLabel.frame.size.height-10)];
        energyUpgrade.statString = [NSString stringWithFormat:@"%d", self.virus.maxEnergy];
        energyUpgrade.upgradeString = [NSString stringWithFormat:@"DOUBLE FOR %d POINTS", self.virus.pointsForEnergyUpgrade];
        [energyUpgrade updatePositions];

        self.energyButton = energyUpgrade;
        NSLog(@"POINTS REQUIRED = %i", self.virus.pointsForEnergyUpgrade);
        [self.energyButton setUserInteractionEnabled:YES];
        if ((self.virus.pointsForEnergyUpgrade > self.virus.points) || (!self.virus.isPersonal))[self.energyButton setUserInteractionEnabled:NO];
        NSLog(@"POINTS REQUIRED = %i %@", self.virus.pointsForEnergyUpgrade, self.energyButton);

        [_energyView addSubview:energyUpgrade];
        [_energyView sizeToFit];
    }
    return _energyView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [_closeButton setCenter:CGPointMake(15, 15)];
        [_closeButton setImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
        [_closeButton setContentMode:UIViewContentModeCenter];
    }
    return _closeButton;
}

- (id)initWithFrame:(CGRect)frame andVirus:(Virus *)virus
{
    self = [super initWithFrame:frame];
    if (self) {
        self.virus = virus;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, self.frame.size.width, self.frame.size.height-200)];
        
        [containerView addSubview:self.statsView];
        [self updateStatsView];
        
        [containerView addSubview:self.longevityView];
        [containerView addSubview:self.energyView];
        
        [self addSubview:containerView];
        [self addSubview:self.closeButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, self.frame.size.width, self.frame.size.height-200)];
        
        [containerView addSubview:self.statsView];
        [self updateStatsView];
        
        [containerView addSubview:self.longevityView];
        [containerView addSubview:self.energyView];
        
        [self addSubview:containerView];
        [self addSubview:self.closeButton];

    }
    return self;
}

- (void)updateStatsView
{
    CGFloat quarterWidth = self.statsView.frame.size.width/4.;
    
    [self.rankView setFrame:CGRectMake(self.statsView.bounds.origin.x, self.statsView.bounds.origin.y, quarterWidth, self.statsView.frame.size.height)];
    [self.rankView updatePositions];
    [self.transmissionsView setFrame:CGRectMake(self.statsView.bounds.origin.x+quarterWidth, self.statsView.bounds.origin.y,quarterWidth, self.statsView.frame.size.height)];
    [self.transmissionsView updatePositions];
    [self.infectionsView setFrame:CGRectMake(self.statsView.bounds.origin.x+(quarterWidth*2), self.statsView.bounds.origin.y, quarterWidth, self.statsView.frame.size.height)];
    [self.infectionsView updatePositions];
    [self.pointsView setFrame:CGRectMake(self.statsView.bounds.origin.x+(quarterWidth*3), self.statsView.bounds.origin.y, quarterWidth, self.statsView.frame.size.height)];
    [self.pointsView updatePositions];
    [self.statsView sizeToFit];
}

- (void)redrawWithNewVirus
{
    self.energyButton.statString = [NSString stringWithFormat:@"%d", self.virus.maxEnergy];
    self.energyButton.upgradeString = [NSString stringWithFormat:@"DOUBLE FOR %d POINTS", self.virus.pointsForEnergyUpgrade];
    [self.energyButton updatePositions];
    if ((self.virus.pointsForEnergyUpgrade > self.virus.points) || (!self.virus.isPersonal))[self.energyButton setUserInteractionEnabled:NO];

    self.longevityButton.statString = [NSString stringWithFormat:@"%d HOURS", self.virus.longevity];
    self.longevityButton.upgradeString = [NSString stringWithFormat:@"DOUBLE FOR %d POINTS", self.virus.pointsForLongevityUpgrade];
    [self.longevityButton updatePositions];
    if ((self.virus.pointsForLongevityUpgrade > self.virus.points) || (!self.virus.isPersonal)) [self.longevityButton setUserInteractionEnabled:NO];

    [self.pointsView setStat:[NSString stringWithFormat:@"%d", self.virus.points]];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat gray[4] = {255.0f, 255.0f, 255.0f, 255.0f};
    CGContextSetStrokeColor(c, gray);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0.0f, 220.0f);
    CGContextAddLineToPoint(c, self.frame.size.width, 220.0f);
    CGContextStrokePath(c);
    
    
}


@end
