//
//  FacebookSyncButton.h
//  Push
//
//  Created by Daniel Nasello on 9/20/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookSyncProtocol.h"

@protocol FacebookSyncProtocol <NSObject>
-(void)facebookSyncFail;
-(void)facebookLoginErr;
-(void)facebookSyncSuccesss;
-(void)fbLoginWillStart;
-(void)facebookLoginErrSilent;
@end

@interface FacebookSyncButton : UIButton{
    id<FacebookSyncProtocol>delegate;
}

@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,weak)id delegate;
@property(strong,nonatomic)NSString *picture;
@property(strong,nonatomic)NSString *birthday;
@property(strong,nonatomic)NSString *fbid;
@property(strong,nonatomic)NSString *fbusername;
@property(strong,nonatomic)NSString *userEmail;
@property(strong,nonatomic)NSString *firstName;
@property(strong,nonatomic)NSString *lastName;
@property(strong,nonatomic)NSString *gender;
@property(assign,nonatomic)BOOL hasFired;
@property(assign,nonatomic)BOOL isLogged;

-(void)loginTry;
-(void)logoutOfFacebook;
-(void)signInFB;
-(void)initClass;
@end
