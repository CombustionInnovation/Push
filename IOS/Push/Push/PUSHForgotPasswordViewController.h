//
//  PUSHForgotPasswordViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/18/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PUSHForgotPasswordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *cancelForgotPassword;
@property (strong, nonatomic) IBOutlet UIImageView *submitForgotPassword;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)okCLicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *userName;
@end
