//
//  PUSHMultiPlayerGameModeViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "game_circle.h"
#import "UltimatumLabel.h"
#import "MultiPlayerGameProtocol.h"
#import "OstLabel.h"

@interface PUSHMultiPlayerGameModeViewController : UIViewController{
    id<MultiPlayerGameProtocol>delegate;
}
@property(weak,nonatomic)id delegate;
@property (strong, nonatomic) IBOutlet UltimatumLabel *ultimatumTimer;
@property (strong, nonatomic) IBOutlet UILabel *countUpTimer;
@property (strong, nonatomic) IBOutlet UIButton *xButton;
@property (strong, nonatomic) IBOutlet UIImageView *pushLogo;
@property (strong, nonatomic) IBOutlet UIView *circle_holder;
@property (strong, nonatomic) IBOutlet game_circle *game_cirlce;
@property (strong, nonatomic) IBOutlet game_circle *game_circle;
@property (strong, nonatomic) IBOutlet UIButton *micButton;
- (IBAction)micClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *holdToStartLabel;
@property (strong, nonatomic) IBOutlet OstLabel *timeToStart;
-(void)tickTimeStartTimer:(NSString *)text;
-(void)tickCountUpTimer:(NSString *)text;
-(void)playerHasLeft:(NSString *)playerId;
-(void)gameWillNowStart;
-(void)startUltimatum;
-(void)ultimatumWasMetMulti;
-(void)UserHasLost;
-(void)ultimatumTimerTicked:(NSString *)text;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property(assign,nonatomic)NSMutableArray *otherPlayers;
- (IBAction)xButtonWasTapped:(id)sender;
@property(nonatomic,assign)NSInteger score;
-(void)endGameOperations;
-(void)addOtherPlayersToGame:(NSMutableArray *)players;
-(void)playerhasLost:(NSDictionary *)player;
@end
