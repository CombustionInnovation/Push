//
//  TwitterSyncButton.h
//  Push
//
//  Created by Daniel Nasello on 9/20/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTwitterAPI.h"
#import "TwitterSyncButton.h"

@protocol TwitterSyncProtocol <NSObject>
-(void)userMustEnterTwitterCredentials;
-(void)twitterSyncingWillBegin;
-(void)twitterSyncSuccess;
-(void)twitterSyncFail;
@end


@interface TwitterSyncButton : UIButton{
    id<TwitterSyncProtocol>delegate;
}
@property(strong,nonatomic)STTwitterAPI *twitter;
@property(nonatomic,weak)id delegate;
-(void)initClass;
@end
