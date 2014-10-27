//
//  InGameOpponents.h
//  Push
//
//  Created by Daniel Nasello on 10/2/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InGameOpponents : UIView
@property(strong,nonatomic)NSMutableArray *playerArray;
@property(assign,nonatomic)int numPlayers;
@property(assign,nonatomic)int mode;
@property(strong,nonatomic)NSMutableArray *myPlayers;
-(void)createLayout;
-(void)addPlayer:(NSDictionary *)player :(BOOL)animated;
-(void)removePlayer:(NSString *)playerId :(BOOL)animated;
-(void)doLobbyAnimation;
@property(strong,nonatomic)UIView *parentView;
@property(strong,nonatomic)UIView *containerView;
@property(assign,nonatomic)CGRect rec;
@property(nonatomic,assign)int playerCount;
-(void)playerLost:(NSDictionary *)playerInfo;
@end
