//
//  MultiPlayerGameProtocol.h
//  Push
//
//  Created by Daniel Nasello on 9/30/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MultiPlayerGameProtocol <NSObject>
-(void)didShakePhone;
-(void)userLost;
-(void)userWantsToLeave;
@end
