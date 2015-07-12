//
//  Virus.m
//  Virus Final
//
//  Created by Kelvin Wong on 1/18/2014.
//
//

#import "Virus.h"
#import "Constants.h"
#include <math.h>

#define BASE_URL @"http://thawing-thicket-8683.herokuapp.com/"



@implementation Virus

@synthesize pointsForEnergyUpgrade = _pointsForEnergyUpgrade;
@synthesize pointsForLongevityUpgrade = _pointsForLongevityUpgrade;

- (int)pointsForEnergyUpgrade
{
    _pointsForEnergyUpgrade = pow(2.0, ((double)self.maxEnergy/9.0))*100;
    return _pointsForEnergyUpgrade;
}

- (int)pointsForLongevityUpgrade
{
    _pointsForLongevityUpgrade = pow(2.0, (double)self.longevity)*100;
    return _pointsForLongevityUpgrade;
}

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        NSData *json = [NSJSONSerialization dataWithJSONObject:attributes options:kNilOptions error:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@virus", BASE_URL]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        request.HTTPBody = json;
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if ([data length] && !error) {
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                       NSLog(@"json sent %@", json);
                                       if ([json objectForKey:@"success"]) {
                                           NSDictionary *virusJson = [json objectForKey:@"virus"];
                                           [self updateVirusWithInformation:virusJson];
                                           [self updateVirusWithAttributes:[virusJson objectForKey:@"appearance"]];
                                           self.isPersonal = YES;
                                           [self saveVirusToUserDefaults];
                                           [self.delegate virus:self didCompleteDownloadWithSuccess:YES];
                                       } else {
                                           [self.delegate virus:self didCompleteDownloadWithSuccess:NO];
                                       }
                                   } else {
                                       [self.delegate virus:self didCompleteDownloadWithSuccess:NO];
                                   }}];
    }
    return self;
}

- (id)initWithVirusID:(int)virusID
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@virus/%i", BASE_URL, virusID]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        request.HTTPMethod = @"GET";
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if ([data length] && !error) {
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                       if ([json objectForKey:@"success"]) {
                                           NSDictionary *virusJson = [json objectForKey:@"virus"];
                                           [self updateVirusWithInformation:virusJson];

                                           [self updateVirusWithAttributes:[virusJson objectForKey:@"appearance"]];
                                           [self.delegate virus:self didCompleteDownloadWithSuccess:YES];
                                       } else {
                                           [self.delegate virus:self didCompleteDownloadWithSuccess:NO];
                                       }
                                   } else {
                                       [self.delegate virus:self didCompleteDownloadWithSuccess:NO];
                                   }}];
        

    }
    return self;
}

- (id)initFromUserDefaults
{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.name = [defaults objectForKey:@"name"];
        self.virusID = [[defaults objectForKey:@"virusID"]intValue];
        self.maxEnergy = [[defaults objectForKey:@"maxEnergy"]intValue];
        self.longevity = [[defaults objectForKey:@"longevity"]intValue];
        self.infections = [[defaults objectForKey:@"infections"]intValue];
        self.transmissions = [[defaults objectForKey:@"transmissions"]intValue];
        self.rank = [[defaults objectForKey:@"rank"] intValue];
        self.points = [[defaults objectForKey:@"points"] intValue];
        self.attributes = [defaults objectForKey:@"attributes"];
        self.isPersonal = 1;
        [self updateVirusFromServer];
    }
    
    return self;
}

- (void)updateVirusWithInformation:(NSDictionary *)information
{
    self.virusID = [[information objectForKey:@"id"]intValue];
    self.name = [information objectForKey:@"name"];
    self.maxEnergy = [[information objectForKey:@"max_energy"]intValue];
    self.longevity = [[information objectForKey:@"longevity"]intValue];
    self.infections = [[information objectForKey:@"infected_by_count"]intValue];
    self.transmissions = [[information objectForKey:@"infected_count"]intValue];
    self.rank = [[information objectForKey:@"rank"]intValue];
    self.points = [[information objectForKey:@"points"]intValue];
}

- (void)updateVirusWithAttributes:(NSDictionary *)attributes
{
    self.attributes = [attributes mutableCopy];
    NSLog(@"id %d", self.virusID);
    NSLog(@"before %@", attributes);
    /*
    NSArray *colorSplit = [[self.attributes objectForKey:@"start_color"] componentsSeparatedByString:@","];
    [self.attributes setValue:[UIColor colorWithRed:[[colorSplit objectAtIndex:0] floatValue] green:[[colorSplit objectAtIndex:1] floatValue] blue:[[colorSplit objectAtIndex:2] floatValue] alpha:1.] forKey:@"start_color"];
    colorSplit = [[self.attributes objectForKey:@"start_color_variance"] componentsSeparatedByString:@","];
    [self.attributes setValue:[UIColor colorWithRed:[[colorSplit objectAtIndex:0] floatValue] green:[[colorSplit objectAtIndex:1] floatValue] blue:[[colorSplit objectAtIndex:2] floatValue] alpha:1.] forKey:@"start_color_variance"];
    colorSplit = [[self.attributes objectForKey:@"end_color"] componentsSeparatedByString:@","];
    [self.attributes setValue:[UIColor colorWithRed:[[colorSplit objectAtIndex:0] floatValue] green:[[colorSplit objectAtIndex:1] floatValue] blue:[[colorSplit objectAtIndex:2] floatValue] alpha:1.] forKey:@"end_color"];
    colorSplit = [[self.attributes objectForKey:@"end_color_variance"] componentsSeparatedByString:@","];
    [self.attributes setValue:[UIColor colorWithRed:[[colorSplit objectAtIndex:0] floatValue] green:[[colorSplit objectAtIndex:1] floatValue] blue:[[colorSplit objectAtIndex:2] floatValue] alpha:1.] forKey:@"end_color_variance"];
     */
}

- (void)saveVirusToUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.name forKey:@"name"];
    [defaults setObject:[NSNumber numberWithInt:self.virusID] forKey:@"virusID"];
    [defaults setObject:[NSNumber numberWithInt:self.maxEnergy] forKey:@"maxEnergy"];
    [defaults setObject:[NSNumber numberWithInt:self.longevity] forKey:@"longevity"];
    [defaults setObject:[NSNumber numberWithInt:self.infections] forKey:@"infections"];
    [defaults setObject:[NSNumber numberWithInt:self.transmissions] forKey:@"transmissions"];
    [defaults setObject:[NSNumber numberWithInt:self.rank] forKey:@"rank"];
    [defaults setObject:[NSNumber numberWithInt:self.points] forKey:@"points"];
    [defaults setObject:self.attributes forKey:@"attributes"];
    [defaults synchronize];
}

- (void)updateVirusFromServer
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@virus/%i", BASE_URL, self.virusID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ([data length] && !error) {
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                   if ([json objectForKey:@"success"]) {
                                       NSDictionary *virusJson = [json objectForKey:@"virus"];
                                       [self updateVirusWithInformation:virusJson];
                                   }
                               }}];

}

- (void)upgradeEnergy:(int)energy andLongevity:(int)longevity withPointsRequired:(int)pointsRequired
{
    NSLog(@"Upgrade energy pressed %d", pointsRequired);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@virus/%d?points_required=%d&max_energy=%d&longevity=%d", BASE_URL, self.virusID, pointsRequired,energy, longevity]];
    NSLog(@"URL = %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"PUT";
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ([data length] && !error) {
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                   if ([json objectForKey:@"success"]) {
                                       NSDictionary *virusJson = [json objectForKey:@"virus"];
                                       [self updateVirusWithInformation:virusJson];
                                       [self.delegate virus:self didUpgradeWithSuccess:YES];
                                   } else {
                                       [self.delegate virus:self didUpgradeWithSuccess:NO];
                                   }
                               } else {
                                   [self.delegate virus:self didUpgradeWithSuccess:NO];
                               }}];
}

- (void)infectEnemyWithID:(int)enemyID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@infection?infector_id=%d&infected_id=%d", BASE_URL, self.virusID, enemyID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"POST";
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ([data length] && !error) {
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                   if ([json objectForKey:@"success"]) {
                                       NSDictionary *virusJson = [json objectForKey:@"virus"];
                                       [self updateVirusWithInformation:virusJson];
                                   } else {
                                   }
                               } else {
                               }}];
}

- (void)healEnemyWithID:(int)enemyID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@heal?healer_id=%d&healed_id=%d", BASE_URL, self.virusID, enemyID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"POST";
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ([data length] && !error) {
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                   if ([json objectForKey:@"success"]) {
                                       NSDictionary *virusJson = [json objectForKey:@"virus"];
                                       [self updateVirusWithInformation:virusJson];
                                   } else {
                                   }
                               } else {
                               }}];
}


@end
