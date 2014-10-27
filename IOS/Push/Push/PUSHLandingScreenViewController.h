//
//  PUSHLandingScreenViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LandingScreenDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
@protocol LandingScreenDelegate <NSObject>
-(void)logoutOperationsLP;
@end

@interface PUSHLandingScreenViewController : UIViewController{
    id<LandingScreenDelegate>delegate;
}
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UIButton *soloButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *oneVoneButton;
@property (strong, nonatomic) IBOutlet UIButton *fourPlayerButton;
- (IBAction)soloButtonPressed:(id)sender;
- (IBAction)oneVonePressed:(id)sender;
- (IBAction)fourPlayerPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIPageControl *pageIndicators;
- (IBAction)settingsPressed:(id)sender;
- (IBAction)leaderboardsButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *sideOne;
@property (strong, nonatomic) IBOutlet UIView *sideTwo;
@property (strong, nonatomic) IBOutlet UIView *profileTopHolder;
@property (strong, nonatomic) IBOutlet UIView *leaderboardTabHolder;
@property (strong, nonatomic) IBOutlet UILabel *myUsername;
@property (strong, nonatomic) IBOutlet UILabel *bestTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *bestRankLabel;
@property (strong, nonatomic) IBOutlet UILabel *longagoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myPicture;
@property (strong, nonatomic) IBOutlet UIImageView *userIcon;
@property (strong, nonatomic) IBOutlet UIView *tripleTabHolder;

@end
