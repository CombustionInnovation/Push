//
//  LoginManager.h
//  Push
//
//  Created by Daniel Nasello on 9/18/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocialLoginDelegate.h"
@protocol SocialLoginDelegate <NSObject>
-(void)PushLoginError;
-(void)PushUpdatedLogin;
@end

@interface LoginManager : NSObject{
    id<SocialLoginDelegate>delegate;
}
@property (nonatomic,weak)id delegate;
-(void)login:(NSString*)username:(NSString *)password;



@end
