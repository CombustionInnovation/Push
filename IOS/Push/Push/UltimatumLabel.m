//
//  UltimatumLabel.m
//  Push
//
//  Created by Daniel Nasello on 9/15/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "UltimatumLabel.h"

@implementation UltimatumLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setNumberOfLines:0];
    }
    return self;
}

-(void)countDown:(NSString*)secs
{
    
     NSString *keep = @"Keep it up! \n shake within ";
     NSMutableAttributedString *attrstring = [[NSMutableAttributedString alloc]initWithString:keep attributes:nil];
  //  NSAttributedString * aastt = [[NSAttributedString alloc]initWithString:@"Keep it up! \n" attributes:nil];
     NSAttributedString *s = [self attrString:[NSString stringWithFormat:@"%@s",secs]];
     [attrstring appendAttributedString:s];
     NSAttributedString * aastt = [[NSAttributedString alloc]initWithString:@"\n to keep going" attributes:nil];
     [attrstring appendAttributedString:aastt];
    [self setAttributedText:attrstring];
     
   
}







-(NSMutableAttributedString*)attrString:(NSString *)string
{

    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:string];

    //UIFont *font= [UIFont fontWithName:@"MyriadApple-SemiboldItalic" size:12];
   // [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attrString length])];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1] range:NSMakeRange(0, [string length])];
    
    
    
    return attrString;
}

@end
