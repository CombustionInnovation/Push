//
//  GCHelper.m
//  Push
//
//  Created by Daniel Nasello on 10/6/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "GCHelper.h"

@import Foundation;




@implementation GCHelper


static GCHelper *_sharedHelper = nil;

+ (GCHelper*)defaultHelper {
    
    // dispatch_once will ensure that the method is only called once (thread-safe)
    
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        
        _sharedHelper = [[GCHelper alloc] init];
        
    });
    
    return _sharedHelper;
    
}


- (BOOL)isGameCenterAvailable {
    
    // check for presence of GKLocalPlayer API
    
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    
    
    // check if the device is running iOS 4.1 or later
    
    NSString *reqSysVer = @"4.1";
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    
    
    return (gcClass && osVersionSupported); 
    

}

- (id)init {
    
    if ((self = [super init])) {
        
        gameCenterAvailable = [self isGameCenterAvailable];
        
        if (gameCenterAvailable) {
            
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
            
        }
        
    }
    
    return self;
    
}


- (void)authenticateLocalUserOnViewController:(UIViewController*)viewController

                            setCallbackObject:(id)obj

                            withPauseSelector:(SEL)selector

{
    
    if (!gameCenterAvailable) return;
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    
    
    NSLog(@"Authenticating local user...");
    
    if (localPlayer.authenticated == NO) {
        
        [localPlayer setAuthenticateHandler:^(UIViewController* authViewController, NSError *error) {
            
            if (authViewController != nil) {
                
                if (obj) {
                    
                    [obj performSelector:selector withObject:nil afterDelay:0];
                    
                }
                
                
                
                [viewController presentViewController:authViewController animated:YES completion:^ {
                    
                }];
                
            } else if (error != nil) {
                
                // process error
                
            }
            
        }];
        
    }
    
    else {
        
        NSLog(@"Already authenticated!");
        
    }
    
}


- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        
        NSLog(@"Authentication changed: player authenticated.");
        
        userAuthenticated = TRUE;
        
        
        
        // Load the leaderboard info
        
        // Load the achievements
        
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        
        NSLog(@"Authentication changed: player not authenticated.");
        
        userAuthenticated = FALSE;
        
    }
    
}
@end
