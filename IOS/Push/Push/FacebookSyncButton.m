//
//  FacebookSyncButton.m
//  Push
//
//  Created by Daniel Nasello on 9/20/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "FacebookSyncButton.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
@implementation FacebookSyncButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initClass];
    }
    return self;
}

-(void)initClass
{
    
    [self setBackgroundImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"facebookpressed"] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"facebookchecked"] forState:UIControlStateSelected];
    
    [self addTarget:self
             action:@selector(wasClicked)
   forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)wasClicked
{
    [self loginTry];
    [self initFacebookOperations];
    
}
-(void)initFacebookOperations
{
    
    NSLog(@"DDD");
    FBLoginView  *loginView = [[FBLoginView alloc] init];
    loginView.readPermissions = @[@"public_profile", @"email",@"read_friendlists,publish_actions"];
    for (id loginObject in loginView.subviews)
    {
        if ([loginObject isKindOfClass:[UIButton class]])
        {
            self.loginButton =  loginObject;
            
            
            UIImage *loginImage = [UIImage imageNamed:@"exitsearch@2x.png"];
            self.loginButton.contentMode = UIViewContentModeScaleAspectFit;
            [self.loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [self.loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [self.loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            self.loginButton.frame = CGRectMake(0, 0, 0, 0);
            self.loginButton.hidden=YES;
            
        }
        if ([loginObject isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  loginObject;
            loginLabel.text = @"";
            loginLabel.frame = CGRectMake(0, 0, 0, 0);
        }
    }
    
    
    loginView.frame = CGRectMake(5, 0, 0, 0);
    
    loginView.delegate = self;
    
    [self addSubview:loginView];
}

//facebook login stuff

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.isLogged = YES;
    //  [self.delegate isLoggedInViaFacebook];
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.isLogged = NO;
    
}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.fbid = user.id;
    
    
    self.fbusername   = user.name;
    self.userEmail = [user objectForKey:@"email"];
    self.firstName = [user objectForKey:@"first_name"];
    self.lastName  = [user objectForKey:@"last_name"];
    self.gender  = [user objectForKey:@"gender"];
    self.birthday = [user objectForKey:@"birthday"];
    self.picture =[NSString stringWithFormat:@"https://graph.facebook.com/%1$@/picture/?width=300&height=300",self.fbid];
    
    NSLog(@"The fuck");
    
    
    
    if(!self.hasFired){
        if([self checkOtherLoginTypes] == 3)
            
            //do delegate
            self.hasFired = YES;
        
          NSString *fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
          [self signInFb:fbAccessToken:self.fbid];
        
    }
    else
    {
        [self.delegate facebookLoginErrSilent];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *lt = [defaults objectForKey:@"logintype"];
        if([lt isEqualToString:@"Facebook"]||[lt isEqualToString:@"facebook"])
        {
            
        }
        else
        {
            [FBSession.activeSession closeAndClearTokenInformation];
        }
        
    }
}



-(NSInteger)checkOtherLoginTypes
{
    return 3;
}



-(void)signInFb:(NSString *)token:(NSString *)fbid
{
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    
    NSDictionary *params = @{
                             @"fb_id":[NSString stringWithFormat:@"%@",fbid],
                             @"token": token,
                             @"user_id": user_id,
                             };
    
    
    NSLog(@"fb id %@",fbid);
    NSLog(@"token %@", token);
    NSLog(@"uid %@", user_id);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/push/php/syncFacebook.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"status"];
       // [self.delegate facebookSyncSuccesss];
        
        if ([status isEqualToString:@"one"])
        {
            [self.delegate facebookSyncSuccesss];
            
        }
        else
            
        {
               NSLog(@"issue");
            [self.delegate facebookSyncFail];
          //  [self.delegate facebookSyncSuccesss];
            NSLog(@"the status is %@",status);
        }
        self.hasFired  = NO;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *lt = [defaults objectForKey:@"logintype"];
        if([lt isEqualToString:@"Facebook"]||[lt isEqualToString:@"facebook"])
        {
        }
        else
        {
            [FBSession.activeSession closeAndClearTokenInformation];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"issue");
        //      [self.delegate didLogin];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *lt = [defaults objectForKey:@"logintype"];
        if([lt isEqualToString:@"Facebook"]||[lt isEqualToString:@"facebook"])
        {
        }
        else
        {
               [FBSession.activeSession closeAndClearTokenInformation];
        }
        
            self.hasFired = NO;
        // Show the user the logged-out UI
           [self.delegate facebookSyncFail];
        NSLog(@"the status is %@",operation);
    }];
    
}

-(void)loginTry
{
    
    [self.delegate fbLoginWillStart];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lt = [defaults objectForKey:@"logintype"];
    NSString *fbAccessToken= [defaults objectForKey:@"token"];
    NSString *fbid = [defaults objectForKey:@"fb_id"];
    if([lt isEqualToString:@"Facebook"]||[lt isEqualToString:@"facebook"])
    {
        
         [self signInFb:fbAccessToken:fbid];
    }
    else
    {
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
    //    [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email",@"read_friendlists,publish_actions"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
         }];
    }
    }
}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                
            }
        }
        // Clear this token
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *lt = [defaults objectForKey:@"logintype"];
        if([lt isEqualToString:@"Facebook"]||[lt isEqualToString:@"facebook"])
        {
            
        }
        else
        {
            [FBSession.activeSession closeAndClearTokenInformation];
        }
        // Show the user the logged-out UI
         [self.delegate facebookLoginErr];
    }
}




@end
