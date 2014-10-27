//
//  PUSHSettingsViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsDelegate.h"
#import "TwitterSyncButton.h"
#import "SyncPhoneBookButton.h"
#import "FacebookSyncButton.h"
@protocol SettingsDelegate <NSObject>
-(void)userDidLogOut;
@end

@interface PUSHSettingsViewController : UIViewController{
    id<SettingsDelegate>delegate;
   
}
@property (strong, nonatomic) IBOutlet UIView *backGround;
@property (strong, nonatomic) IBOutlet UISwitch *pushSwitch;

@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UIButton *goodByeButton;
@property (strong, nonatomic) IBOutlet UIView *facebookButtonHolder;
@property (strong, nonatomic) IBOutlet UIView *twitterButtonHolder;
- (IBAction)xPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *submitChangeUserName;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)submitChangeUsernamePressed:(id)sender;
- (IBAction)logoutPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *myUsername;
- (IBAction)rateButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *aboutButtonPressed;
- (IBAction)contactPressed:(id)sender;
- (IBAction)aboutPressed:(id)sender;
- (IBAction)contactButtonPressed:(id)sender;
- (IBAction)otherAppsPressed:(id)sender;
- (IBAction)changePhoneNUmberPressed:(id)sender;
- (IBAction)changePasswordPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *rateButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;
@property (strong, nonatomic) IBOutlet UIButton *contactButton;
@property (strong, nonatomic) IBOutlet UIButton *otherappsButton;
@property (strong, nonatomic) IBOutlet UIButton *changePhoneButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet TwitterSyncButton *twitterButton;
@property (strong, nonatomic) IBOutlet FacebookSyncButton *facebookSyncButton;

@property (strong, nonatomic) IBOutlet SyncPhoneBookButton *phoneBookButton;

@property (strong, nonatomic) IBOutlet UIButton *changePasswordButton;
@end
