//
//  vStatsView.h
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import <UIKit/UIKit.h>

@interface vStatsView : UIView

@property (strong, nonatomic) NSString *statName;
@property (strong, nonatomic) NSString *stat;

- (void)updatePositions
;

@end
