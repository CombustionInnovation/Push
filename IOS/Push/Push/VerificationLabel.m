//
//  VerificationLabel.m
//  Push
//
//  Created by Daniel Nasello on 9/16/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "VerificationLabel.h"

@implementation VerificationLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)setBadText
{
    [self setTextColor:[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1]];
    [self setText:@"USERNAME TAKEN"];
}

-(void)setGoodText
{
    [self setTextColor:[UIColor colorWithRed:0.141 green:0.82 blue:0.2 alpha:1]];
    [self setText:@"USERNAME AVAILABLE"];
}

-(void)closeText
{
    [self setText:@""];
}

@end
