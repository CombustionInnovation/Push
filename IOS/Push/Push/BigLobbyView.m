
#import "BigLobbyView.h"
#import "PlayerHolder.h"

@implementation BigLobbyView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.125 alpha:1]];
        [self setDefaults];
        self.playerArray = [[NSMutableArray alloc]init];
        self.pids = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setDefaults
{
    
    UIImage *notpressed = [UIImage imageNamed:@"microphoneon"];
    UIImage *pressed = [UIImage imageNamed:@"microphonemute"];
    
    UIButton *micButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [micButton setFrame:CGRectMake(self.frame.size.width/2 - 15, self.frame.size.height-50, 30, 35)];
    [micButton setImage:notpressed forState:UIControlStateNormal];
    [micButton setImage:notpressed forState:UIControlStateHighlighted];
    [micButton setImage:pressed forState:UIControlStateSelected];
    [micButton addTarget:self
                  action:@selector(micButtonToggle:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:micButton];
    
    
    self.match_begins = [[ostMedium alloc]initWithFrame:CGRectMake(0, self.frame.size.height-150, self.frame.size.width, 20)];
    [self.match_begins setText:@"MATCH BEGINS IN:"];
    [self addSubview:self.match_begins];
    self.countDown = [[OstLabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-135, self.frame.size.width, 80)];
    [self.countDown setText:@"0:00"];
    [self addSubview:self.countDown];
}



-(void)micButtonToggle:(id)sender
{
    UIButton *b = sender;
    
    if(b.isSelected)
    {
         [b setSelected:NO];
    }
    else
    {
        [b setSelected:YES];
    }
}

-(void)addPlayer:(NSDictionary *)player
{
    NSString *player_id_other = [player objectForKey:@"user_id"];
    if(![self containsPlayer:player_id_other])
    {
    NSLog(@"the count %d", [self.pids count]);
    [self.pids addObject:player_id_other];
        
    NSInteger index = [self.playerArray count];
    int width = [self getWidth];
    int j = [self getOffset:index];
    int top = [self getTop:index];
   // [p setFrame:CGRectMake((160) * j, top, width, 200)];
    

    PlayerHolder *p = [[PlayerHolder alloc]init];
    [self.playerArray addObject:p];
    [p setAlpha:0.0f];
    [self addSubview:p];
    [p setPLayerStats:player];
 

    [p setFrame:CGRectMake((160) * j, top, width, 200)];
  //  self.im = [[UIImageView alloc]initWithFrame:CGRectMake(25, 0, 50, 50)];
  //  [self addSubview:self.im];
  //  self.im.layer.cornerRadius = 25.0f;
  //  self.im.layer.borderColor = [UIColor whiteColor].CGColor;
  //  self.im.layer.borderWidth = 1.0f;
    [p.im.layer setCornerRadius:65.0f];
    [p.personName setFrame:CGRectMake(0, 136, 160,20)];
    [p.im setFrame:CGRectMake(15, 0, 130, 130)];
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
    
    
    int offset = 200;
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
-(void)removePlayer:(NSString *)playerId
{
    for(PlayerHolder *p in [self.playerArray copy])
    {

        NSString *pid = [p getPlayerId] ;
        if([pid isEqualToString:playerId])
        {
            [self removePlayerFromParray:pid];
            //  p.transform = p.transform;
            //   p.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
            [self.playerArray removeObject:p];
            [UIView animateWithDuration:0.2
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^ {
                                 [p setAlpha:0.0f];
                             }completion:^(BOOL finished) {
                                 [p removeFromSuperview];
                                 
                             }];
            
        }
        
    }
    
    [self fixLayoutViews];
    
    
}


-(void)fixLayoutViews
{
    int ind = 0;
    for(PlayerHolder *p in [self.playerArray copy])
    {
        int width = [self getWidth];
        int j = [self getOffset:ind];
        int top = [self getTop:ind];
        
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             [p setFrame:CGRectMake((160) * j, top, width, 200)];
                         }completion:^(BOOL finished) {
                         }];
        ind++;
        
    }
}

-(void)addInitial:(NSMutableArray *)players
{
    for(PlayerHolder *d in [players copy])
    {
        NSString *player_id_other = [d getPlayerId];
        if(![self containsPlayer:player_id_other])
        {
        
            [self addPlayer:d.player];
        
        }
    
    }
    
    
    
}



-(BOOL) containsPlayer:(NSString*)string
{
    for (NSString* str in [self.pids copy]) {
        if ([str isEqualToString:string])
            return YES;
    }
    return NO;
}


-(void)removePlayerFromParray:(NSString *)s
{
    
    for (NSString* str in [self.pids copy]) {
        if ([str isEqualToString:s])
        {
            [self.pids removeObject:str];
        }
    }
    
}

@end
