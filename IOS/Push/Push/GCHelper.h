//
//  GCHelper.h
//  Push
//
//  Created by Daniel Nasello on 10/6/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GameKit;
@interface GCHelper : NSObject {
    
    BOOL gameCenterAvailable;
    
    BOOL userAuthenticated;
    
}

@property (assign, readonly) BOOL gameCenterAvailable;

@end
