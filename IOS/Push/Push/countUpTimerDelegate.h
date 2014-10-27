//
//  countUpTimerDelegate.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol countUpTimerDelegate <NSObject>
//-(void)timerHasTicked:(NSInteger)countUpAmount;
-(void)timerHasTicked:(NSString*)countUpAmount;
-(void)tenSecondInterVal;
@end
