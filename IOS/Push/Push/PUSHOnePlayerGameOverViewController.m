//
//  PUSHOnePlayerGameOverViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHOnePlayerGameOverViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
@interface PUSHOnePlayerGameOverViewController ()

@end

@implementation PUSHOnePlayerGameOverViewController

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
 
}


-(void)updateStats
{
   
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    
     
    
    NSDictionary *params = @{
                             @"user_id":[NSString stringWithFormat:@"%@",user_id],

                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/push/php/userInfo.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        

        
        NSString *overall_score = responseObject[@"allScore"];
        NSString *overall_time = responseObject[@"allTime"];
        NSString *highest_rank = responseObject[@"rank"];
        NSString *best_score = responseObject[@"best_score"];
        NSString *best_game_time = responseObject[@"time_passed"];
        NSString *total_games = responseObject[@"totalGames"];
        NSString *total_wins = responseObject[@"wins"];
        NSString *total_losses = responseObject[@"lost"];
        NSString *best_game_played_date = responseObject[@"best_game_played_date"];
        NSString *push_notification = responseObject[@"push_notification"];
        NSString *private = responseObject[@"private"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[self ifNullString:overall_score] forKey:@"overall_score"];
        [defaults setObject:overall_time forKey:@"overall_time"];
        [defaults setObject:highest_rank forKey:@"highest_rank"];
        [defaults setObject:best_score forKey:@"best_score"];
        [defaults setObject:best_game_time forKey:@"best_game_time"];
        [defaults setObject:total_games forKey:@"total_games"];
        [defaults setObject:total_wins forKey:@"total_wins"];
        [defaults setObject:total_losses forKey:@"total_losses"];
         [defaults setObject:best_game_played_date forKey:@"best_game_played_date"];
        [defaults setObject:push_notification forKey:@"push_notification"];
        [defaults setObject:private forKey:@"private"];
        
        [defaults synchronize];
        
     
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 

    }];

}

-(NSString *)ifNullString:(NSString *)stringCheck
{
        NSString *retval =@"0";
    
    if(!stringCheck || stringCheck == nil)
    {
        
    }
    else
    {
        retval = stringCheck;
    }
    
    return retval;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)xButtonPressed:(id)sender {
    [self.delegate goBackToLanding];
}
- (IBAction)replayButtonPressed:(id)sender {
    [self.delegate resetGamePlay];
}

- (IBAction)shareButtonPressed:(id)sender {
}

-(void)showView
{
    [self updateStats];
    [self.view setHidden:NO];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [self.view setAlpha:1];
                     }completion:^(BOOL finished) {
           
                     }];
}

-(void)hideView
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [self.view setAlpha:0];
                     }completion:^(BOOL finished) {
                             [self.view setHidden:YES];
                         UIImage *imglink =[UIImage imageNamed:@"welcometopush"];
                         [self.encouragementImage setImage:imglink];
                         [self.endingRank setText:@"*0*"];
                         [self.endingTime setText:@"0"];
                     }];
}



-(void)setGameOverImage:(NSInteger)score
{
    
    UIImage *imglink =[UIImage imageNamed:@"welcometopush"];
 
    if(score < 10)
    {
        imglink  = [UIImage imageNamed:@"tryagain"];
    }
    else if(score>9 && score<30)
    {
        imglink   = [UIImage imageNamed:@"wompwomp"];
    }
    else if(score >29 && score < 140)
    {
        
        imglink   = [UIImage imageNamed:@"welcometopush"];
    }
    else if(score>139 && score <400)
    {
        imglink   = [UIImage imageNamed:@"lookinggood"];
    }
    else if(score>399 && score <600)
    {
        imglink   = [UIImage imageNamed:@"notbad"];
    }
    else if(score>599 && score<900)
    {
        imglink   = [UIImage imageNamed:@"awesomejob"];
    }
    
    else if(score>899 && score <1800)
    {
        imglink   = [UIImage imageNamed:@"professionalpusher"];
    }
    else if(score>1799 && score<3600)
    {
        imglink   = [UIImage imageNamed:@"professionalpusher"];
    }
    else if(score>3599 && score<7200)
    {
        imglink   = [UIImage imageNamed:@"welcometomtolympus"];
    }
    else if(score>7199 && score<14400)
    {
        imglink   = [UIImage imageNamed:@"highlydedicated"];
    }
    else if(score>13999 && score<28000)
    {
        imglink   = [UIImage imageNamed:@"mindovermatter"];
    }
    else
    {
        imglink   = [UIImage imageNamed:@"mindovermatter"];
    }
    
    [self.encouragementImage setImage:imglink];
}
-(void)setTimeField:(NSString*)time
{
    [self.endingTime setText:time];
}
-(void)setRank:(NSInteger)rank:(NSInteger)score
{
    if(score<14)
    {
        [self.endingRank setText:@"Too Low to rank!"];
    }
    else
    {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:rank]];
        [self.endingRank setText:[NSString stringWithFormat:@"*%@*",formatted]];
    }

}



//take a picture of the current view
+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


@end
