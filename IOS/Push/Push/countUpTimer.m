//
//  countUpTimer.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "countUpTimer.h"

@implementation countUpTimer



- (void) startTimer
{
    self.timer =   [NSTimer scheduledTimerWithTimeInterval:.1
                                                    target:self
                                                  selector:@selector(tick:)
                                                  userInfo:nil
                                                   repeats:YES];
    
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void) tick:(NSTimer *) timer {
    //do something here..
  
    self.countUpAmountTenth++;

    self.countUpAmountMilli++;
    if(self.countUpAmountMilli >=10)
    {
          self.countUpAmountMilli = 0;
          self.countUpAmountTenth = 0;
          self.countUpAmount++;
          self.countUpAmountTens++;
         if(self.countUpAmountTens>=10)
         {
             [self.delegate tenSecondInterVal];
             self.countUpAmountTens =0;
         }
    
    }
    NSString *mil = [self  formatZeros: self.countUpAmountTenth * 10];
    NSString *hours = [self  formatZeros:self.countUpAmount / (60 * 60)];
    NSString *minutes = [self  formatZeros:(self.countUpAmount % (60 * 60)) / 60];
    NSString *seconds = [self  formatZeros:((self.countUpAmount % (60 * 60)) % 60)];
    
    NSString *time = [NSString stringWithFormat:@"%@:%@:%@:%@", hours, minutes, seconds,mil];
     [self.delegate timerHasTicked:time];
}

-(NSString *)getFinalTime
{
    
    
    NSString *hours = [self  formatZeros:self.countUpAmount / (60 * 60)];
    NSString *minutes = [self  formatZeros:(self.countUpAmount % (60 * 60)) / 60];
    NSString *seconds = [self  formatZeros:((self.countUpAmount % (60 * 60)) % 60)];
    
    NSString *time = [NSString stringWithFormat:@"%@:%@:%@", hours, minutes, seconds];
    return time;
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

-(NSInteger)getFinalScore
{
    return self.countUpAmount;
}


-(void)stopTimer
{
    [self.timer invalidate];
}

-(void)resetGameTimer
{
    self.countUpAmount = 0;
    self.countUpAmountMilli = 0;
    self.countUpAmountTenth = 0;
}





@end