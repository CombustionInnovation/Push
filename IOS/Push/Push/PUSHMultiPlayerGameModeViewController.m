//
//  PUSHMultiPlayerGameModeViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHMultiPlayerGameModeViewController.h"
#import "MBProgressHUD.h"
#import "InGameOpponents.h"
#import "PlayerHolder.h"
#import "countUpTimer.h"
#import "PUSHMultiPlayerGameOverViewController.h"
@interface PUSHMultiPlayerGameModeViewController (){
    UIImage *regularImage;
    UIImage *ultimatumImage;
    int currentGame;
    int rank;
    int theScore;
    BOOL gameHasStarted;
    BOOL shouldshake;
    BOOL canendgame;
    BOOL isgameOver;
    InGameOpponents  *opponentHolder;
    countUpTimer *cUpTimer;
    PUSHMultiPlayerGameOverViewController *gOver;
}
@end

@implementation PUSHMultiPlayerGameModeViewController
@synthesize game_circle = gc;
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
    regularImage = [UIImage imageNamed:@"fourplayerroyal"];
    ultimatumImage = [UIImage imageNamed:@"fourplayerdark_2x_360"];
    self.circle_holder.layer.cornerRadius = 80.0f;
    gc.layer.cornerRadius = 80.0f;
    self.circle_holder.clipsToBounds = YES;
    self.circle_holder.layer.borderWidth = 1.0;
    self.circle_holder.layer.borderColor = [UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1].CGColor;
    gc.delegate = self;
    gc.canplay= YES;
    gc.outerView = self.circle_holder;
    gameHasStarted = NO;
    shouldshake = NO;
    theScore = 0;
    rank = 1000000000;
    [self.timeToStart setDefaults];
    self.score = 0;
    self.countUpTimer.hidden = YES;
    canendgame = YES;
    isgameOver=NO;
    
    cUpTimer = [[countUpTimer alloc]init];
    cUpTimer.delegate = self;
    //holder that holds your enemies' picture
    opponentHolder = [[InGameOpponents alloc]initWithFrame:CGRectMake(40,80, self.view.frame.size.width - 80, 100)];
    [self.view addSubview:opponentHolder];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


//when i have to shake
-(void)doUltimatumOperations
{
    shouldshake = YES;
    [opponentHolder setHidden:YES];
    [self.countUpTimer setHidden:YES];
    [self.ultimatumTimer setHidden:NO];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [self.topView setBackgroundColor:[UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:1] /*#e9e9e9*/];
             
                     }completion:^(BOOL finished) {
                         
                         [self.pushLogo setImage:ultimatumImage];
                        // [self.view setBackgroundColor:[UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:1] /*#e9e9e9*/];

                     }];
}

//going back to the regular game play

-(void)goBackToNormal
{
    //grey
    shouldshake = NO;
    [opponentHolder setHidden:NO];
    [self.circle_holder setHidden:NO];
    [self.pushLogo setImage:regularImage];
    [self.ultimatumTimer setHidden:YES];
   

    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [self.topView setBackgroundColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.125 alpha:1]];
                     }completion:^(BOOL finished) {
                         [self.circle_holder setHidden:NO];
                         
                     }];
}

//game screen turns red because game has ended
-(void)gameIsNowOver
{
    //grey
    shouldshake = NO;
    [opponentHolder setHidden:YES];
    [self.circle_holder setHidden:YES];
    [self.countUpTimer setHidden:YES];
    [self.ultimatumTimer setHidden:YES];
    
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [self.topView setBackgroundColor:[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1]];
       
                     }completion:^(BOOL finished) {
                         
                         [self.pushLogo setImage:regularImage];
                         
                     }];
}


//game circle delegate stuff
-(void)gameStarted
{
        NSLog(@"gameStarted");
}



-(void)gameEnded
{
    if(gameHasStarted)
    {
        self.game_circle.canplay = NO;
        self.game_circle.ispressed = NO;
     
        NSLog(@"gameOver");
        [self UserHasLost];
        
    }
    else
    {
        //if we unpress the button and the game has not started we just re set the button so we can re  press it until game start
        gc.canplay = YES;
        self.game_circle.canplay = YES;
    }
    
}

//end gc delegate


//countuptimer delegate

-(void)timerHasTicked:(NSString*)countUpAmount
{
    [self.countUpTimer setText:countUpAmount];
}

// thise just sets all the views for when the game starts
-(void)startGameOperations
{
    theScore = 0;
    [self.xButton setHidden:YES];
    [self.holdToStartLabel setHidden:YES];
    [self.timeToStart setHidden:YES];
    [self.timeToStart setHidden:YES];
    [self.countUpTimer setHidden:NO];
    [self.holdToStartLabel setHidden:YES];
 //   [cUpTimer resetGameTimer];
 //   [cUpTimer startTimer];
    
}

//sets all the views for when the game ends
-(void)endGameOperations
{
        [cUpTimer stopTimer];
        [self.holdToStartLabel setHidden:YES];
        [self.micButton setHidden:YES];
        [self.game_circle setHidden:YES];
        [self.ultimatumTimer setHidden:YES];
        [self gameIsNowOver];
        [self.xButton setHidden:NO];
        [self.holdToStartLabel setHidden:YES];
        [self showGameOverScreen];
}


//do not need this for now
- (IBAction)xPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//dp not need this
-(void)startGameTimer
{

}

//if i touch the outer part of screen, pause the app or i dont shake I need to force game over
-(void)forceGameOver
{
    [self.game_circle solidifyCircle];
}


//toasts a message
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





//mic buttin was clicked
- (IBAction)micClicked:(id)sender {
    UIButton *b = sender;
    if(!b.isSelected)
    {
        [b setSelected:YES];
    }
    else
    {
        [b setSelected:NO];
    }

}


//game started methods

//this is the final countdown before the game begins
-(void)tickTimeStartTimer:(NSString *)text
{
    [self.timeToStart setText:text];
}


//the countdown to game has ended. checks if the player is pressing the button. if he is we start the game operations other wise run the user has lost function to end the game //
//etc
-(void)gameWillNowStart
{
    if(!gameHasStarted)
    {
         gameHasStarted = YES;
        
         if(gc.ispressed){
            [self startGameOperations];
         }
         else
         {
            //gc isn not presed
            [self UserHasLost];
         }
    }
    else
    {
      //the game has already started so skip all operations
    }
}

//after the game starts we check if the game has started other wise we start the game, if game is started we tick timer up
-(void)tickCountUpTimer:(NSString *)text
{
    if(gameHasStarted)
    {
        //dispatch_async(dispatch_get_main_queue(), ^{
            [self.countUpTimer setText:text];
        //});
    }
    else
    {
        [self gameWillNowStart];
    }
    
}


//player has left the game,
-(void)playerHasLeft:(NSString *)playerId
{
    
}

//function that gets called when we have to perform  shake operation to keep playing
-(void)startUltimatum
{
    if(!isgameOver)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
                shouldshake = YES;
                [self doUltimatumOperations];
        });
    }
}

//goes back to normal because we met the shake operation
-(void)ultimatumWasMetMulti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.countUpTimer setHidden:NO];
        [self goBackToNormal];
    });
   
}


//when the ultimatum timer has ticked.
-(void)ultimatumTimerTicked:(NSString *)text
{
      dispatch_async(dispatch_get_main_queue(), ^{
           NSString *newString = [text substringToIndex:[text length]-1];
          [self.ultimatumTimer countDown:newString];
    });
        

}

///I have lost some how so we are going to run the end game operations, solidify circle and tell the delegate that we have lost the game.
-(void)UserHasLost
{
    if(canendgame)
    {
        isgameOver = YES;
        [self.delegate userLost];
        canendgame = NO;
        [self endGameOperations];
        [gc solidifyCircle];
    }
 
}




- (IBAction)xButtonWasTapped:(id)sender {
    [self.delegate userWantsToLeave];
}



-(void)addOtherPlayersToGame:(NSMutableArray *)players
{
    
    opponentHolder.playerCount = [players count] - 1;
    
    NSLog(@" the count is %d",opponentHolder.playerCount);
    int i = 0;
    for(PlayerHolder *player in players)
    {
        
        if(i > 0)
        {
            [opponentHolder addPlayer:player.player :YES];
        }
        i++;
    }
    
}

-(void)playerhasLost:(NSDictionary *)player
{
    [opponentHolder playerLost:player];
}




-(void)showGameOverScreen
{
   
    //adds the multiplayer game screen to the screen two view.
    UIStoryboard *storyBoard = [self storyboard];
    gOver = [storyBoard instantiateViewControllerWithIdentifier:@"multiplayerGameOver"];
    gOver.delegate = self;
    gOver.view.alpha = 0;
    [self.view addSubview:gOver.view];
    [gOver didMoveToParentViewController:self];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         gOver.view.alpha = 1;
                     }completion:^(BOOL finished) {
                         
                     }];

}


//game over screen delegate
-(void)gOverMultiXpressed
{
    NSLog(@"DDDD");
    [self.delegate userWantsToLeave];
}

//end that delegate

@end
