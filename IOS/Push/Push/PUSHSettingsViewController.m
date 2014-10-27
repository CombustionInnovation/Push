//
//  PUSHSettingsViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//
#import <MessageUI/MFMailComposeViewController.h>
#import "PUSHSettingsViewController.h"
#import "PUSHChangePasswordViewController.h"
#import "PUSHChangePhoneViewController.h"

#import "MBProgressHud.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "PUSHChangePhoneViewController.h"
@interface PUSHSettingsViewController (){
    NSArray *imageButtons;
}

@end

@implementation PUSHSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageButtons=[[NSArray alloc]init];
    imageButtons = @[self.rateButton,self.aboutButton,self.contactButton,self.otherappsButton,self.changePhoneButton,self.changePasswordButton];
    [self checkLoginTypes];
    
    for(UIButton *button in imageButtons)
    {
         button.imageEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width, 0, -175);

    }
    
    
    [self.facebookSyncButton initClass];
    self.facebookSyncButton.delegate = self;
    
    [self.twitterButton initClass];
    self.twitterButton.delegate = self;
    
    [self.phoneBookButton initClass];
    self.phoneBookButton.delegate = self;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *push_notification = [defaults objectForKey:@"push_notification"];
    NSString *private = [defaults objectForKey:@"private"];
    
    
    [self.pushSwitch setOn:[push_notification boolValue]];
    [self.pushSwitch addTarget:self
                        action:@selector(pushSwitchChanged)
              forControlEvents:UIControlEventValueChanged];
    
    
    [self.myUsername setTextColor:[UIColor whiteColor]];
    [self.myUsername setText:username];
    
  
    
    NSArray *regbuttons = [[NSArray alloc]init];
    regbuttons = @[self.submitChangeUserName,self.logoutButton];
    for(UIButton *b in regbuttons)
    {
        b.layer.cornerRadius = 4.0;
        b.layer.borderWidth = 1.0;
        b.layer.borderColor = [UIColor whiteColor].CGColor;
        b.layer.masksToBounds = YES;
        [b addTarget:self action:@selector(highlightBorder:) forControlEvents:UIControlEventTouchDown];
        [b addTarget:self action:@selector(unhighlightBorder:) forControlEvents:UIControlEventTouchUpInside];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor colorWithRed:0.141 green:0.82 blue:0.2 alpha:1] /*#24d133*/ forState:UIControlStateHighlighted];
        
    }
    
    
    
    
    
    
    
    UITextField *input = self.myUsername;
    
    UIColor *color = [UIColor whiteColor];
    input.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"USERNAME" attributes:@{NSForegroundColorAttributeName: color}];
    

    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    input.layer.cornerRadius = 4.0;

    
    [input setBorderStyle:UITextBorderStyleNone];
    input.layer.borderWidth = 1.0;
    input.layer.borderColor = [UIColor whiteColor].CGColor;
    input.layer.masksToBounds = YES;
    [input setLeftViewMode:UITextFieldViewModeAlways];
    [input setLeftView:spacerView];
    input.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    input.delegate = self;
    input.frame = CGRectMake(input.frame.origin.x,input.frame.origin.y,input.frame.size.width,35);
    
    
    
    UITapGestureRecognizer *endkeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress)];
    endkeyboard.numberOfTapsRequired = 1;
    endkeyboard.delegate = self;
    [self.view addGestureRecognizer:endkeyboard];
    
}


- (void)highlightBorder:(id)sender
{
    UIButton *button = (UIButton*)sender;
    [button.layer setBorderColor: [UIColor colorWithRed:0.141 green:0.82 blue:0.2 alpha:1].CGColor];
}

- (void)unhighlightBorder:(id)sender
{
        UIButton *button = (UIButton*)sender;
        button.layer.borderColor = [[UIColor whiteColor]CGColor];
    //additional code for an action when the button is released can go here.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didLongPress
{
    [self.view endEditing:YES];
}


- (IBAction)xPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submitChangeUsernamePressed:(id)sender
{
    [self changeUserName:self.myUsername.text];
}

- (IBAction)logoutPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Loug Out?" message:@"Are You Sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate userDidLogOut];
        }];
    }
}


- (IBAction)rateButtonPressed:(id)sender {
 
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/push-press-until-something/id913315888?ls=1&mt=8"]];
}
- (IBAction)contactPressed:(id)sender {
}

- (IBAction)aboutPressed:(id)sender {
}

- (IBAction)contactButtonPressed:(id)sender {
    NSArray *to = [[NSArray alloc]init];
    to = @[@"contact@pushlonger.com"];
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:to];
    [controller setSubject:@"Hey Pinstant!"];
    [controller setMessageBody:@"Dear Pinstant, " isHTML:NO];
    if (controller) [self presentModalViewController:controller animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)otherAppsPressed:(id)sender {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/combustioninnovation"]];
}

- (IBAction)changePhoneNUmberPressed:(id)sender{
    
    UIStoryboard *storyBoard = [self storyboard];
    PUSHChangePhoneViewController *cp= [storyBoard instantiateViewControllerWithIdentifier:@"changephone"];
       [self presentViewController:cp animated:YES completion:nil];

    
}

- (IBAction)changePasswordPressed:(id)sender {
    UIStoryboard *storyBoard = [self storyboard];
    PUSHChangePasswordViewController *cp= [storyBoard instantiateViewControllerWithIdentifier:@"changepassword"];
    [cp.view setClipsToBounds:YES];
    [self presentViewController:cp animated:YES completion:nil];
    // [profile.view setFrame:self.profileTopHolder.frame];

}

-(void)checkLoginTypes
{
   // [self.twitterButton setEnabled:NO];
    [self.facebookButton setEnabled:NO];
    
    UIImageView *check = [[UIImageView alloc]initWithFrame:CGRectMake(self.facebookButtonHolder.frame.size.width/4, self.facebookButtonHolder.frame.size.height/4, self.facebookButtonHolder.frame.size.width/2, self.facebookButtonHolder.frame.size.height/2)];
    check.image = [UIImage imageNamed:@"checkmark"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lt = [defaults objectForKey:@"logintype"];
    if([lt isEqualToString:@"Facebook"]||[lt isEqualToString:@"facebook"])
    {
      
        [self.facebookButtonHolder addSubview:check];
        [self.changePasswordButton setEnabled:NO];

        
    }
    else if([lt isEqualToString:@"Twitter"]||[lt isEqualToString:@"Twitter"])
    {
        [self.twitterButtonHolder addSubview:check];
        [self.changePasswordButton setEnabled:NO];
 
    }
}




-(void)toastMessage:(NSString *)message
{
    MBProgressHUD *huds = [MBProgressHUD showHUDAddedTo:self.backGround animated:YES];
    huds.color =[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1];
	// Configure for text only and offset down
	huds.mode = MBProgressHUDModeText;
	huds.labelText = message;
	huds.margin = 10.f;
	huds.yOffset = 200.f;
	huds.removeFromSuperViewOnHide = YES;
    
	[huds hide:YES afterDelay:3];
}





-(void)changeUserName:(NSString *)username
{

    
    int len = username.length;
    if(len> 14 || len < 6)
    {
           [self showAlert:@"Username must be between 6 and 14 characters!"];
    }
    else
    {
        [self didLongPress];
        MBProgressHUD *hud =    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *user_id = [defaults objectForKey:@"user_id"];

    
        NSDictionary *params = @{
                             @"user_id":[NSString stringWithFormat:@"%@",user_id],
                             @"username":[NSString stringWithFormat:@"%@",username],
                             
                             };
    
    
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://combustionlaboratory.com/push/php/updateUsername.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        
            NSString *status = responseObject[@"status"];
            NSString *myrank = responseObject[@"rank"];
            if ([status isEqualToString:@"one"])
            {
                [self toastMessage:@"Username Changed!"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.myUsername.text forKey:@"username"];
                [defaults synchronize];
            }
            else
            {
                [self showAlert:@"Username not Available"];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }

}

//my user name
- (IBAction)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.myUsername)
    {
        [self didLongPress];
        [self changeUserName:textField.text];
    }
}

-(void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"PUSH"
                          message: message
                          delegate: nil
                          cancelButtonTitle: @"Okay"
                          otherButtonTitles:nil];
    [alert show];
}


-(void)pushSwitchChanged
{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    
    int pushon = [[NSNumber numberWithBool:self.pushSwitch.isOn]intValue];
    [defaults setObject:[NSString stringWithFormat:@"%d",pushon] forKey:@"push_notification"];
      [defaults synchronize];
    
    
    NSDictionary *params = @{
                             @"push_notification": [NSString stringWithFormat:@"%d",pushon],
                             @"private": [NSString stringWithFormat:@"%d",pushon],
                             @"user_id":user_id,
                             };
    

    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/push/php/settings.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    

}


//twitter sync button delegate



-(void)userMustEnterTwitterCredentials
{
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showAlert:@"Please login to Twitter in iPhone Settings"];

}
-(void)twitterSyncingWillBegin
{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)twitterSyncSuccess
{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showAlert:@"Twitter Friends Synced!"];
}
-(void)twitterSyncFail
{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showAlert:@"Something weird happened..."];
}
//end twitter sync button =delegate


//sync phonebook button delegate

-(void)willStartPhoneProcess
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}
-(void)userDeniedPhonebookPermissions
{
             [self showAlert:@"Please allow PUSH to access your contacts in your settings!"];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)numberSyncFail
{
             [self showAlert:@"Something went wrong.."];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)didSendNumbers
{
                [self showAlert:@"Phonebook friends synced!"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
}



//end sync phonebook button delegate
//facebook sync button delegate/

-(void)fbLoginWillStart
{
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)facebookSyncFail
{
    [self showAlert:@"Error syncing Facebook Friends!"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
-(void)facebookLoginErr
{
    [self showAlert:@"Error Logging into Facebook"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
-(void)facebookSyncSuccesss
{
    [self showAlert:@"Facebook friends synced!"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
-(void)facebookLoginErrSilent
{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//end facebook sync button delegate



@end
