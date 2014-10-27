//
//  TwitterSyncButton.m
//  Push
//
//  Created by Daniel Nasello on 9/20/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "TwitterSyncButton.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

@implementation TwitterSyncButton

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
    
    [self setBackgroundImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
     [self setBackgroundImage:[UIImage imageNamed:@"twitterpressed"] forState:UIControlStateHighlighted];
     [self setBackgroundImage:[UIImage imageNamed:@"twitterchecked"] forState:UIControlStateSelected];
    
       [self addTarget:self
               action:@selector(wasClicked)
     forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)wasClicked
{
    [self.delegate twitterSyncingWillBegin];
    
    [self loginToTwitter];
    
    
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
                                                                    
                                                                    
                                                               
                                                                    
                                                    
                                                                    [self syncWithNetwork:screenName];
                                                           
                                                                    
                                                                    
                                                                } errorBlock:^(NSError *error) {
                                                                    // [self showAlert:@"Enter your twitter credentials on the settings page!"];
                                                                    [self.delegate userMustEnterTwitterCredentials];
                                                                       NSLog(@"DDD");
                                                                }];
            
        } errorBlock:^(NSError *error) {
            // ...  NSLog(@"errirrrrr");
            //    [self showAlert:@"Enter your twitter credentials on the settings page!"];\]
            [self.delegate userMustEnterTwitterCredentials];
            NSLog(@"DDD");
            
        }];
        
    } errorBlock:^(NSError *error) {
        // ...
        //[self showAlert:@"Enter your twitter credentials on the settings page!"];
        [self.delegate userMustEnterTwitterCredentials];
    }];
}



-(void)syncWithNetwork:(NSString *)twitterSn
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];

    NSDictionary *params = @{
                             @"user_id":[NSString stringWithFormat:@"%@",user_id],
                             @"user":[NSString stringWithFormat:@"%@",twitterSn],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/push/php/syncTwitter.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"status"];
        NSString *fname = responseObject[@"fname"];

        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       
        [defaults synchronize];
        
        if ([status isEqualToString:@"one"])
        {
            [self.delegate twitterSyncSuccess];
        }
        else
            
        {
            [self.delegate twitterSyncFail];
        }
        
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"issue");
        [self.delegate twitterSyncFail];
        
    }];

    
}


@end
