//
//  PUSHMultiPlayerGameOverViewController.h
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gOverMultiDelegate.h"


@interface PUSHMultiPlayerGameOverViewController : UIViewController{
    id<gOverMultiDelegate>delegate;
}
- (IBAction)littleXpressed:(id)sender;

@property(nonatomic,weak)id delegate;
@property (strong, nonatomic) IBOutlet UIImageView *enourageMentImage;
-(void)setGameOverImage:(NSInteger)score;

@end
