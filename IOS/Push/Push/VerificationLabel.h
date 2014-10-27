//
//  VerificationLabel.h
//  Push
//
//  Created by Daniel Nasello on 9/16/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationLabel : UILabel

@property(assign,nonatomic)BOOL isAvailable;
-(void)setBadText;
-(void)setGoodText;
-(void)closeText;
@end
