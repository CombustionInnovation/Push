//
//  InGameOpponents.m
//  Push
//
//  Created by Daniel Nasello on 10/2/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "InGameOpponents.h"
#import "PlayerHolder.h"

@implementation InGameOpponents

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.playerArray = [[NSMutableArray alloc]init];
        [self setClipsToBounds:YES];
        [self.parentView.layer setAnchorPoint:CGPointMake(0.5,0)];
        self.rec = self.parentView.bounds;
    }
    return self;
}





-(void)addPlayer:(NSDictionary *)player :(BOOL)animated
{
    NSInteger index = [self.playerArray count];
    int width = [self getWidth];
    int j = [self getOffset:index];
    int top = [self getTop:index];
    
    PlayerHolder *p = [[PlayerHolder alloc]initWithFrame:CGRectMake( j, top, width, 75)];
    [self.playerArray addObject:p];
    
    [self addSubview:p];
    [p setPLayerStats:player];
    [p.personName setFrame:CGRectMake(0, 52, p.frame.size.width,20)];
    [p.im setFrame:CGRectMake((p.frame.size.width/2 - 25), 0, 50, 50)];

    
    if(animated)
    {
        [p setAlpha:0.0f];
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             [p setAlpha:1.0f];
                         }completion:^(BOOL finished) {
                             
                         }];
        
    }
    
}


-(int)getOffset:(NSInteger )index
{
    int offset = (self.frame.size.width / self.playerCount )* index;
    return offset;
}


-(int)getTop:(NSInteger)index;
{
    int offset = 10;
    return offset;
}


-(int)getWidth
{
    int width = self.frame.size.width / self.playerCount;
    return width;
}


//removes a player
-(void)removePlayer:(NSString *)playerId :(BOOL)animated;
{
    for(PlayerHolder *p in [self.playerArray copy])
    {
        if([[p getPlayerId] isEqualToString:playerId])
        {
            //  p.transform = p.transform;
            //   p.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
            [self.playerArray removeObject:p];
            if(animated)
            {
                [UIView animateWithDuration:0.2
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^ {
                                     [p setAlpha:0.0f];
                                 }completion:^(BOOL finished) {
                                     [p removeFromSuperview];
                                     
                                 }];
            }
            else
            {
                [p removeFromSuperview];
            }
        }
        
    }
    
    [self fixLayoutViews:animated];
    
    
}


-(void)fixLayoutViews:(BOOL)animated
{
    int ind = 0;
    for(PlayerHolder *p in [self.playerArray copy])
    {
        int width = [self getWidth];
        int j = [self getOffset:ind];
        int top = [self getTop:ind];
        
        if(animated)
        {
            
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^ {
                                 [p setFrame:CGRectMake((100) * j, top, width, 75)];
                             }completion:^(BOOL finished) {
                             }];
        }
        else
        {
            [p setFrame:CGRectMake((100) * j, top, width, 75)];
        }
        ind++;
        
    }
}


-(void)playerLost:(NSDictionary *)playerInfo
{
    NSString *playerID = [playerInfo objectForKey:@"player_gone"];
    
    NSLog(@" the player is %@", playerID);
    NSString *position = [playerInfo objectForKey:@"position"];
    for(PlayerHolder *p in [self.playerArray copy])
    {
            if([[p getPlayerId] intValue] == [playerID intValue])
            {
                [p playerHasLost:position];
            }
        
    }
    
    
}


@end
