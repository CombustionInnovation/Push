//
//  CIrcleImageView.m
//  Push
//
//  Created by Daniel Nasello on 10/3/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "CIrcleImageView.h"

@implementation CIrcleImageView

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
    [self setClipsToBounds:YES];
    [self.layer setCornerRadius:self.frame.size.height / 2];
    
}


@end
