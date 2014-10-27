//
//  SyncPhoneBookButton.h
//  Push
//
//  Created by Daniel Nasello on 9/20/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetContacts.h"
#import "SyncPhoneProtocol.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

@protocol SyncPhoneProtocol <NSObject>

-(void)willStartPhoneProcess;
-(void)userDeniedPhonebookPermissions;
-(void)numberSyncFail;
-(void)didSendNumbers;
@end


@interface SyncPhoneBookButton : UIButton{
    id<SyncPhoneProtocol>deleate;
}
@property(nonatomic,weak)id delegate;
@property(nonatomic,strong)GetContacts *contacts;
-(void)initClass;
@end
