//
//  UserSignedUpDelegate.h
//  Push
//
//  Created by Daniel Nasello on 9/18/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserSignedUpDelegate <NSObject>
-(void)userRegistered:(NSString *)username:(NSString *)password;
@end
