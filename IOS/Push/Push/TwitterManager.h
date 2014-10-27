//
//  TwitterManager.h
//  Push
//
//  Created by Daniel Nasello on 9/16/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTwitterAPI.h"
#import "TwitterProtocol.h"

@protocol TwitterProtocol <NSObject>
-(void)firstTimeLoginTwitter;
-(void)updatedLoginTwitter;
-(void)failLoginTwitter;
-(void)userMustEnterCredentials;
-(void)userWillLoginWithTwitter;
@end


@interface TwitterManager : UIView{
    id<TwitterProtocol>delegate;
}
@property(nonatomic,assign)BOOL isL;
@property(nonatomic,weak)id delegate;
@property(strong,nonatomic)STTwitterAPI *twitter;
-(BOOL)checktwitter;
-(void)loginToTwitter;
@end
