//
//  prettyTimer.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "prettyTimer.h"

@implementation prettyTimer




- (void) startTimer
{
    self.countdownAmount = 45;
    self.timer =   [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
          [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void) tick:(NSTimer *) timer {
    //do something here..
   
    self.countdownAmount--;
    [self.delegate ptimerHasTicked:[self formatZeros:self.countdownAmount]];
    if(self.countdownAmount <1)
    {
        [self timerHasFailed];
    }
   
    NSLog(@"ticl");
    
}
-(NSString *)formatZeros:(NSInteger)number
{
    NSString *val = @"0";
    if(number < 10)
    {
        val  = [NSString stringWithFormat:@"%02d", number];
    }
    else
    {
        val =[NSString stringWithFormat:@"%d", number];
    }
    
    return val;
}

-(void)endTimer
{
    [self.timer invalidate];
    self.countdownAmount = 45;
}

-(void)timerHasFailed
{
    [self endTimer];
    [self.delegate prettyTimerHasEnded];
     self.countdownAmount = 45;
}


-(void)pauseTimer
{
    
}
@end
