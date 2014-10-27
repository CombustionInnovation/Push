//
//  PUSHPhoneVerificationViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/13/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneVerificationProtocol.h"
@protocol PhoneVerificationProtocol <NSObject>
-(void)userDidVerify:(NSString*)username:(NSString *)password;
-(void)userCanceledVerification;
-(void)tryToVerify:(NSString *)code:(NSDictionary *)dict;
-(void)resendCodeButtonPressed:(NSDictionary *)dict;

@end


@interface PUSHPhoneVerificationViewController : UIViewController{
    id<PhoneVerificationProtocol>delegate;
}
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UIView *alertHolder;
@property (strong, nonatomic) IBOutlet UIView *topHolder;
@property (strong, nonatomic) IBOutlet UILabel *phoneToVerify;
@property (strong, nonatomic) IBOutlet UILabel *varificationLabel;
@property (strong, nonatomic) IBOutlet UITextField *codeInput;
@property (strong, nonatomic) IBOutlet UIButton *resendCodeButton;
- (IBAction)resendButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelVerification;
- (IBAction)cancelVerificationPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *okVerificationButton;
- (IBAction)okVerificationButtonPressed:(id)sender;
-(void)hideVerificationAlert;
-(void)showVerificationAlert;
-(void)codeWasWrong;
-(void)showHud;
-(void)hideHud;
-(void)codeResent;
@property(nonatomic,strong)NSDictionary *signupDictionary;
@property(nonatomic,assign)NSInteger type;
@end
