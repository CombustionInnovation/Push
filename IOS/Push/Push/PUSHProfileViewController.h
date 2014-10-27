//
//  PUSHProfileViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UploadPhotoProtocol.h"
#import "UploadPhoto.h"
#import "MBProgressHUD.h"
#import "ProfileProtocol.h"
@interface PUSHProfileViewController : UIViewController<UploadPhotoProtocol>{
    id<ProfileProtocol>delegate;
}
-(void)doOpeningAnimations;
@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UILabel *btime;
@property (strong, nonatomic) IBOutlet UILabel *tlabel;
@property (strong, nonatomic) IBOutlet UILabel *agolabel;
@property (strong, nonatomic) IBOutlet UILabel *branklabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabe;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *propic;
@property (strong, nonatomic) IBOutlet UIView *proTopHolder;
@property (strong, nonatomic) IBOutlet UIButton *xbutton;
- (IBAction)xButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *myUsername;
@property (strong, nonatomic) IBOutlet UILabel *bestTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *bestRankLabel;
@property (strong, nonatomic) IBOutlet UILabel *agoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myPicture;
@property (strong, nonatomic) IBOutlet UILabel *winCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *lossCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *myRank;
@property (strong, nonatomic) IBOutlet UILabel *myBestTIme;
@property (strong, nonatomic) IBOutlet UIView *pageOne;

@property (strong, nonatomic) IBOutlet UILabel *gamesPLayedLabnel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *pageTwo;
@property (strong, nonatomic) IBOutlet UIPageControl *pageIndicators;
@property (strong, nonatomic) IBOutlet UILabel *rlabel;
@end
