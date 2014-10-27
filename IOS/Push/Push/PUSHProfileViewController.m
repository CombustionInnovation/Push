//
//  PUSHProfileViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHProfileViewController.h"
#import "YCameraViewController.h"

@interface PUSHProfileViewController ()
{
    int currentpage;
    BOOL isFirstTime;
}

@end

@implementation PUSHProfileViewController

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
    [self.view bringSubviewToFront:self.proTopHolder];
    // Do any additional setup after loading the view.
    [self.propic.layer setCornerRadius:self.propic.frame.size.height/2];
    
    isFirstTime = YES;
    currentpage =0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *overall_score = [defaults objectForKey:@"overall_score"];
    NSString *overall_time = [defaults objectForKey:@"overall_time"];
    NSString *highest_rank = [defaults objectForKey:@"highest_rank"];
    NSString *best_score = [defaults objectForKey:@"best_score"];
    NSString *best_game_time = [defaults objectForKey:@"best_game_time"];
    NSString *total_games = [defaults objectForKey:@"total_games"];
    NSString *total_wins = [defaults objectForKey:@"total_wins"];
    NSString *total_losses = [defaults objectForKey:@"total_losses"];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *picture = [defaults objectForKey:@"picture"];
    NSString *best_game_played_date = [defaults objectForKey:@"best_game_played_date"];
    
    [self.agoLabel setText:[NSString stringWithFormat:@"%@",best_game_played_date]];
    [self.myUsername setText:username];
    [self.btime setText:[NSString stringWithFormat:@"%@",best_game_time]];
     [self.bestTimeLabel setText:[NSString stringWithFormat:@"%@",best_game_time]];
    [self.bestRankLabel setText:[NSString stringWithFormat:@"%@",highest_rank]];
    [self.branklabel setText:[NSString stringWithFormat:@"%@",highest_rank]];
    [self.myBestTIme setText:[NSString stringWithFormat:@"%@",best_game_time]];
    [self.myRank setText:[NSString stringWithFormat:@"%@",highest_rank]];
    [self.lossCountLabel setText:[NSString stringWithFormat:@"%@",total_losses]];
    [self.winCountLabel setText:[NSString stringWithFormat:@"%@",total_wins]];
    [self.gamesPLayedLabnel setText:[NSString stringWithFormat:@"%@ games-%@",total_games,overall_time]];
    [self.propic setClipsToBounds: YES];
    
    [self.propic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?width=300&height=300",picture]]
                  placeholderImage:[UIImage imageNamed:@"userpic@2x"]];
    

    [self.view bringSubviewToFront:self.pageIndicators];
    //page stuff
    [self.pageIndicators setEnabled:NO];
    [self.pageIndicators setNumberOfPages:2];
    
    //scrollview
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2,self.view.frame.size.height);
    self.scrollView.delegate = self;
    
    [self.pageTwo setFrame:CGRectMake(self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height-33)];

    UITapGestureRecognizer *takePicRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePic)];
    takePicRec.numberOfTapsRequired = 1;
    takePicRec.delegate = self;
    [self.propic addGestureRecognizer:takePicRec];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    if(isFirstTime)
    {
        [self doOpeningAnimations];
        isFirstTime = NO;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageIndicators.currentPage = page;
    currentpage = page;
    
}

//animate profile in

-(void)doOpeningAnimations
{
    NSArray *labels = [[NSArray alloc]init];
    labels = @[self.branklabel,self.btime,self.rlabel,self.tlabel,self.agolabel];
    
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                            [self.xbutton setFrame:CGRectMake(self.xbutton.frame.origin.x,self.xbutton.frame.origin.y + 40, self.xbutton.frame.size.width, self.xbutton.frame.size.height)];
                            [self.proTopHolder setFrame:CGRectMake(self.proTopHolder.frame.origin.x,0, self.proTopHolder.frame.size.width, 200)];
                            //     [self.propic setFrame:CGRectMake(self.propic.frame.origin.x-30, 17, self.propic.frame.size.width+60, self.propic.frame.size.height+60)];
                        
                            self.propic.transform = CGAffineTransformMakeScale(1.80f, 1.80f);
                     
                         for(UILabel *l in labels)
                         {
                             [l setAlpha:0];
                         }
                         
                            [self.nameLabel setFrame:CGRectMake(self.nameLabel.frame.origin.x, 157, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
                         
                     
                         
                     }completion:^(BOOL finished) {
                   
                   
                         
                     }];
}






- (IBAction)xButtonPressed:(id)sender
{
    [self doGoodByeAnimations];
}

-(void)doGoodByeAnimations
{
    NSArray *labels = [[NSArray alloc]init];
    labels = @[self.branklabel,self.btime,self.rlabel,self.tlabel,self.agolabel];
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [self.xbutton setFrame:CGRectMake(self.xbutton.frame.origin.x,self.xbutton.frame.origin.y -40, self.xbutton.frame.size.width, self.xbutton.frame.size.height)];
                         [self.proTopHolder setFrame:CGRectMake(self.proTopHolder.frame.origin.x,0, self.proTopHolder.frame.size.width, 160)];
                     //    [self.propic setFrame:CGRectMake(self.propic.frame.origin.x+30, 42, self.propic.frame.size.width-60, self.propic.frame.size.height-60)];
                    //       [self.propic.layer setCornerRadius:self.propic.frame.size.height/2];
                          self.propic.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         //   self.propic.transform = CGAffineTransformMakeScale(1.4f, 1.4f);
                         for(UILabel *l in labels)
                         {
                             [l setAlpha:1];
                         }
                         
                         [self.nameLabel setFrame:CGRectMake(self.nameLabel.frame.origin.x, 0, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height)];
                         
                         
                         
                     }completion:^(BOOL finished) {
                         //     [self performSecondAnimation];
                         
                         [self dismissViewControllerAnimated:NO completion:nil];
                         
                     }];
}


#pragma mark - Button clicks

- (void)takePic
{
    YCameraViewController *camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
    camController.delegate=self;
    [self presentViewController:camController animated:YES completion:^{
        // completion code
        NSLog(@"@DDDDDD");
    }];
}


#pragma mark - YCameraViewController Delegate
- (void)didFinishPickingImage:(UIImage *)image{
    [self.propic setImage:image];
    UploadPhoto *up = [[UploadPhoto alloc]init];
    up.delegate = self;
    [up uploadPhoto:image];
}

- (void)yCameraControllerdidSkipped{
 //   [self.propic setImage:nil];
}

- (void)yCameraControllerDidCancel{
    
}



//upload photos delegate

-(void)willBeginToUploadImage
{
   [MBProgressHUD showHUDAddedTo:self.view animated:YES];

 
}
-(void)imageUploadedSuccessful:(NSString *)pictureurl
{
    UIImage *im = self.propic.image;
    [self.delegate didChangeProfilePicture:im];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)UploadPhotoDidFail
{
    [self showAlert:@"Upload Failed!"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//end upload photo delegate

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

@end
