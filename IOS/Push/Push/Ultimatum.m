//
//  Ultimatum.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "Ultimatum.h"

@implementation Ultimatum

-(void)setNewUltimatum
{
    NSArray *times = [[NSArray alloc]init];
    times = @[@3,@1,@11,@2,@0];
     int i = arc4random() % 5;
    NSLog(@"the amoutn %d",i);
     self.timer = [NSTimer scheduledTimerWithTimeInterval:i target:self selector:@selector(startUltimatum) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)ultimatumWasMet
{
    [self stopInterval];
    [self setNewUltimatum];
    
}

-(void)startUltimatum
{
   
     [self.delegate ultimatumHasStarted];
}

-(void)ultimatumFailed
{
    [self stopInterval];
}

-(void)stopInterval
{
    [self.timer invalidate];
}

@end
