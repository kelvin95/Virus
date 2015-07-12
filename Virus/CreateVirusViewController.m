//
//  CreateVirusViewController.m
//  Virus Final
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import "CreateVirusViewController.h"
#import "cocos2d.h"
#import "CreateVirusLayer.h"
#import "VirusParticleSystem.h"
#import "Virus.h"
#import "MainViewController.h"
#import "StatsManager.h"


@interface CreateVirusViewController ()

@end

@implementation CreateVirusViewController

@synthesize finishButton = _finishButton;
@synthesize virusNewButton = _virusNewButton;
@synthesize virusNameTextField = _virusNameTextField;
@synthesize createVirusLayer = _createVirusLayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    
    EAGLView *glview = [EAGLView viewWithFrame:CGRectMake(0, 25, 320, 455)];
    [[StatsManager sharedManager] setGlView:glview];
    [self.view addSubview:glview];
    CCDirector *director = [CCDirector sharedDirector];
    [director setOpenGLView:glview];

    // 'layer' is an autorelease object.
    self.createVirusLayer = [CreateVirusLayer node];
    [self.createVirusLayer.virusParticle setNoNameLabel];
    CCScene *scene = [CreateVirusLayer scene];
	// add layer as a child to scene
	[scene addChild: self.createVirusLayer];
    
    
    [director runWithScene:scene];
    
    self.virusNewButton = [[UIButton alloc] initWithFrame:CGRectMake(150, winSize.height-61-10, 150, 61)];
    [self.virusNewButton setCenter:CGPointMake(80, self.virusNewButton.center.y)];
    [self.virusNewButton setImage:[UIImage imageNamed:@"new_virus_button"] forState:UIControlStateNormal];
    [self.virusNewButton addTarget:self action:@selector(refreshVirus) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.virusNewButton];
    
    self.finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, winSize.height-61-10, 150, 61)];
    [self.finishButton setCenter:CGPointMake(240, self.finishButton.center.y)];
    [self.finishButton setImage:[UIImage imageNamed:@"finish_button"] forState:UIControlStateNormal];
    [self.finishButton addTarget:self action:@selector(finishVirus) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.finishButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, winSize.width, 36)];
    [label setText:@"NAME YOUR FANATASY VIRUS:"];
    [label setFont:[UIFont fontWithName:@"League Gothic" size:30]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [self.view addSubview:label];
    
    
    self.virusNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, winSize.width-50, 36)];
    [self.virusNameTextField setCenter:CGPointMake(winSize.width/2., 100)];
    [self.virusNameTextField setPlaceholder:@"VIRUS NAME"];
    [self.virusNameTextField setTextAlignment:NSTextAlignmentCenter];
    [self.virusNameTextField setDelegate:self];
    [self.virusNameTextField setTextColor:[UIColor lightGrayColor]];
    [self.virusNameTextField setBackgroundColor:[UIColor clearColor]];
    [self.virusNameTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"VIRUS NAME" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}]];
    [self.virusNameTextField setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [self.virusNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.virusNameTextField setFont:[UIFont fontWithName:@"League Gothic" size:38]];
    [self.view addSubview:self.virusNameTextField];
}

- (void)refreshVirus {
    [self.createVirusLayer.virusParticle randomizeVirus];
}

- (void)finishVirus {
    VirusParticleSystem *vps = self.createVirusLayer.virusParticle;
    
    NSString *startColor = [NSString stringWithFormat:@"%f,%f,%f", vps.startColor.r, vps.startColor.g, vps.startColor.b];
    NSString *startColorVar = [NSString stringWithFormat:@"%f,%f,%f", vps.startColorVar.r, vps.startColorVar.g, vps.startColorVar.b];
    NSString *endColor = [NSString stringWithFormat:@"%f,%f,%f", vps.endColor.r, vps.endColor.g, vps.endColor.b];
    NSString *endColorVar = [NSString stringWithFormat:@"%f,%f,%f", vps.endColorVar.r, vps.endColorVar.g, vps.endColorVar.b];
    
    
    NSArray *objs = [[NSArray alloc] initWithObjects: [NSNumber numberWithFloat:vps.startRadius/vps.virusScale],
                     [NSNumber numberWithFloat:vps.rotatePerSecond/vps.virusScale],
                     [NSNumber numberWithFloat:vps.rotatePerSecondVar/vps.virusScale],
                     [NSNumber numberWithFloat:vps.startSize/vps.virusScale],
                     [NSNumber numberWithFloat:vps.startSizeVar/vps.virusScale],
                     [NSNumber numberWithFloat:vps.endSize/vps.virusScale],
                     [NSNumber numberWithFloat:vps.endSizeVar/vps.virusScale],
                     [NSNumber numberWithFloat:vps.life/vps.virusScale],
                     [NSNumber numberWithFloat:vps.lifeVar/vps.virusScale],
                     startColor,
                     startColorVar,
                     endColor,
                     endColorVar,
                     self.virusNameTextField.text,
                     nil];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjects:objs
                                                             forKeys:@[@"radius", @"speed", @"speed_variance", @"start_size", @"start_size_variance", @"finish_size", @"finish_size_variance", @"lifespan", @"lifespan_variance", @"start_color", @"start_color_variance", @"end_color", @"end_color_variance", @"name"]];
    NSLog(@"Finished virus %@", attributes);
    Virus *newVirus = [[Virus alloc] initWithAttributes:attributes];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:9] forKey:@"personalVirusEnergy"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[StatsManager sharedManager]setPersonalVirus:newVirus];
    [newVirus setDelegate:self];
    
    
}

#pragma mark - Virus delegate 
- (void)virus:(Virus *)virus didCompleteDownloadWithSuccess:(BOOL)success {
    if (success) {
        [[StatsManager sharedManager] setPersonalVirus:virus];
        [self presentViewController:[[MainViewController alloc] init] animated:NO completion:nil];
    }
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
