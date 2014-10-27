//
//  Ultimatum.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UltimatumDelegate.h"
@protocol UltimatumDelegate <NSObject>
-(void)ultimatumHasFailed;
-(void)ultimatumHasStarted;
@end
@interface Ultimatum : NSObject{
    id<UltimatumDelegate>delegate;
}
-(void)setNewUltimatum;
-(void)ultimatumWasMet;
-(void)stopInterval;
-(void)ultimatumFailed;
@property (nonatomic,weak)id delegate;
@property(nonatomic,strong)NSTimer *timer;
@end
