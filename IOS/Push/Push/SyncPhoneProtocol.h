//
//  SyncPhoneProtocol.h
//  Push
//
//  Created by Daniel Nasello on 9/20/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyncPhoneProtocol <NSObject>

-(void)willStartPhoneProcess;
-(void)userDeniedPhonebookPermissions;
-(void)numberSyncFail;
-(void)didSendNumbers;
@end
