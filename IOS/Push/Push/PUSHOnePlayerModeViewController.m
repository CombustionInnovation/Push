//
//  PUSHOnePlayerModeViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHOnePlayerModeViewController.h"
#import "countUpTimer.h"
#import "Ultimatum.h"
#import "prettyTimer.h"
#import "MBProgressHud.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "PUSHOnePlayerGameOverViewController.h"
@interface PUSHOnePlayerModeViewController (){
    countUpTimer *cUpTimer;
    int currentGame;
    Ultimatum *shakeUltimatum;
    UIImage *regularImage;
    UIImage *ultimatumImage;
    prettyTimer *PrettyTimer;
    int rank;
    int theScore;
    PUSHOnePlayerGameOverViewController *gOverScreen;
    BOOL shouldshake;
}


@end


@implementation PUSHOnePlayerModeViewController
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

    shouldshake = NO;
    theScore = 0;
    
    rank = 100000000000000000;
    
    regularImage = [UIImage imageNamed:@"header"];
    ultimatumImage = [UIImage imageNamed:@"iheader"];
    
    PrettyTimer  = nil;
    currentGame = nil;
    

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.gameTimer setHidden:YES];
     [self.ultimatumLabel setHidden:YES];
    //[UIColor colorWithRed:0.141 green:0.82 blue:0.2 alpha:1] /*#24d133*/
    //[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1] red
    
    self.circle_holder.layer.cornerRadius = 80.0f;
    self.game_circle.layer.cornerRadius = 80.0f;
    self.circle_holder.clipsToBounds = YES;
    self.circle_holder.layer.borderWidth = 1.0;
    self.circle_holder.layer.borderColor = [UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1].CGColor;
    gc.delegate = self;
    gc.canplay= YES;
    gc.outerView = self.circle_holder;
    [gc setOuterViews:self.circle_holder];
    NSString *timeLeft = @"45";
    [self.ultimatumLabel countDown:[NSString stringWithFormat:@"0:%@",timeLeft]];
    cUpTimer = [[countUpTimer alloc]init];
    cUpTimer.delegate = self;
    
    
    
    UIStoryboard *storyBoard = [self storyboard];
    gOverScreen = [storyBoard instantiateViewControllerWithIdentifier:@"onePlayerGameOver"];
    gOverScreen.delegate = self;
    [self.view addSubview:gOverScreen.view];
    [gOverScreen didMoveToParentViewController:self];
    gOverScreen.view.alpha = 0;
    [gOverScreen.view setHidden:YES];
    
    
 //   UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
  //  longpress.minimumPressDuration = .001;
  //  [self.view addGestureRecognizer:longpress];
}


-(void)didLongPress:(UITapGestureRecognizer *)touch
{
    if(touch.view == self.game_circle || touch.view == self.circle_holder || touch.view == self.xButton)
    {
        
        
    }
    else
    {
    //    [self forceGameOver];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






-(void)doUltimatumOperations
{
    shouldshake = YES;
    PrettyTimer = [[prettyTimer alloc]init];
    PrettyTimer.delegate = self;
    [PrettyTimer startTimer];
    [self.ultimatumLabel setHidden:NO];
    [self.gameTimer setHidden:YES];
    
    
    //off white color for the ultimatum
    [self.view setBackgroundColor:[UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:1] /*#e9e9e9*/];

    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                            [self.view setBackgroundColor:[UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:1] /*#e9e9e9*/];
                           [self.gameTimer setTextColor:[UIColor blackColor]];
                     }completion:^(BOOL finished) {
                         
                         [self.headerImageView setImage:ultimatumImage];
                     }];
}


-(void)goBackToNormal
{
    //grey
    
     [self.circle_holder setHidden:NO];
     [self.headerImageView setImage:regularImage];
     [self.ultimatumLabel setHidden:YES];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [self.view setBackgroundColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.125 alpha:1]];
                     }completion:^(BOOL finished) {
                         
                         [self.circle_holder setHidden:NO];
                         
                     }];
}


-(void)undoScreenChange
{
    //grey
   [self.view setBackgroundColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.125 alpha:1]];
    
}

-(void)gameIsNowOver
{
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [self.view setBackgroundColor:[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1]];
                          [self.gameTimer setTextColor:[UIColor whiteColor]];
                     }completion:^(BOOL finished) {
                         
                         [self.headerImageView setImage:regularImage];
                         
                     }];
    
  
    
}


//game circle delegate stuff
-(void)gameStarted
{
     NSLog(@"gameStarted");
    [self startGameOperations];
    
}
-(void)gameEnded
{
    NSLog(@"gameOver");
    [self endGameOperations];
    
}

//end gc delegate


//countuptimer delegate

-(void)timerHasTicked:(NSString*)countUpAmount
{
    [self.gameTimer setText:countUpAmount];
}


-(void)tenSecondInterVal
{
    int score = [cUpTimer getFinalScore];
    NSString  *mytime = [cUpTimer getFinalTime];
    int currgame = currentGame;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    NSString *myscore = [NSString stringWithFormat:@"%d",score];
    NSString *mygame = [NSString stringWithFormat:@"%d",currgame];
    NSLog(@"%d",score);

     NSDictionary *params = @{
                                @"user_id":[NSString stringWithFormat:@"%@",user_id],
                                @"unique_game":[NSString stringWithFormat:@"%@",mygame],
                                @"time_past":[NSString stringWithFormat:@"%@",mytime],
                                @"score":[NSString stringWithFormat:@"%@",myscore],
                                @"type":[NSString stringWithFormat:@"%@",@"0"],
                              };
     
     
     
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     [manager POST:@"http://combustionlaboratory.com/push/php/liveGame.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"status"];
          NSString *myrank = responseObject[@"rank"];
        if ([status isEqualToString:@"one"])
        {
          
        }
        else
        {

        }
         if([myrank intValue] < rank)
         {
            [self toastMessage:[NSString stringWithFormat:@"Your game is %@ in the world!",myrank]];
             
             rank = [myrank intValue];
         }
         
         
         [gOverScreen setRank:rank :score];
         
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       

    }];

}
///end countup timer delegate
///utlimatum delegate

-(void)ultimatumHasFailed
{
    [self forceGameOver];
}
-(void)ultimatumHasStarted
{
    [self performScreenChange];

}


-(void)performScreenChange
{
    [self doUltimatumOperations];
}
//end ultimatum delegate


-(void)startGameOperations
{
    theScore = 0;
    [self.gameTimer setHidden:NO];
    shakeUltimatum = [[Ultimatum alloc]init]; 
    shakeUltimatum.delegate =self;
    [shakeUltimatum setNewUltimatum];
    currentGame =[[NSDate date] timeIntervalSince1970];
    [self.xButton setHidden:YES];
    [self.gameTimer setHidden:NO];
    [self startGameTimer];
    
}


-(void)endGameOperations
{
    if([cUpTimer getFinalScore]>9)
    {
        [self tenSecondInterVal];
    }
    
    if(PrettyTimer)
    {
        [PrettyTimer endTimer];
    }
    [gOverScreen setGameOverImage:[cUpTimer getFinalScore]];
    [gOverScreen setTimeField:[cUpTimer getFinalTime]];
    [gOverScreen setRank:rank:[cUpTimer getFinalScore]];
    [gOverScreen showView];
    [self.circle_holder setHidden:YES];
    PrettyTimer = nil;
    [self.gameTimer setHidden:YES];
    [self.ultimatumLabel setHidden:YES];
    [shakeUltimatum stopInterval];
    shakeUltimatum = nil;
    [self gameIsNowOver];
    int score = [cUpTimer getFinalScore];
     NSString *time = [cUpTimer getFinalTime];
    [self.gameTimer setText:@"00:00:00"];
    [self.xButton setHidden:NO];
    [self.gameTimer setHidden:YES];
    [cUpTimer stopTimer];

}

- (IBAction)xPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)startGameTimer
{
    [cUpTimer resetGameTimer];
    [cUpTimer startTimer];
}

//if i touch the outer part of screen, pause the app or i dont shake I need to force game over
-(void)forceGameOver
{
    [self.game_circle solidifyCircle];
}


//pretty timer delegatge

-(void)prettyTimerHasEnded
{
    //failed get rid of shake events force loose game
    [self endGameOperations];
}

-(void)ptimerHasTicked:(NSString*)timeLeft;
{
    [self.ultimatumLabel countDown:[NSString stringWithFormat:@"0:%@",timeLeft]];
}
//end pretty timer delegate


//this resets teh screen so we can play again
-(void)resetGameStuff
{
    self.game_circle.canplay = YES;
    [self goBackToNormal];
}





//game over screen delegate
-(void)goBackToLanding
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)resetGamePlay
{
    [gOverScreen hideView];
    [self resetGameStuff];
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



- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        if(shouldshake)
        {
            
            [self metUlt];
            shouldshake = NO;
            [self goBackToNormal];
            [PrettyTimer endTimer];
            PrettyTimer = nil;
            [shakeUltimatum ultimatumWasMet];
        }
        // your code
    
    }
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(shouldshake)
    {
        [self metUlt];
        shouldshake = NO;
        [self goBackToNormal];
        [PrettyTimer endTimer];
        PrettyTimer = nil;
        [shakeUltimatum ultimatumWasMet];
    }
    
}
-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
    
}


-(void)metUlt
{
    [self.gameTimer setTextColor:[UIColor whiteColor]];
    [self.gameTimer setHidden:NO];
}
@end
