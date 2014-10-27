//
//  PUSHLandingScreenViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHLandingScreenViewController.h"
#import "PUSHSettingsViewController.h"
#import "LeaderboardTabBar.h"
#import "PUSHLeaderTableViewController.h"
#import "PUSHProfileViewController.h"
#import "PUSHOnePlayerModeViewController.h"
#import "PUSHMultiPlayerLobbyViewController.h"
#import "SlidingTabManager.h"
#import "GCHelper.h"
@interface PUSHLandingScreenViewController (){
    LeaderboardTabBar  *tabControl;
    NSArray *battleButtons;
    int currentpage;
    PUSHLeaderTableViewController *leaderList;
    SlidingTabManager *slideManager ;
    GCHelper *gameCenter;
}

@end

@implementation PUSHLandingScreenViewController

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
    
    self.navigationController.navigationBarHidden=YES;
    
    battleButtons = [[NSArray alloc]init];

    battleButtons = @[self.soloButton,self.fourPlayerButton,self.oneVoneButton];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *picture = [defaults objectForKey:@"picture"];

        [self.userIcon setClipsToBounds: YES];
        [self.userIcon.layer setCornerRadius:self.userIcon.frame.size.height/2];
        [self.userIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?width=300&height=300",picture]]
                placeholderImage:[UIImage imageNamed:@"userpic@2x"]];
    
    UIImage *notpressed = [self imageWithColor:[UIColor colorWithRed:0.694 green:0.141 blue:0.133 alpha:1]];
    UIImage *pressed = [self imageWithColor:[UIColor colorWithRed:0.392 green:0.051 blue:0.059 alpha:1]];
    for(UIButton *b in battleButtons)
    {
        b.titleLabel.font = [UIFont systemFontOfSize:15];
        b.clipsToBounds = YES;
        [b setBackgroundImage:notpressed forState:UIControlStateNormal];
        [b setBackgroundImage:pressed forState:UIControlStateHighlighted];
        [b setBackgroundImage:pressed forState:UIControlStateSelected];
        b.layer.cornerRadius = 6.0f;

    }
    
    tabControl = [[LeaderboardTabBar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.leaderboardTabHolder.frame.size.height)];
    tabControl.delegate = self;
    [self.leaderboardTabHolder addSubview:tabControl];
    
 //    [self.soloButton setImage: pressed forState:UIControlStateHighlighted];
    
    //highlight red  [UIColor colorWithRed:0.392 green:0.051 blue:0.059 alpha:1] /*#640d0f*/
    //reg red [UIColor colorWithRed:0.694 green:0.141 blue:0.133 alpha:1] /*#b12422*/
    
    
    //page stuff
    [self.pageIndicators setEnabled:NO];
    [self.pageIndicators setNumberOfPages:2];
    
    //scrollview
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2,self.view.frame.size.height);
    self.scrollView.delegate = self;
    
    
    [self.sideTwo setFrame:CGRectMake(self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height)];
    
    
    UITapGestureRecognizer *endkeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topHolderTapped)];
    endkeyboard.numberOfTapsRequired = 1;
    endkeyboard.delegate = self;
    [self.profileTopHolder addGestureRecognizer:endkeyboard];
    
    //listview of the leaderboards thats a child view controller.
    leaderList  = [self.childViewControllers objectAtIndex:0];
    
    
    //tripleTabHolder
    NSArray *labs = [[NSArray alloc]init];
    labs  = @[@"Most Charitable",@"Best Game",@"Overall Time"];
    slideManager = [[SlidingTabManager alloc]initWithFrame:self.tripleTabHolder.bounds];
    slideManager.numberOfTabs = 3;
    slideManager.labels = labs;
    [slideManager createTabs];
    [self.tripleTabHolder addSubview:slideManager];
    
    gameCenter = [[GCHelper alloc]init];
    
    
    [self.sideTwo setClipsToBounds:YES];
    [self.sideOne setClipsToBounds:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setDefaults];
}


-(void)setDefaults
{
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
    
    [self.myUsername setText:username];
    [self.bestTimeLabel setText:[NSString stringWithFormat:@"%@",best_game_time]];
    [self.bestRankLabel setText:[NSString stringWithFormat:@"%@",highest_rank]];
    [self.longagoLabel setText:[NSString stringWithFormat:@"%@",best_game_played_date]];
    [self.userIcon setClipsToBounds: YES];
}



- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageIndicators.currentPage = page;
    currentpage = page;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *)imageWithColor:(UIColor *)color {
    //makes an image out of a UI color
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (IBAction)soloButtonPressed:(id)sender
{
    UIStoryboard *storyBoard = [self storyboard];
    PUSHOnePlayerModeViewController *onePlayer= [storyBoard instantiateViewControllerWithIdentifier:@"oneplayer"];
    onePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:onePlayer animated:YES completion:nil];

}
- (IBAction)oneVonePressed:(id)sender
{
    UIStoryboard *storyBoard = [self storyboard];
    PUSHMultiPlayerLobbyViewController *royal  = [storyBoard instantiateViewControllerWithIdentifier:@"mlm"];
    royal.gameType = 1;
    [royal setG:1];
    [self.navigationController pushViewController:royal animated:YES];
}

- (IBAction)fourPlayerPressed:(id)sender
{
    UIStoryboard *storyBoard = [self storyboard];
    PUSHMultiPlayerLobbyViewController *royal  = [storyBoard instantiateViewControllerWithIdentifier:@"mlm"];
    royal.gameType = 0;
    [royal setG:0];
    [self.navigationController pushViewController:royal animated:YES];

}

- (IBAction)settingsPressed:(id)sender {

        UIStoryboard *storyBoard = [self storyboard];
        PUSHSettingsViewController *settings= [storyBoard instantiateViewControllerWithIdentifier:@"settings"];
        [self presentViewController:settings animated:YES completion:nil];
        settings.delegate = self;
        //   [self.parentViewController.parentViewController.navigationController pushViewController:about animated:YES];


}

//settings delegate
-(void)userDidLogOut
{
    [self.delegate logoutOperationsLP];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//end setttings delegate

- (IBAction)leaderboardsButtonPressed:(id)sender
{
    
}




//delegate method for custom tab bar
-(void)tabWasChanged:(NSInteger)index
{
    
    [leaderList dataWillChange:index];
    
}

//tapped the top of the profileholder to get the rest of my profile

-(void)topHolderTapped
{
    UIStoryboard *storyBoard = [self storyboard];
    PUSHProfileViewController *profile= [storyBoard instantiateViewControllerWithIdentifier:@"profile"];
    profile.delegate = self;
    [profile.view setClipsToBounds:YES];
    [self presentViewController:profile animated:NO completion:nil];
   // [profile.view setFrame:self.profileTopHolder.frame];
    //[profile doOpeningAnimations];
}

//start profile delegate
-(void)didChangeProfilePicture:(UIImage *)image
{
    self.userIcon.image = image;
}
//end profile delegate

@end
