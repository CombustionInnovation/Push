//
//  PUSHMultiPlayerLobbyViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SIOSocket/SIOSocket.h>


@interface PUSHMultiPlayerLobbyViewController : UIViewController
- (IBAction)backPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *playerHolder;
@property(nonatomic,assign)NSInteger gameType;
@property (strong, nonatomic) IBOutlet UIImageView *gameImage;
-(void)setG :(NSInteger)ty;
@property (strong, nonatomic) IBOutlet UIView *redTabHolder;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property(strong,nonatomic)SIOSocket *socket;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *screenOne;
@property (strong, nonatomic) IBOutlet UIView *screenTwo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
