//
//  PUSHChangePasswordViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/15/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PUSHChangePasswordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *oldPassword;

@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UIButton *cancelChangePassword;
@property (strong, nonatomic) IBOutlet UIButton *goChangePassword;
- (IBAction)cancelChange:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *tnp;
- (IBAction)goChanged:(id)sender;

@end
