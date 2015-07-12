//
//  vStatsView.m
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import "vStatsView.h"
#import "vUpgradeButton.h"


@interface vStatsView()

@property (strong, nonatomic) UILabel *statNameLabel;
@property (strong, nonatomic) UILabel *statLabel;

@end

@implementation vStatsView

@synthesize statNameLabel = _statNameLabel;
@synthesize statLabel = _statLabel;

- (UILabel *)statNameLabel
{
    if (!_statNameLabel) {
        _statNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_statNameLabel setFont:[UIFont fontWithName:@"League Gothic" size:35/2.]];
        [_statNameLabel setTextAlignment:NSTextAlignmentCenter];
        [_statNameLabel setTextColor:[UIColor grayColor]];
    }
    return _statNameLabel;
}

- (UILabel *)statLabel
{
    if (!_statLabel) {
        _statLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_statLabel setFont:[UIFont fontWithName:@"League Gothic" size:35.]];
        [_statLabel setTextAlignment:NSTextAlignmentCenter];
        [_statLabel setTextColor:[UIColor whiteColor]];

    }
    return _statLabel;
}


@synthesize statName = _statName;
@synthesize stat = _stat;

- (void)setStatName:(NSString *)statName
{
    _statName = statName;
    [self.statNameLabel setText:_statName];
    [self.statNameLabel sizeToFit];
    [self updatePositions];
}

- (void)setStat:(NSString *)stat
{
    _stat = stat;
    [self.statLabel setText:_stat];
    [self.statLabel sizeToFit];
    [self updatePositions];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.statLabel];
        [self addSubview:self.statNameLabel];
        //[self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

- (void)updatePositions
{
    [self.statLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.statLabel.frame.size.height)];
    [self.statNameLabel setFrame:CGRectMake(0, self.statLabel.frame.size.height, self.frame.size.width, self.frame.size.height - self.statLabel.frame.size.height)];
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
