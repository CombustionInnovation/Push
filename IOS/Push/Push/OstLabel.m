//
//  OstLabel.m
//  Push
//
//  Created by Daniel Nasello on 9/28/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "OstLabel.h"

@implementation OstLabel


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

-(void)setDefaults
{
    [self setFont:[UIFont fontWithName:@"OstrichSansInline" size:80.0]];
    [self setTextColor:[UIColor whiteColor]];
    [self setTextAlignment:NSTextAlignmentCenter];

}

@end
