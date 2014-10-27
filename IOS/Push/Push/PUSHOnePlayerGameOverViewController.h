//
//  PUSHOnePlayerGameOverViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnePlayerProtocol.h"
@protocol OnePlayerProtocol <NSObject>
-(void)goBackToLanding;
-(void)resetGamePlay;
@end

@interface PUSHOnePlayerGameOverViewController : UIViewController{
    id<OnePlayerProtocol>delegate;
}
@property(weak,nonatomic)id delegate;
@property (strong, nonatomic) IBOutlet UIButton *xButton;
- (IBAction)xButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *encouragementImage;
@property (strong, nonatomic) IBOutlet UILabel *endingTime;
@property (strong, nonatomic) IBOutlet UILabel *endingRank;
- (IBAction)replayButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
-(void)hideScreenAndResetValues;
-(void)setGameOverImage:(NSInteger)score;
-(void)setTimeField:(NSString*)time;
-(void)setRank:(NSInteger)rank:(NSInteger)score;
-(void)showView;
-(void)hideView;

@end
