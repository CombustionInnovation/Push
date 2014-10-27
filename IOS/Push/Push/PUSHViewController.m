//
//  PUSHViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHViewController.h"
#import "FacebookManager.h"
#import "PUSHLandingScreenViewController.h"
#import "TwitterManager.h"
#import "PUSHSetUsernameViewController.h"
#import "PUSHMainNavigationViewController.h"
#import "LoginManager.h"
#import "PUSHSignupViewController.h"
@interface PUSHViewController (){
    NSArray *inputs;
    NSArray *alertMessages;
    FacebookManager *fbManager;
    UIImageView *check;
    TwitterManager *twitterManager;
    PUSHSetUsernameViewController *setUsername;
    LoginManager *loginManager;
   
}

@end

@implementation PUSHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    check = nil;
    
    inputs = [[NSArray alloc]init];
    alertMessages =[[NSArray alloc]init];
    
    inputs = @[self.loginUsername,self.loginPassword];
    alertMessages=@[@"USERNAME",@"PASSWORD"];
    

    
    UIStoryboard *storyBoard = [self storyboard];
    setUsername = [storyBoard instantiateViewControllerWithIdentifier:@"setUsername"];
    [setUsername hideView];
    setUsername.delegate = self;
    [self.view addSubview:setUsername.view];
    [setUsername didMoveToParentViewController:self];
    
    int i = 0;
    for(UITextField *input in inputs)
    {
        
        UIColor *color = [UIColor whiteColor];
        input.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[alertMessages objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: color}];
        
        input.restorationIdentifier = [alertMessages objectAtIndex:i];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
        input.layer.cornerRadius = 4.0;
        input.tag = i;
       
        [input setBorderStyle:UITextBorderStyleNone];
        input.layer.borderWidth = 1.0;
        input.layer.borderColor = [UIColor whiteColor].CGColor;
        input.layer.masksToBounds = YES;
        [input setLeftViewMode:UITextFieldViewModeAlways];
        [input setLeftView:spacerView];
        input.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        input.delegate = self;
        input.frame = CGRectMake(input.frame.origin.x,input.frame.origin.y,input.frame.size.width,35);
        
        i++;
    }
    
    
    //login button styles
    self.loginButton.layer.cornerRadius = 4.0f;
    self.loginButton.layer.borderWidth = 1.0;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithRed:0.141 green:0.82 blue:0.2 alpha:1] /*#24d133*/ forState:UIControlStateHighlighted];
    [self.loginButton addTarget:self action:@selector(highlightBorder:) forControlEvents:UIControlEventTouchDown];
    [self.loginButton addTarget:self action:@selector(unhighlightBorder:) forControlEvents:UIControlEventTouchUpInside];
    //forgotpassword button
    self.forgotPasswordButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.forgotPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    UITapGestureRecognizer *endkeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress)];
    endkeyboard.numberOfTapsRequired = 1;
    endkeyboard.delegate = self;
    [self.view addGestureRecognizer:endkeyboard];
    
    
    //regular loginmanager
    loginManager = [[LoginManager alloc]init];
    loginManager.delegate = self;

    
    //facebook login stuff
    fbManager = [[FacebookManager alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:fbManager];
    [fbManager setHidden:YES];
    fbManager.delegate = self;

    
    twitterManager = [[TwitterManager alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    twitterManager.delegate = self;
    [self.view addSubview:twitterManager];
    
    
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
        
    }
    
    [self checkLogins];
    
    

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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    
    if([touch.view isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
    return NO;
}


- (IBAction)fbButtonClicked:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [fbManager loginTry];
}

- (IBAction)twitterButtonClicked:(id)sender {
       MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       [twitterManager loginToTwitter];
}

- (IBAction)signupButtonPressed:(id)sender {
    //-(void)userRegistered:(NSString *)username:(NSString *)password;
    UIStoryboard *storyBoard = [self storyboard];
    PUSHSignupViewController *ls= [storyBoard instantiateViewControllerWithIdentifier:@"signupcontroller"];
    ls.delegate = self;
    [self presentViewController:ls animated:YES completion:nil];
}


//facebook manager delegate methods
-(void)userLoggedinFacebook
{
  //  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     [fbManager signInFB];
    check = [[UIImageView alloc]initWithFrame:CGRectMake(self.facebookHolder.frame.size.width/4, self.facebookHolder.frame.size.height/4, self.facebookHolder.frame.size.width/2, self.facebookHolder.frame.size.height/2)];
    check.image = [UIImage imageNamed:@"checkmark"];
    [self.facebookHolder addSubview:check];
    [self disableSocialButtons];
    fbManager.hasFired = NO;
}

-(void)updatedLogin
{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self goToLogin];
        fbManager.hasFired = NO;
}
-(void)firstTimeLogin
{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       // [self goToLogin];
        fbManager.hasFired = NO;
    [self showUsernameverification];
}

-(void)facebookLoginError
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showAlert:@"There was an Error Logging in With Facebook"];
    [self logoutOperationsLP];
}
///end fb delegate
//twitter delegate methods
-(void)firstTimeLoginTwitter
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
   // [self goToLogin];
    [self showUsernameverification];
}

-(void)updatedLoginTwitter
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self goToLogin];
}
-(void)failLoginTwitter
{
    [self showAlert:@"Please enter your Twitter Credentials in iPhone Settings"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self logoutOperationsLP];

}
-(void)userMustEnterCredentials
{
    [self showAlert:@"Please enter your Twitter Credentials in iPhone Settings"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];


}
-(void)userWillLoginWithTwitter
{
    check = [[UIImageView alloc]initWithFrame:CGRectMake(self.facebookHolder.frame.size.width/4, self.facebookHolder.frame.size.height/4, self.facebookHolder.frame.size.width/2, self.facebookHolder.frame.size.height/2)];
    check.image = [UIImage imageNamed:@"checkmark"];
    [self.twitterHolder addSubview:check];
    [self disableSocialButtons];

}


//end twitter delegate


-(void)disableSocialButtons
{
    [self.facebookButton setEnabled:NO];
    [self.twitterButton setEnabled:NO];
    [self.loginUsername setEnabled:NO];
    [self.loginPassword setEnabled:NO];
}
-(void)enableSocialButtons
{
    [self.facebookButton setEnabled:YES];
    [self.twitterButton setEnabled:YES];
    [self.loginUsername setEnabled:YES];
    [self.loginPassword setEnabled:YES];
}



-(void)goToLogin
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIStoryboard *storyBoard = [self storyboard];
    PUSHMainNavigationViewController *ls= [storyBoard instantiateViewControllerWithIdentifier:@"mainNav"];
    ls.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    PUSHLandingScreenViewController *l =[ls.childViewControllers objectAtIndex:0];
    l.delegate = self;
    [self presentViewController:ls animated:YES completion:nil];
    if(fbManager)
    {
       [fbManager removeFromSuperview];
       fbManager = nil;
    }
  
}

//landing screen delegate


-(void)logoutOperationsLP
{
     [self enableSocialButtons];
     [fbManager logoutOfFacebook];
     fbManager.isLogged = NO;
     twitterManager.isL = NO;
    if(check)
    {
        [check removeFromSuperview];
        check = nil;
       
    }
    
    if(!fbManager)
    {
        
       fbManager = [[FacebookManager alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [fbManager logoutOfFacebook];
        fbManager.isLogged = NO;
       [self.view addSubview:fbManager];
       [fbManager setHidden:YES];
        fbManager.delegate = self;
    }
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
//end landing screen deleagte




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



-(void)checkLogins
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lt = [defaults objectForKey:@"logintype"];
    if([lt isEqualToString:@"Facebook"]||[lt isEqualToString:@"facebook"])
    {
     // [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    else if([lt isEqualToString:@"Twitter"]||[lt isEqualToString:@"twitter"])
    {
        [twitterManager loginToTwitter];
             NSLog(@"DDDDDDD thte fucccc");
    }
    else if([lt isEqualToString:@"PUSH"])
    {
        NSString *username = [defaults objectForKey:@"username"];
        NSString *password = [defaults objectForKey:@"password"];
        [self loginWithPush:username:password];
        NSLog(@"DDDDDDD thte fucccc");
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
          NSLog(@"DDDDDDD thte fucccc");
    }
    
    
}

//social login manager delegate
-(void)PushLoginError
{
    [self showAlert:@"Username/Password Incorrect"];
     [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self logoutOperationsLP];
}

-(void)PushUpdatedLogin
{
       [MBProgressHUD hideHUDForView:self.view animated:YES];
       [self goToLogin];
}

//end login manager delegate


///set username delegate

-(void)usernameWasSet
{
    [setUsername hideView];
    [self goToLogin];
}
-(void)userNameWasCanceled
{
    [self logoutOperationsLP];
    [setUsername hideView];
}
//end set username delegate






-(void)showUsernameverification
{
    [setUsername showVerificationAlert];
}
- (IBAction)lbPressed:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *password = self.loginPassword.text;
    NSString *username = self.loginUsername.text;
    [self loginWithPush:username:password];
    
}

-(void)loginWithPush:(NSString *)username:(NSString *)password
{
    [loginManager login:username:password];

}



//sign up delegatge
-(void)userRegistered:(NSString *)username:(NSString *)password
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     [self loginWithPush:username:password];
}


@end
