//
//  LeaderboardTabBar.h
//  Push
//
//  Created by Daniel Nasello on 9/13/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUSHTabDelegate.h"
@protocol PUSHTabDelegate <NSObject>
-(void)tabWasChanged:(NSInteger)index;
@end



@interface LeaderboardTabBar : UIView{
    id<PUSHTabDelegate>delegate;
}
@property (nonatomic,weak)id delegate;
@property(nonatomic,retain)NSMutableArray *toggleButtons;
@property(nonatomic,assign)int currentSelected;
@end
