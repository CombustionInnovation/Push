//
//  FacebookManager.h
//  Push
//
//  Created by Daniel Nasello on 9/16/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "FacebookManagerDelegate.h"

@protocol FacebookManagerDelegate <NSObject>
-(void)updatedLogin;
-(void)firstTimeLogin;
-(void)userLoggedinFacebook;
-(void)facebookLoginError;
@end


@interface FacebookManager : UIView{
    id<FacebookManagerDelegate>delegate;
}

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
@property(nonatomic,strong)UIButton *loginButton;
-(void)loginTry;
-(void)logoutOfFacebook;
-(void)signInFB;
@end
