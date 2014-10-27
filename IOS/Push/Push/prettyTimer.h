//
//  prettyTimer.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "prettyTimerDelegate.h"

@protocol prettyTimerDelegate <NSObject>
-(void)prettyTimerHasEnded;
-(void)ptimerHasTicked:(NSString*)timeLeft;
@end

@interface prettyTimer : NSObject{
    id<prettyTimerDelegate>delegate;
}

@property (nonatomic,weak)id delegate;
@property(nonatomic,assign)NSInteger countdownAmount;
@property(nonatomic,retain)NSTimer *timer;
-(void)endTimer;
-(void)startTimer;
-(void)pauseTimer;


@end
