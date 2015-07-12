//
//  vActionStatsView.h
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import <UIKit/UIKit.h>

@interface vActionStatsView : UIView

@property (strong, nonatomic) NSString *stats;
@property (strong, nonatomic) NSString *statsName;


- (void)updatePositions;

@end
