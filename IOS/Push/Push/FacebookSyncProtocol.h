//
//  FacebookSyncProtocol.h
//  Push
//
//  Created by Daniel Nasello on 9/20/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FacebookSyncProtocol <NSObject>
-(void)facebookSyncFail;
-(void)facebookLoginErr;
-(void)facebookSyncSuccesss;
-(void)fbLoginWillStart;

-(void)facebookLoginErrSilent;
@end
