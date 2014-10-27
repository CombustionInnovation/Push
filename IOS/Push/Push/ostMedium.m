//
//  ostMedium.m
//  Push
//
//  Created by Daniel Nasello on 9/29/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "ostMedium.h"

@implementation ostMedium



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
    [self setFont:[UIFont fontWithName:@"OstrichSans-Medium" size:18.0]];
    [self setTextColor:[UIColor whiteColor]];
    [self setTextAlignment:NSTextAlignmentCenter];
    
}
@end
