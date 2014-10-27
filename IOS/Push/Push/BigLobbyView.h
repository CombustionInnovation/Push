//
//  BigLobbyView.h
//  Push
//
//  Created by Daniel Nasello on 9/29/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "OstLabel.h"
#import "ostMedium.h"
@interface BigLobbyView : UIView
@property(strong,nonatomic)NSMutableArray *playerArray;
@property(assign,nonatomic)int numPlayers;
@property(assign,nonatomic)int mode;
@property(strong,nonatomic)NSMutableArray *myPlayers;
-(void)createLayout;
-(void)addPlayer:(NSDictionary *)player;
-(void)removePlayer:(NSString *)playerId;
-(void)doLobbyAnimation;
@property(strong,nonatomic)UIView *parentView;
@property(strong,nonatomic)UIView *containerView;
@property(assign,nonatomic)CGRect rec;
@property(strong,nonatomic)ostMedium *match_begins;
@property(strong,nonatomic)OstLabel *countDown;
-(void)addInitial:(NSMutableArray *)players;
@property(nonatomic,strong)NSMutableArray *pids;
@end
