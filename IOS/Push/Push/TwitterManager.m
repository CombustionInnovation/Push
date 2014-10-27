//
//  TwitterManager.m
//  Push
//
//  Created by Daniel Nasello on 9/16/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "TwitterManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

@implementation TwitterManager

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initStuff];
      
    }
    return self;
}

-(void)initStuff
{
    
}


-(BOOL)checktwitter
{
    
    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        self.isL = YES;
    } errorBlock:^(NSError *error) {
        self.isL = NO;
    }];
    
    
    return self.isL;
}

-(void)loginToTwitter
{
   
    
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerName:nil
                                                consumerKey:@"ESjOsoFnZ40JIBUnMrXV8LOxK"
                                             consumerSecret:@"7i5mG2oOJxELHJASrQioPkeVJilC8Xjz0rmcJroo7wbB6ZVx05"];
    
    [self.twitter postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
        
        STTwitterAPI *twitterAPIOS = [STTwitterAPI twitterAPIOSWithFirstAccount];
        
        [twitterAPIOS verifyCredentialsWithSuccessBlock:^(NSString *username) {
            
            [twitterAPIOS postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                                                                successBlock:^(NSString *oAuthToken,
                                                                               NSString *oAuthTokenSecret,
                                                                               NSString *userID,
                                                                               NSString *screenName) {
                                                                    
                                                                    
                                                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                                    
                                                             
                                                                    [defaults setObject:screenName forKey:@"email"];
                                                                    [defaults synchronize];
                                                                    [self loginToNetwork:screenName];
                                                    
                                                                    
                                                                    NSLog(@"issue");
                                                                } errorBlock:^(NSError *error) {
                                                                   // [self showAlert:@"Enter your twitter credentials on the settings page!"];
                                                                    [self.delegate userMustEnterCredentials];
                                                                  NSLog(@"issdsdue");
                                                                }];
            
        } errorBlock:^(NSError *error) {
            // ...  NSLog(@"errirrrrr");
        //    [self showAlert:@"Enter your twitter credentials on the settings page!"];\]
            [self.delegate userMustEnterCredentials];
          NSLog(@"isssdasdue");
        }];
        
    } errorBlock:^(NSError *error) {
        // ...
        //[self showAlert:@"Enter your twitter credentials on the settings page!"];
        [self.delegate userMustEnterCredentials];
         NSLog(@"%@",error);
    }];
}


-(void)loginToNetwork:(NSString *)username
{
     NSLog(@"issue");
    [self.delegate userWillLoginWithTwitter];
    NSDictionary *params = @{
                             @"user":[NSString stringWithFormat:@"%@",username],
                             @"device":[NSString stringWithFormat:@"%@",@"iPhone"],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/push/php/twitterLogin.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"loginstatus"];
        NSString *fname = responseObject[@"fname"];
        NSString *lname = responseObject[@"lname"];
        NSString *email = responseObject[@"email"];
        NSString *pic = responseObject[@"picture"];
        NSString *user_id = responseObject[@"user_id"];
        NSString *phone_number = responseObject[@"phone_number"];

        NSString *overall_score = responseObject[@"allScore"];
        NSString *overall_time = responseObject[@"allTime"];
        NSString *highest_rank = responseObject[@"rank"];
        NSString *best_score = responseObject[@"best_score"];
        NSString *best_game_time = responseObject[@"time_passed"];
        NSString *total_games = responseObject[@"totalGames"];
        NSString *total_wins = responseObject[@"wins"];
        NSString *total_losses = responseObject[@"lost"];
        NSString *username = responseObject[@"username"];
        NSString *best_game_played_date = responseObject[@"best_game_played_date"];
        NSString *push_notification = responseObject[@"push_notification"];
        NSString *private = responseObject[@"private"];
        
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:fname forKey:@"firstname"];
        [defaults setObject:lname forKey:@"lastname"];
        [defaults setObject:phone_number forKey:@"phone_number"];
        [defaults setObject:email forKey:@"email"];
        [defaults setObject:@"Twitter" forKey:@"logintype"];
        [defaults setObject:pic forKey:@"picture"];
        [defaults setObject:user_id forKey:@"user_id"];
        [defaults setObject:username forKey:@"username"];
        [defaults setObject:overall_score forKey:@"overall_score"];
        [defaults setObject:overall_time forKey:@"overall_time"];
        [defaults setObject:highest_rank forKey:@"highest_rank"];
        [defaults setObject:best_score forKey:@"best_score"];
        [defaults setObject:best_game_time forKey:@"best_game_time"];
        [defaults setObject:total_games forKey:@"total_games"];
        [defaults setObject:total_wins forKey:@"total_wins"];
        [defaults setObject:total_losses forKey:@"total_losses"];
        [defaults setObject:best_game_played_date forKey:@"best_game_played_date"];
        [defaults setObject:push_notification forKey:@"push_notification"];
        [defaults setObject:private forKey:@"private"];
        [defaults synchronize];
        
        if ([status isEqualToString:@"one"])
        {
            [self.delegate firstTimeLoginTwitter];
        }
        else
            
        {
            [self.delegate updatedLoginTwitter];
        }
        
        
        // [self.delegate userWillLoginWithTwitter];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"issue");
        //      [self.delegate didLogin];
        
                // Show the user the logged-out UI
        [self.delegate failLoginTwitter];
        
    }];

    
}


@end
