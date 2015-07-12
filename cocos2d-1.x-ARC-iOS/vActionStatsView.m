//
//  vActionStatsView.m
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import "vActionStatsView.h"

@interface vActionStatsView()

@property (strong, nonatomic) UILabel *statsLabel;
@property (strong, nonatomic) UILabel *statsNameLabel;

@end

@implementation vActionStatsView

@synthesize statsLabel = _statsLabel;
@synthesize statsNameLabel = _statsNameLabel;

- (UILabel *)statsLabel
{
    if (!_statsLabel) {
        _statsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_statsLabel setFont:[UIFont fontWithName:@"League Gothic" size:100]];
        [_statsLabel setTextColor:[UIColor whiteColor]];
        [_statsLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _statsLabel;
}

- (UILabel *)statsNameLabel
{
    if (!_statsNameLabel) {
        _statsNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_statsNameLabel setFont:[UIFont fontWithName:@"League Gothic" size:96/2.]];
        [_statsNameLabel setTextAlignment:NSTextAlignmentCenter];
        [_statsNameLabel setTextColor:[UIColor whiteColor]];
    }
    return _statsNameLabel;
}

@synthesize stats = _stats;
@synthesize statsName = _statsName;

- (void)setStats:(NSString *)stats
{
    _stats = stats;
    [self.statsLabel setText:_stats];
    [self.statsLabel sizeToFit];
    [self updatePositions];
}

- (void)setStatsName:(NSString *)statsName
{
    _statsName = statsName;
    [self.statsNameLabel setText:_statsName];
    [self.statsNameLabel sizeToFit];
    [self updatePositions];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.statsNameLabel];
        [self addSubview:self.statsLabel];
        //[self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

- (void)updatePositions
{
    [self.statsNameLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.statsNameLabel.frame.size.height)];
    [self.statsLabel setFrame:CGRectMake(0, self.statsNameLabel.frame.size.height, self.frame.size.width, self.frame.size.height-self.statsNameLabel.frame.size.height)];
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
