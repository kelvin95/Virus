//
//  CreateVirusViewController.h
//  Virus Final
//
//  Created by Ulysses Zheng on 1/18/2014.
//
//

#import <UIKit/UIKit.h>
@class CreateVirusLayer;
@protocol VirusProtocol;

@interface CreateVirusViewController : UIViewController <UITextFieldDelegate, VirusProtocol>


@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIButton *virusNewButton;
@property (nonatomic, strong) UITextField *virusNameTextField;
@property (nonatomic, strong) CreateVirusLayer *createVirusLayer;

@end
