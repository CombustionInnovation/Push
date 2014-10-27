//
//  PhoneVerification.h
//  Push
//
//  Created by Daniel Nasello on 9/13/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneVerification : UIView
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *personsNumber;
@property (strong, nonatomic) IBOutlet UILabel *veriLabel;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet UIButton *resendCodeButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelVerificationButton;
@property (strong, nonatomic) IBOutlet UIButton *sendVerificationButton;

@end
