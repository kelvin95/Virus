//
//  vUpgradeButton.m
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import "vUpgradeButton.h"

@interface vUpgradeButton()

@property (strong, nonatomic) UILabel *upgradeStringLabel;
@property (strong, nonatomic) UILabel *statStringLabel;

@property (strong, nonatomic) UIView *highlightView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation vUpgradeButton

@synthesize upgradeStringLabel = _upgradeStringLabel;
@synthesize statStringLabel = _statStringLabel;
@synthesize highlightView = _highlightView;
@synthesize activityIndicator = _activityIndicator;

- (UILabel *)upgradeStringLabel
{
    if (!_upgradeStringLabel) {
        _upgradeStringLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_upgradeStringLabel setFont:[UIFont fontWithName:@"League Gothic" size:14.]];
        [_upgradeStringLabel setTextAlignment:NSTextAlignmentCenter];
        [_upgradeStringLabel setTextColor:[UIColor whiteColor]];
    }
    return _upgradeStringLabel;
}

- (UILabel *)statStringLabel
{
    if (!_statStringLabel) {
        _statStringLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_statStringLabel setFont:[UIFont fontWithName:@"League Gothic" size:30]];
        [_statStringLabel setTextAlignment:NSTextAlignmentCenter];
        [_statStringLabel setTextColor:[UIColor whiteColor]];
    }
    return _statStringLabel;
}

- (UIView *)highlightView
{
    if (!_highlightView) {
        _highlightView = [[UIView alloc]initWithFrame:self.bounds];
        [_highlightView setBackgroundColor:[UIColor blackColor]];
        [_highlightView setAlpha:0.5];
        [_highlightView setHidden:YES];
    }
    return _highlightView;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setFrame:CGRectMake(0, 0, 20, 20)];
        [_activityIndicator setCenter:self.center];
        [_activityIndicator stopAnimating];
    }
    return _activityIndicator;
}

@synthesize upgradeString = _upgradeString;
@synthesize statString = _statString;

- (void)setUpgradeString:(NSString *)upgradeString
{
    _upgradeString = upgradeString;
    [self.upgradeStringLabel setText:upgradeString];
    [self.upgradeStringLabel sizeToFit];
}

- (void)setStatString:(NSString *)statString
{
    _statString = statString;
    [self.statStringLabel setText:statString];
    [self.statStringLabel sizeToFit];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:144/255. green:19/255. blue:254/255. alpha:1];
        [self addSubview:self.statStringLabel];
        [self addSubview:self.upgradeStringLabel];
        [self insertSubview:self.highlightView aboveSubview:self.upgradeStringLabel];
    }
    return self;
}

- (void)updatePositions
{
    [self.statStringLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.statStringLabel.frame.size.height)];
    [self.upgradeStringLabel setFrame:CGRectMake(0, self.statStringLabel.frame.size.height-10, self.frame.size.width, self.frame.size.height - self.statStringLabel.frame.size.height+10)];
}

- (void)disableButtonForUpgrade:(BOOL)disable
{
    if (disable) {
        [self setUserInteractionEnabled:NO];
        [self.highlightView setHidden:NO];
        [self.activityIndicator startAnimating];
    } else {
        [self setUserInteractionEnabled:YES];
        [self.highlightView setHidden:YES];
        [self.activityIndicator stopAnimating];
    }
}

- (void)setHighlighted:(BOOL)highlight {
    if (highlight != self.highlighted) [self.highlightView setHidden:(highlight ? NO : YES)];
    [super setHighlighted:highlight];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [self setHighlighted:(userInteractionEnabled ? NO : YES)];
    [super setUserInteractionEnabled:userInteractionEnabled];
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
