//
//  PUSHMultiPlayerLobbyViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//


/*
 -(void)tickTimeStartTimer:(NSString *)text;
 -(void)tickCountUpTimer:(NSString *)text;
 -(void)playerHasLeft:(NSString *)playerId;
 -(void)gameWillNowStart;
 -(void)startUltimatum;
 -(void)ultimatumWasMetMulti;
 -(void)UserHasLost;
 -(void)ultimatumTimerTicked:(NSString *)text;
*/
//game screen mehtods



#import "PUSHMultiPlayerLobbyViewController.h"
#import "MultiPlayerTabs.h"
#import "FourPlayerManager.h"
#import <SIOSocket/SIOSocket.h>
#import "MBProgressHUD.h"
#import "NSDictionary+JSONDict.h"
#import "BigLobbyView.h"
#import "PUSHMultiPlayerGameModeViewController.h"
@interface PUSHMultiPlayerLobbyViewController (){
    MultiPlayerTabs *peopleToggle;
    FourPlayerManager *playerManager;
    NSString *currentgame;
    NSDictionary *opponents;
    NSMutableArray *opArray;
    NSString *myuserid;
    Boolean ftick;
    BigLobbyView *lobby;
    Boolean timerIsOn;
    PUSHMultiPlayerGameModeViewController    *gameScreen;
    Boolean isCancelable;
    int gameScore;
    BOOL gameIsPlaying;
    int incrementer;
    BOOL shouldshake;
    BOOL isgameOver;
    int incrementers;
    int gameRank;
}


@end

@implementation PUSHMultiPlayerLobbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //red toggle
    peopleToggle = [[MultiPlayerTabs alloc]initWithFrame:[self.redTabHolder bounds]];
    peopleToggle.delegate = self;
    [self.redTabHolder addSubview:peopleToggle];
    //sets initial game score
    gameScore = 0;
    //sets the game to either one player vs or 4 royale
    [self setG:self.gameType];
    
    //the four player manager
    playerManager = [[FourPlayerManager alloc]initWithFrame:self.playerHolder.bounds];
    playerManager.mode = 4;
    playerManager.containerView = self.containerView;
    playerManager.parentView = self.playerHolder;
    [playerManager createLayout];
    [self.playerHolder addSubview:playerManager];
  
    // Do any additional setup after loading the view, typically from a nib.
    timerIsOn = NO;

    //this is the countdown lobby
    lobby = nil;

    //this game id;
    currentgame = nil;
    
    //this is when I am in game and I should shake or not
    shouldshake = NO;

    //is ticking
    ftick = YES;
    //can the game be canceled?
    isCancelable = YES;
    
    //starts the sockets
    [self startSockets];
    
    //game is playing
    gameIsPlaying = NO;
    
    //sets the screen two out of view and makes the scroll view bigger
    [self.screenTwo setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
     self.scrollView.delegate = self;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *2)];
   
    //adds the multiplayer game screen to the screen two view.
    UIStoryboard *storyBoard = [self storyboard];
    gameScreen = [storyBoard instantiateViewControllerWithIdentifier:@"multigametime"];
    gameScreen.delegate = self;
    [self.screenTwo addSubview:gameScreen.view];
    [gameScreen didMoveToParentViewController:self];
    
    //adds my player object to the lobby
    [self addMyself];
 
    incrementers = 0;
    incrementer=0;
    gameRank = 1000000;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startSockets
{
    
//starts socket
    [SIOSocket socketWithHost: @"http://en-cryptapp.com:3000" response: ^(SIOSocket *socket)
    {
        self.socket = socket;
        __weak typeof(self) weakSelf = self;
        self.socket.onConnect = ^()
        {
            if(ftick)
            {
                [weakSelf addToPool];
                NSLog(@"@@@");
                ftick  = NO;
            }
        };


        
        
        //socket is saying I am now able to search a game
        [self.socket on: @"player_in_pool" callback: ^(id userid)
         {
             NSString *us = [NSString stringWithFormat:@"%@",userid];
             myuserid = us;
             [self searchForGame];
         
         }];
        
        
        //we have found a lobby to play in and returns the game id
        [self.socket on: @"game_entered" callback: ^(id gid)
         {
             NSString *g = gid;
             [self gameFound:g];
             NSLog(@"game time");
         }];
        
        
        //player who left id lobby
        [self.socket on: @"player_left" callback: ^(id player_id)
         {
             NSString *p = player_id;
             NSLog(@"the player leasving is %@",p);
          
             if(lobby)
             {
                 [lobby removePlayer:p];
                 [playerManager removePlayer:p:NO];
             }
             else
             {
                 [playerManager removePlayer:p:YES];
             }
         
         }];
        
        
        //player who left id
        [self.socket on: @"lobby_timer_ticked" callback: ^(id time_left)
         {
             NSString *remaining = time_left;
             [self streamTimerHasTicked:remaining];
         }];
        
        
        //we are getting the game players of the current game of the lobby
        [self.socket on: @"other_players" callback: ^(id otherPlayersArray)
         {
             //an array of the current players in the lob
             NSArray *otherPlayers = otherPlayersArray;
             NSLog(@" other fucking player s  %@",otherPlayers);
             for(NSDictionary * d in otherPlayers)
             {
                 NSString *uid = [d objectForKey:(@"user_id")];
                if(![uid isEqualToString:myuserid])
                {
                    if(lobby && timerIsOn)
                    {
                        [playerManager addPlayer:d:NO];
                        [lobby addPlayer:d];
                    }
                    else
                    {
                        [playerManager addPlayer:d:YES];
                    }
                }
             }
         }];
        
        // a person adds to the game after you have entered the lobby
        [self.socket on: @"curr_players" callback: ^(id playerObject)
         {
             NSDictionary *player = playerObject;
             NSString *uid = [player objectForKey:(@"user_id")];
             
             
             if(![uid isEqualToString:myuserid])
             {
                 
               //  [self showAlert:@"a new player"];
                 
                    if(lobby && timerIsOn)
                    {
                        [playerManager addPlayer:player:NO];
                        [lobby addPlayer:player];
                    }
                    else
                    {
                        [playerManager addPlayer:player:YES];
                    }
            }
             
             
         }];
        
        
        //enough people to play, lets go
        [self.socket on: @"lobby_timer_started" callback: ^(id pinID)
         {
             NSLog(@"enough to start lobby");
             [self doLobbyTimerStart];
            
         }];
        
        //not enough people in the lobby
        [self.socket on: @"lobby_timer_canceled" callback: ^(id pinID)
         {
                NSLog(@"enough to end lobby");
                [self doLobbyTimerWasCanceled];
         }];

        //game is ready to commence
        [self.socket on: @"game_will_start" callback: ^(id time_left)
         {
              gameIsPlaying = YES;
              gameScore = 0;
              incrementer = 0;
              isCancelable = NO;
              [self goToGameScreen];
             
         }];
        
        
        //final countdown lobbby timer
        [self.socket on: @"gameStartTimerHasTicked" callback: ^(id time_left)
         {
             NSString *tdown = time_left;
             [gameScreen tickTimeStartTimer:tdown];
         }];
        

        //game commencing
        [self.socket on: @"gameStarted" callback: ^(id pinID)
         {
             [gameScreen gameWillNowStart];
         }];

        //game timer is going up
        [self.socket on: @"upTimerClicked" callback: ^(id time_left)
         {
      
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
             dispatch_async(queue, ^{
                    incrementer++;
                 
                    if(incrementer > 9)
                    {
                        incrementer = 0;
                        gameScore++;
                        gameScreen.score = gameScore;
                        NSLog(@"up timer clicked %d",incrementers);
                        NSLog(@"up timer clicked %d",incrementer);
                        
                        incrementers = 0;
                    }
          
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                    
                     NSDictionary *tleft = time_left;
                     NSString *hr = [tleft objectForKey:@"hours"];
                     NSString *min = [tleft objectForKey:@"mins"];
                     NSString *sec = [tleft objectForKey:@"secs"];
                     NSString *mil = [tleft objectForKey:@"millis"];
               //      NSString *formattedTime = [NSString stringWithFormat:@"%@:%@:%@:%d",hr,min,sec,incrementers];
              
                        incrementers++;
                         NSString *formattedTime = [NSString stringWithFormat:@"%@:%@:%@:%@",hr,min,sec,mil];
                         [gameScreen tickCountUpTimer:formattedTime];
                     
            
                 });
                 
            });
    
          
             
         }];
  
        
        //start the ultimatum sequence
        [self.socket on: @"utlimatum_will_start" callback: ^(id pinID)
         {
             [gameScreen startUltimatum];
             if(!shouldshake)
             {
                 shouldshake = YES;
             }
         }];
        
        //start the ultimatum sequence
        [self.socket on: @"utlimatum_timer_ticked" callback: ^(id t_left)
         {
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 NSString *tl = t_left;
                 [gameScreen ultimatumTimerTicked:tl];
             });
             
         }];
        
        //we have met the ultimatum go back to normal
        [self.socket on: @"ultimatum_met" callback: ^(id t_left)
         {
             [gameScreen ultimatumWasMetMulti];
             NSLog(@"the ulitmatum was met");
         }];
        
        //we have met the ultimatum go back to normal
        [self.socket on: @"force_game_over" callback: ^(id t_left)
         {
                gameIsPlaying = NO;
                [gameScreen UserHasLost];
                NSLog(@"user forced to quqit");
         }];
        
        
        //we have met the ultimatum go back to normal
        [self.socket on: @"player_has_lost_game" callback: ^(id playerObj)
         {
             NSDictionary *losingPlayer = playerObj;
            //player id and player position
             NSLog(@"a player has lost");
             //var player_id = obj.player_gone;
             //var position = obj.position;
             //[gameScreen UserHasLost];
             [gameScreen playerhasLost:losingPlayer];
       }];
          
          
          [self.socket on: @"multi_rank" callback: ^(id newRank)
         {
             NSString *callBackRank = newRank;
             if([callBackRank intValue] < gameRank)
             {
                 gameRank = [callBackRank intValue] ;
                 [self toastMessage:[NSString stringWithFormat:@"Your game is %@ in the world",callBackRank]];
             }
      
         }];
        
//main connection
        
    }];



}
//sets the game type
-(void)setG :(NSInteger)ty
{
    self.gameType = ty;
    if(ty == 0)
    {
        
        [self.gameImage setImage:[UIImage imageNamed:@"fourplayerroyal"]];
    }
    else
    {
        [self.gameImage setImage:[UIImage imageNamed:@"oneonone"]];
    }
}



//red tab toggle
-(void)tabWasChanged:(NSInteger)index
{
    NSLog(@"%d",index);
}


- (IBAction)backPressed:(id)sender {
    [self leaveLobby];
    [self.navigationController popViewControllerAnimated:YES];
}


//gets the game info
-(void)gameFound:(NSString *)g_id
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    currentgame = g_id;
    
     NSLog(@"the game id is %@",currentgame);

   //  [self.socket emit: @"get_game_info",
   //  [NSString stringWithFormat:@"%@",currentgame],
   //  nil];
    
    
            SIOParameterArray *ar =@[[NSString stringWithFormat:@"%@",currentgame]];
            [self.socket emit:@"get_game_info" args:ar];
}






//we send all the users information to find a game in the lobbies and gives my my player id in the pool

-(void)addToPool
{
    NSLog(@"going to add to poool");
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
       // [hud show:YES];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *email = [defaults objectForKey:@"user_id"];
        NSString *username = [defaults objectForKey:@"username"];
        NSString *picture = [defaults objectForKey:@"picture"];
    
        NSDictionary *params = @{
                             @"email":[NSString stringWithFormat:@"%@",email],
                             @"name":[NSString stringWithFormat:@"%@",username],
                             @"username":[NSString stringWithFormat:@"%@",username],
                             @"picture":[NSString stringWithFormat:@"%@",picture],
                             @"user_id":[NSString stringWithFormat:@"%@",email],
                             };
    
    
    
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@",[params bv_jsonStringWithPrettyPrint:NO]]);
    
    
  //  [self.socket emit: @"user_information",
  //  [params bv_jsonStringWithPrettyPrint:NO],
  //   nil
  //   ];
    NSString *s = [params bv_jsonStringWithPrettyPrint:NO];
    
    SIOParameterArray *ar = @[s];
     [self.socket emit:@"user_information" args:ar];
    
}



//now i am searching for an actual game
-(void)searchForGame
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"user_id"];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *picture = [defaults objectForKey:@"picture"];
    NSDictionary *params = @{
                             @"email":[NSString stringWithFormat:@"%@",email],
                             @"name":[NSString stringWithFormat:@"%@",username],
                             @"username":[NSString stringWithFormat:@"%@",username],
                             @"picture":[NSString stringWithFormat:@"%@",picture],
                             @"user_id":[NSString stringWithFormat:@"%@",email],
                             };
    
    

//    [self.socket emit: @"search_game",
 //    [params bv_jsonStringWithPrettyPrint:NO] ,
 //    nil];
            SIOParameterArray *ar =@[[params bv_jsonStringWithPrettyPrint:NO]];
            [self.socket emit:@"search_game" args:ar];
}



///add the current players that are pre-existing in the lobby
-(void)getCurrentPlayersInLobby:(NSArray *)currentPlayers
{
    for(NSDictionary *d in currentPlayers)
    {
        
        [opArray addObject:d];

        
    }
}


//add my self to the screen
-(void)addMyself
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:@"user_id"];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *picture = [defaults objectForKey:@"picture"];
    
    NSDictionary *params = @{
                             @"email":[NSString stringWithFormat:@"%@",email],
                             @"name":[NSString stringWithFormat:@"%@",username],
                             @"username":[NSString stringWithFormat:@"%@",username],
                             @"picture":[NSString stringWithFormat:@"%@",picture],
                             @"user_id":[NSString stringWithFormat:@"%@",email],
                             };
    
    [playerManager addPlayer:params:NO];

}

///
-(void)leaveLobby
{
    ///if I am in a game leave it because I have lost or disconnected
    if(currentgame)
    {

        NSDictionary *params = @{
                                 @"game_id":[NSString stringWithFormat:@"%@",currentgame],
                                 @"user_id":[NSString stringWithFormat:@"%@",myuserid],
                            };

      //   [self.socket emit: @"leave_game",
       //  [params bv_jsonStringWithPrettyPrint:NO] ,
       //  nil];
        
             SIOParameterArray *ar =@[[params bv_jsonStringWithPrettyPrint:NO]];
        [self.socket emit:@"leave_game" args:ar];
        currentgame = nil;
    }
    
    
    NSLog(@"leavelobby");
}


//there is enough people to play, so we are going to star the countdown to the game
-(void)doLobbyTimerStart
{
   if(!timerIsOn)
   {
       if(!lobby)
       {
            lobby = [[BigLobbyView alloc]initWithFrame:CGRectMake(0,50,self.view.frame.size.width,self.view.frame.size.height-50)];
          //  lobby.playerArray = playerManager.playerArray;
            [lobby addInitial:playerManager.playerArray];
            [self.screenOne addSubview:lobby];

        }
        else
        {
            [lobby removeFromSuperview];
            lobby = nil;
            [self doLobbyTimerStart];
        }
    
       timerIsOn = YES;
   }
}

//too many people left the game, lets cancel and go back to search
-(void)doLobbyTimerWasCanceled
{
    if(lobby)
    {
        [lobby removeFromSuperview];
        lobby  = nil;
    }
    
     timerIsOn = NO;
}

//lobby timer from the server has clicked
-(void)streamTimerHasTicked:(NSString *)text
{
    if(lobby)
    {
        [lobby.countDown setText:[NSString stringWithFormat:@"0:%@",text]];
    }
    else
    {
        [self doLobbyTimerStart];
    }
    
}



//scrolls to the game view
-(void)goToGameScreen
{
    [self.scrollView setContentOffset:CGPointMake(0, self.view.frame.size.height) animated:YES];
    [gameScreen addOtherPlayersToGame:playerManager.playerArray];
    
}




//start game screen delegate
//shook phoen for ultimatum timer
-(void)didShakePhone
{
    NSLog(@"shaken");

    NSDictionary *params = @{
                             @"game_id":[NSString stringWithFormat:@"%@",currentgame],
                             @"user_id":[NSString stringWithFormat:@"%@",myuserid],
                             };
    

      SIOParameterArray *ar =@[[params bv_jsonStringWithPrettyPrint:NO]];
    
    [self.socket emit:@"ultlimatum_done" args:ar];
    

}
//we lost somehow so tell the socket we did so
-(void)userLost
{
    gameIsPlaying =NO;
    
    if(currentgame)
    {
        NSLog(@"u lose sucka");
        
        NSDictionary *params = @{
                             @"game_id":[NSString stringWithFormat:@"%@",currentgame],
                             @"user_id":[NSString stringWithFormat:@"%@",myuserid],
                             @"final_score":[NSString stringWithFormat:@"%d",gameScore]
                             };
    
   
 
        
        SIOParameterArray *ar =@[[params bv_jsonStringWithPrettyPrint:NO]];
        [self.socket emit:@"u_lose" args:ar];
        currentgame = nil;
    }
}



//end game screen delegate
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        if(shouldshake)
        {
            NSLog(@"shakkeeeeee");
            shouldshake = NO;
            [self didShakePhone];
        }
        
    }
}

//shaked
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(shouldshake)
    {
        NSLog(@"shakkeeeeee");
         shouldshake = NO;
        [self didShakePhone];
    }
    else
    {
        NSLog(@"cant shake");
        
    }
    
}
-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGoToBack)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGoToBack)
                                                 name:UIApplicationWillTerminateNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillTerminateNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    
}



//user puts app in background
-(void)didGoToBack
{
    if(gameIsPlaying)
    {
        [self userLost];
        [gameScreen endGameOperations];
    }
    else
    {
        [self userWantsToLeave];
        NSLog(@"got it");
    }
}

//


//delegate game screen

-(void)userWantsToLeave
{
    [self leaveLobby];
    [self.navigationController popViewControllerAnimated:YES];
}

//


-(void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"PUSH"
                          message: message
                          delegate: nil
                          cancelButtonTitle: @"Okay"
                          otherButtonTitles:nil];
    [alert show];
}

-(void)toastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color =[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = 200.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}

@end

