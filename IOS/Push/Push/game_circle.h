//
//  game_circle.h
//  Push
//
//  Created by Daniel Nasello on 9/15/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCircleDelegate.h"

@protocol GameCircleDelegate <NSObject>
-(void)gameStarted;
-(void)gameEnded;
@end

@interface game_circle : UIView{
    id<GameCircleDelegate>delegate;
}
@property (nonatomic,weak)id delegate;
@property(retain,nonatomic)UIView*outerView;
-(void)setOuterViews:(UIView *)v;
-(void)solidifyCircle;
@property (nonatomic,assign)BOOL canplay;
@property (nonatomic,assign)BOOL ispressed;
@end