//
//  PhoneVerification.m
//  Push
//
//  Created by Daniel Nasello on 9/13/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PhoneVerification.h"

@implementation PhoneVerification

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"PhoneVerification"
                                                    owner:self options:nil];
  

    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
