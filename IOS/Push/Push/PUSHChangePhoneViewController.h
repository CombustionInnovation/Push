//
//  PUSHChangePhoneViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/15/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PUSHChangePhoneViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *myPhoneLabnel;
@property (strong, nonatomic) IBOutlet UIView *myPhoneLabel;
@property (strong, nonatomic) IBOutlet UITextField *myPhoneNumber;
- (IBAction)cancelChangePhone:(id)sender;
- (IBAction)okButtonPressed:(id)sender;

@end
