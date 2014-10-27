//
//  LeaderboardTabBar.m
//  Push
//
//  Created by Daniel Nasello on 9/13/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "LeaderboardTabBar.h"

@implementation LeaderboardTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createTabs];
    }
    return self;
}

-(void)createTabs
{
    self.toggleButtons = [[NSMutableArray alloc]init];
    self.currentSelected = 0;
    
    UIImage *pressed = [self imageWithColor:[UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:1] /*#e9e9e9*/];
     UIImage *pressedinter = [self imageWithColor:[UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:0.8] /*#e9e9e9*/];
    UIImage *notpressed = [self imageWithColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.125 alpha:1] /*#202020*/];
    
    NSArray *tabWords = [[NSArray alloc]init];
    tabWords = @[@"Global Leaderboards",@"Friend Leaderboards"];
    int i = 0;
    for(NSString *label in tabWords)
    {
   
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake((self.frame.size.width/2) * i, 0, self.frame.size.width/2, self.frame.size.height);
        b.titleLabel.font = [UIFont systemFontOfSize:15];
        b.clipsToBounds = YES;
        b.tag = i;
        b.layer.cornerRadius = 0.0f;
        [b setAttributedTitle:[[NSAttributedString alloc] initWithString:[tabWords objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]  forState:UIControlStateSelected];
        [b setAttributedTitle:[[NSAttributedString alloc] initWithString:[tabWords objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}]  forState:UIControlStateHighlighted];
        [b setAttributedTitle:[[NSAttributedString alloc] initWithString:[tabWords objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]  forState:UIControlStateNormal];
         [b addTarget:self action:@selector(toogleTheButton:) forControlEvents:UIControlEventTouchUpInside];
        [b.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0]];
        [b setBackgroundImage:notpressed forState:UIControlStateNormal];
        [b setBackgroundImage:pressedinter forState:UIControlStateHighlighted];
        [b setBackgroundImage:pressed forState:UIControlStateSelected];
 
        [self.toggleButtons addObject:b];
        b.layer.cornerRadius = 0.0f;
        
        [self addSubview:b];
        
        i++;
    }
    
    UIButton *initial = [self.toggleButtons objectAtIndex:0];
    initial.selected = YES;
    
    
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



-(void)toogleTheButton:(id)sender
{
    UIButton *b = (UIButton*)sender;
    if(b.tag !=self.currentSelected)
    {
        UIButton *goButton = [self.toggleButtons objectAtIndex:self.currentSelected];
        goButton.selected = NO;
        b.selected = YES;
        self.currentSelected = b.tag;
     //do delegation to let the controller know that the index of the tab changed.
        [self.delegate tabWasChanged:b.tag];
    }
}


@end
