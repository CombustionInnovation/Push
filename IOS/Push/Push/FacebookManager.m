//
//  FacebookManager.m
//  Push
//
//  Created by Daniel Nasello on 9/16/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "FacebookManager.h"

@implementation FacebookManager

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
    
    
    
    
    
    if(!self.hasFired){
        if([self checkOtherLoginTypes] == 3)
 
            //do delegate
            [self.delegate userLoggedinFacebook];
            self.hasFired = YES;
         
            
        }
    }
    
    
    




-(NSInteger)checkOtherLoginTypes
{
    return 3;
}



-(void)signInFB
{

    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
    
    
    NSDictionary *params = @{
                             @"email":[NSString stringWithFormat:@"%@",self.userEmail],
                             @"fname":[NSString stringWithFormat:@"%@",self.firstName],
                             @"lname":[NSString stringWithFormat:@"%@",self.lastName],
                             @"gender":[NSString stringWithFormat:@"%@",self.gender],
                             @"birthday":[NSString stringWithFormat:@"%@",self.birthday],
                             @"picture":[NSString stringWithFormat:@"%@",self.picture],
                             @"fb_id":[NSString stringWithFormat:@"%@",self.fbid],
                             @"device":[NSString stringWithFormat:@"%@",@"iPhone"],
                             @"token": fbAccessToken,
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/push/php/loginuser.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"loginstatus"];
        NSString *fname = responseObject[@"fname"];
        NSString *lname = responseObject[@"lname"];
        NSString *email = responseObject[@"email"];
        NSString *pic = responseObject[@"picture"];
        NSString *user_id = responseObject[@"user_id"];
        NSString *username = responseObject[@"username"];
        NSString *phone_number = responseObject[@"phone_number"];
        NSString *overall_score = responseObject[@"allScore"];
        NSString *overall_time = responseObject[@"allTime"];
        NSString *highest_rank = responseObject[@"rank"];
        NSString *best_score = responseObject[@"best_score"];
        NSString *best_game_time = responseObject[@"time_passed"];
        NSString *total_games = responseObject[@"totalGames"];
        NSString *total_wins = responseObject[@"wins"];
        NSString *total_losses = responseObject[@"lost"];
        NSString *best_game_played_date = responseObject[@"best_game_played_date"];
        NSString *push_notification = responseObject[@"push_notification"];
        NSString *private = responseObject[@"private"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       
        [defaults setObject:self.fbid forKey:@"fb_id"];
        [defaults setObject:fbAccessToken forKey:@"token"];
        [defaults setObject:fname forKey:@"firstname"];
        [defaults setObject:lname forKey:@"lastname"];
        [defaults setObject:email forKey:@"email"];
        [defaults setObject:phone_number forKey:@"phone_number"];
        [defaults setObject:@"Facebook" forKey:@"logintype"];
        [defaults setObject:pic forKey:@"picture"];
        [defaults setObject:user_id forKey:@"user_id"];
        [defaults setObject:overall_score forKey:@"overall_score"];
        [defaults setObject:overall_time forKey:@"overall_time"];
        [defaults setObject:highest_rank forKey:@"highest_rank"];
        [defaults setObject:best_score forKey:@"best_score"];
        [defaults setObject:best_game_time forKey:@"best_game_time"];
        [defaults setObject:total_games forKey:@"total_games"];
        [defaults setObject:total_wins forKey:@"total_wins"];
        [defaults setObject:total_losses forKey:@"total_losses"];
        [defaults setObject:username forKey:@"username"];
        [defaults setObject:best_game_played_date forKey:@"best_game_played_date"];
        [defaults setObject:push_notification forKey:@"push_notification"];
        [defaults setObject:private forKey:@"private"];
  
        [defaults synchronize];
        

        if ([status isEqualToString:@"one"])
        {
                [self.delegate firstTimeLogin];
            NSLog(@"DDD wat the ");
        }
        else
            
        {
               [self.delegate updatedLogin];
        }
        
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"issue");
       //      [self.delegate didLogin];
        
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self.delegate facebookLoginError];
        
    }];
    
}

-(void)loginTry
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
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
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self.delegate facebookLoginError];
    }
}


-(void)logoutOfFacebook
{
       [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
       [FBSession setActiveSession:nil];
}


@end
