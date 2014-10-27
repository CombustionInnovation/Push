//
//  TwitterProtocol.h
//  Push
//
//  Created by Daniel Nasello on 9/16/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TwitterProtocol <NSObject>
-(void)firstTimeLoginTwitter;
-(void)updatedLoginTwitter;
-(void)failLoginTwitter;
-(void)userMustEnterCredentials;
-(void)userWillLoginWithTwitter;
@end
