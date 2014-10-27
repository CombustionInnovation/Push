//
//  GameCircleDelegate.h
//  Push
//
//  Created by Daniel Nasello on 9/15/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameCircleDelegate <NSObject>
-(void)gameStarted;
-(void)gameEnded;
@end
