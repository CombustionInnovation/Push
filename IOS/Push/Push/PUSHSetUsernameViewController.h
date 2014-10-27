//
//  PUSHSetUsernameViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/16/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetUserNameProtocol.h"
#import "VerificationLabel.h"


@protocol SetUserNameProtocol <NSObject>
-(void)usernameWasSet;
-(void)userNameWasCanceled;
@end

@interface PUSHSetUsernameViewController : UIViewController{
    id<SetUserNameProtocol>delegate;
}
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UITextField *myUsername;
@property (strong, nonatomic) IBOutlet UIButton *cancelUsername;
@property (strong, nonatomic) IBOutlet UIButton *verifyUsername;
@property (strong, nonatomic) IBOutlet UIView *containerView;
- (IBAction)cancelUsernameCreate:(id)sender;
- (IBAction)addUsernameToAccount:(id)sender;
-(void)showVerificationAlert;
-(void)hideView;
@property (strong, nonatomic) IBOutlet VerificationLabel *verificationLabel;

@end
