//
//  PUSHViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InGameOpponents.h"
#import "MBProgressHUD.h"
@interface PUSHViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *loginUsername;
@property (strong, nonatomic) IBOutlet UITextField *loginPassword;
@property (strong, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *facebookHolder;
@property (strong, nonatomic) IBOutlet UIView *twitterHolder;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
- (IBAction)lbPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *signupButton;
- (IBAction)fbButtonClicked:(id)sender;
- (IBAction)twitterButtonClicked:(id)sender;

- (IBAction)signupButtonPressed:(id)sender;
@end
