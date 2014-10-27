//
//  game_circle.m
//  Push
//
//  Created by Daniel Nasello on 9/15/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "game_circle.h"

@implementation game_circle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.ispressed = NO;
    }
    return self;
}

-(void)setOuterViews:(UIView *)v
{
    
    
    self.outerView = v;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([self isTouch:touch WithinBoundsOf:self])
    {
        NSLog(@"Fires first action...");
        [self startGame];
    }
    else if([self isTouch:touch WithinBoundsOf:self.outerView]){
        NSLog(@"Fires second action...");
    }


}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.canplay && self.ispressed)
    {
        [self endGameOperations];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.canplay && self.ispressed)
    {
        [self endGameOperations];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    if (![self isTouch:touch WithinBoundsOf:self])
    {
        if(!self.canplay && self.ispressed)
        {
            [self endGameOperations];
        }
    }

  
}


-(BOOL)isTouch:(UITouch *)touch WithinBoundsOf:(UIView *)imageView{
    
    CGRect _frameRectangle=[imageView frame];
    CGFloat _imageTop=_frameRectangle.origin.y;
    CGFloat _imageLeft=_frameRectangle.origin.x;
    CGFloat _imageRight=_frameRectangle.size.width+_imageLeft;
    CGFloat _imageBottom=_frameRectangle.size.height+_imageTop;
    
    CGPoint _touchPoint = [touch locationInView:self];
    
    /*NSLog(@"image top %f",_imageTop);
     NSLog(@"image bottom %f",_imageBottom);
     NSLog(@"image left %f",_imageLeft);
     NSLog(@"image right %f",_imageRight);
     NSLog(@"touch happens at %f-%f",_touchPoint.x,_touchPoint.y);*/
    
    if(_touchPoint.x>=_imageLeft &&
       _touchPoint.x<=_imageRight &&
       _touchPoint.y>=_imageTop &&
       _touchPoint.y<=_imageBottom){
        
        [imageView setAlpha:0.5];//optional 01 -adds a transparency changing effect
        
        return YES;
    }else{
        return NO;
    }
}



-(void)endGameOperations
{
    self.ispressed = NO;
  //  self.canplay = YES;
    [self.delegate gameEnded];
    
    [self.outerView setBackgroundColor:[UIColor clearColor]];


        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             [self setFrame:CGRectMake(self.frame.origin.x-15, self.frame.origin.y - 15, self.frame.size.width+30, self.frame.size.height+30)];
                             [self setBackgroundColor:[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1]];
                             [self.outerView setBackgroundColor:[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1]];
                            
                                [self.outerView.layer setBorderColor:[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1].CGColor];
                           //   self.layer.cornerRadius = 80.0f;
                         }completion:^(BOOL finished) {
                             
                             
                         }];
    
    
    
}


-(void)solidifyCircle
{
    [self endGameOperations];
    self.canplay = NO;

}



-(void)startGame
{
      [self.outerView setBackgroundColor:[UIColor clearColor]];
    if(self.canplay && !self.ispressed)
    {
        [self.delegate gameStarted];
        self.ispressed = YES;
        self.canplay = NO;
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                              self.layer.cornerRadius = 65.0f;
                             [self setFrame:CGRectMake(self.frame.origin.x+15, self.frame.origin.y + 15, self.frame.size.width-30, self.frame.size.height-30)];
                             [self setBackgroundColor:[UIColor colorWithRed:0.141 green:0.82 blue:0.2 alpha:1]];
                             [self.outerView setBackgroundColor:[UIColor clearColor]];
                             [self.outerView.layer setBorderColor:[UIColor colorWithRed:0.141 green:0.82 blue:0.2 alpha:1].CGColor];
                         }completion:^(BOOL finished) {
                           
                             
                         }];
        
    }
    
}
@end
