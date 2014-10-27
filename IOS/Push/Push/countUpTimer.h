//
//  countUpTimer.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "countUpTimerDelegate.h"
@protocol countUpTimerDelegate <NSObject>
-(void)timerHasTicked:(NSString *)countUpAmount;
-(void)tenSecondInterVal;
@end


@interface countUpTimer : NSObject{
    id<countUpTimerDelegate>delegate;
}
@property (nonatomic,weak)id delegate;
@property(nonatomic,assign)NSInteger countUpAmount;
@property(nonatomic,assign)NSInteger countUpAmountTens;
@property(nonatomic,assign)NSInteger countUpAmountTenth;
@property(nonatomic,assign)NSInteger countUpAmountMilli;
@property(nonatomic,retain)NSTimer *timer;
-(void)stopTimer;
-(void)startTimer;
-(void)pauseTimer;
-(NSString *)getFinalTime;
-(NSInteger)getFinalScore;
-(void)resetGameTimer;
@end
