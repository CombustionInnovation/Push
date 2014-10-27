//
//  PhoneVerificationProtocol.h
//  Push
//
//  Created by Daniel Nasello on 9/18/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PhoneVerificationProtocol <NSObject>
-(void)userDidVerify:(NSString*)username:(NSString *)password;
-(void)userCanceledVerification;
-(void)tryToVerify:(NSString *)code:(NSDictionary *)dict;
-(void)resendCodeButtonPressed:(NSDictionary *)dict;
@end
