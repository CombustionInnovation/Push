//
//  PlayerHolder.m
//  Push
//
//  Created by Daniel Nasello on 9/18/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PlayerHolder.h"

@implementation PlayerHolder


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.player = [[NSDictionary alloc]init];
        self.im = [[UIImageView alloc]initWithFrame:CGRectMake(25, 0, 50, 50)];
        [self addSubview:self.im];
        self.im.layer.cornerRadius = 25.0f;
        self.im.layer.borderColor = [UIColor whiteColor].CGColor;
        self.im.layer.borderWidth = 1.0f;
        self.im.clipsToBounds = YES;
        self.personName = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 100,15)];
        [self.personName setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0]];
        [self.personName setTextColor:[UIColor whiteColor]];
        [self.im setContentMode:UIViewContentModeScaleAspectFill];
        [self.personName setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.personName];
        
    }
    return self;
}

-(void)setPLayerStats:(NSDictionary *)player
{
    self.player = player;

    NSString *username = [player objectForKey:(@"username")];
    NSString *picture = [player objectForKey:(@"picture")];
    [self.personName setText:username];
    
    [self.im sd_setImageWithURL:[NSURL URLWithString:picture]
             placeholderImage:[UIImage imageNamed:@"userpic"]];
    
}

-(NSString *)getPlayerId
{
    
        NSString *u_id = [self.player objectForKey:(@"user_id")];
    
        return u_id;
}

-(void)playerHasLost:(NSString *)position
{
    
    int pos = [position intValue];
    NSArray *places = [[NSArray alloc]init];
    places = @[[UIImage imageNamed:@"2ndplace"],
              [UIImage imageNamed:@"3rdplace"],
              [UIImage imageNamed:@"4thplace"]];


    
    UIImageView *playerLostImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,50,50,50)];
    self.im.clipsToBounds = YES;
    [playerLostImage setImage:[places objectAtIndex:pos-2]];
    [self.im addSubview:playerLostImage];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [playerLostImage setFrame:CGRectMake(0, 0, 50, 50)];
                     }completion:^(BOOL finished) {
                     }];
    
}



@end

