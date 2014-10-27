//
//  PUSHSignupViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/13/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneVerificationProtocol.h"
#import "UserSignedUpDelegate.h"
@protocol UserSignedUpDelegate <NSObject>
-(void)userRegistered:(NSString *)username:(NSString *)password;
@end

@interface PUSHSignupViewController : UIViewController<PhoneVerificationProtocol>{
    id<UserSignedUpDelegate>delegate;
    
}
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UITextField *signupUsername;
@property (strong, nonatomic) IBOutlet UITextField *signupPhone;
@property (strong, nonatomic) IBOutlet UITextField *signupPassword;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *signupName;

@property (strong, nonatomic) IBOutlet UITextField *signupConfirmPassword;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *signMeUpButton;
- (IBAction)cancelButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *okButtonClicked;
- (IBAction)goSignup:(id)sender;

@end
