//
//  PUSHOnePlayerModeViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "game_circle.h"
#import "UltimatumLabel.h"


@interface PUSHOnePlayerModeViewController : UIViewController

@property (strong, nonatomic) IBOutlet game_circle *game_circle;
@property (strong, nonatomic) IBOutlet UIButton *xButton;

@property (strong, nonatomic) IBOutlet UIView *circle_holder;

- (IBAction)xPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *encourageMentLabel;
@property (strong, nonatomic) IBOutlet UltimatumLabel *ultimatumLabel;

@property (strong, nonatomic) IBOutlet UILabel *gameTimer;

@end
