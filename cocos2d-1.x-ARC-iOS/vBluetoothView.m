//
//  vBluetoothView.m
//  Virus Final
//
//  Created by Kelvin Wong on 1/19/2014.
//
//

#import "vBluetoothView.h"

@implementation vBluetoothView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"bluetooth.png"];
        self.backgroundColor = [UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        [imageview setImage:image];
        [self addSubview:imageview];
        self.tryAgainButton = [[UIButton alloc]initWithFrame:CGRectMake(64.5, 390, 191, 87)];
        [self.tryAgainButton setImage:[UIImage imageNamed:@"try_again_button.png"] forState:UIControlStateNormal];
        [self addSubview:self.tryAgainButton];
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
