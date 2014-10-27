//
//  FourPlayerManager.m
//  Push
//
//  Created by Daniel Nasello on 9/18/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "FourPlayerManager.h"
#import "PlayerHolder.h"
@implementation FourPlayerManager



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    //    [self setBackgroundColor: [UIColor colorWithRed:0.125 green:0.125 blue:0.125 alpha:1]];
         self.playerArray = [[NSMutableArray alloc]init];
         [self setClipsToBounds:YES];
         [self.parentView.layer setAnchorPoint:CGPointMake(0.5,0)];
         self.rec = self.parentView.bounds;
         self.playerIds = [[NSMutableArray alloc]init];
        
    }
    return self;
}



-(void)createLayout
{
 /*
    int j = 0;
    for(int i = 0;i<self.mode;i++)
    {
        int top = 0;
        if(i>1)
        {
            top = 75;
        }
        if(i == 2)
        {
            j = 0;
        }
     
        int width = 160;
        if(self.mode > 1)
        {
            width = 160;
        }
        else
        {
            width = 320;
        }
        
        PlayerHolder *p = [[PlayerHolder alloc]initWithFrame:CGRectMake((width) * j, top, width, 75)];
        p.backgroundColor = [UIColor redColor];
        [self addSubview:p];
        [self.playerArray addObject:p];
        NSLog(@"DD");
        
        j++;
    }
    */
    
}

-(void)addPlayer:(NSDictionary *)player :(BOOL)animated
{
    
        NSString *player_id_other = [player objectForKey:@"user_id"];
        if(![self containsPlayer:player_id_other])
        {
            [self.playerIds addObject:player_id_other];
            NSInteger index = [self.playerArray count];
            int width = [self getWidth];
            int j = [self getOffset:index];
            int top = [self getTop:index];
            
            PlayerHolder *p = [[PlayerHolder alloc]initWithFrame:CGRectMake((100) * j, top, width, 75)];
            [self.playerArray addObject:p];
    
            [self addSubview:p];
            [p setPLayerStats:player];
    
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
    
}


-(int)getOffset:(NSInteger )index
{
   // NSInteger index = [self.playerArray count];
    
    int offset = 1;
    if(index == 0 || index == 2)
    {
        offset = 0;
    }
    
    return offset;
}


-(int)getTop:(NSInteger)index;
{
 
    
    int offset = 90;
    if(index < 2)
    {
        offset = 20;
    }
    
    return offset;
}


-(int)getWidth
{
    int width = 160;
    if(self.mode > 1)
    {
        width = 160;
    }
    else
    {
        width = 320;
    }
    
    return width;
}


//removes a player
-(void)removePlayer:(NSString *)playerId :(BOOL)animated;
{
    for(PlayerHolder *p in [self.playerArray copy])
    {
        NSString *pid = [p getPlayerId] ;
        if([pid isEqualToString:playerId])
        {
            [self removePlayerFromParray:pid];
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



//iff lobby mode.... we run a diff set of rules

-(void)addPLayerLobby
{
    
}

-(void)removePlayerLobby:(NSString *)stringId;
{
    
}

-(void)fixLayoutViewsLobby
{
    
}


-(void)doLobbyAnimation
{
 

}
-(BOOL) containsPlayer:(NSString*)string
{
    for (NSString* str in [self.playerIds copy]) {
        if ([str isEqualToString:string])
            return YES;
    }
    return NO;
}


-(void)removePlayerFromParray:(NSString *)s
{
    
    for (NSString* str in [self.playerIds copy]) {
        if ([str isEqualToString:s])
        {
            [self.playerIds removeObject:str];
        }
    }

}


@end
