//
//  SlidingTabManager.m
//  Push
//
//  Created by Daniel Nasello on 10/3/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "SlidingTabManager.h"

@implementation SlidingTabManager

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


-(void)createTabs
{
    self.toggleButtons = [[NSMutableArray alloc]init];
    self.currentlySelected = 0;
    self.labelWidths  = [[NSMutableArray alloc]init];
    
    UIImage *pressed =  [self imageWithColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.125 alpha:1] /*#202020*/];

    UIImage *pressedinter = [self imageWithColor:[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:0.7] /*#e9e9e9*/];
    UIImage *notpressed = [self imageWithColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.125 alpha:1] /*#202020*/];
    
    int width = self.frame.size.width / self.numberOfTabs;
    NSArray *tabWords = [[NSArray alloc]init];
    tabWords = self.labels;
    int i = 0;
    for(NSString *label in tabWords)
    {
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(width * i, 0, width, self.frame.size.height);
        b.titleLabel.font = [UIFont systemFontOfSize:15];
        b.clipsToBounds = YES;
        b.tag = i;
        b.layer.cornerRadius = 0.0f;
        [b setAttributedTitle:[[NSAttributedString alloc] initWithString:[tabWords objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]  forState:UIControlStateSelected];
        [b setAttributedTitle:[[NSAttributedString alloc] initWithString:[tabWords objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]  forState:UIControlStateHighlighted];
        [b setAttributedTitle:[[NSAttributedString alloc] initWithString:[tabWords objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]  forState:UIControlStateNormal];
        float f = [self expectedWidth:b:label];
        [self.labelWidths addObject:[NSString stringWithFormat:@"%f",f]];
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
    
    [self createRedSlider];
}
-(void)setDefaultTab
{
    
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
    if(b.tag !=self.currentlySelected)
    {
        UIButton *goButton = [self.toggleButtons objectAtIndex:self.currentlySelected];
        goButton.selected = NO;
        b.selected = YES;
        self.currentlySelected = b.tag;
        //do delegation to let the controller know that the index of the tab changed.
       // [self.delegate tabWasChanged:b.tag];
        [self slideTo];
    }
}


-(void)createRedSlider
{
    float width = [[self.labelWidths objectAtIndex:self.currentlySelected] floatValue];
    float bwidth = (self.frame.size.width/self.numberOfTabs);
    float adjustedwidth = bwidth - width;
    self.redSliderView = [[UIView alloc]initWithFrame:CGRectMake((bwidth * self.currentlySelected) + (adjustedwidth/2) ,self.frame.size.height-10,width,2)];
    [self.redSliderView  setBackgroundColor:[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1]];
    [self addSubview:self.redSliderView];
    [self bringSubviewToFront:self.redSliderView];
    
    
}


-(void)slideTo
{
     float width = [[self.labelWidths objectAtIndex:self.currentlySelected] floatValue];
    float bwidth = (self.frame.size.width/self.numberOfTabs);
    float adjustedwidth = bwidth - width;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [self.redSliderView setFrame:CGRectMake((bwidth * self.currentlySelected) + (adjustedwidth/2) ,self.frame.size.height-10,width,2)];
                         //   self.layer.cornerRadius = 80.0f;
                     }completion:^(BOOL finished) {
                         
                         
                     }];}


- (CGFloat)expectedWidth :(UIButton *)label :(NSString *)text
{
    CGSize size = [text sizeWithFont:label.font
                         constrainedToSize:CGSizeMake(FLT_MAX,label.bounds.size.height)
                             lineBreakMode:label.lineBreakMode];
    
    return size.width;
}

@end
