//
//  MultiPlayerTabs.h
//  Push
//
//  Created by Daniel Nasello on 9/17/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PUSHTabDelegate <NSObject>
-(void)tabWasChanged:(NSInteger)index;
@end



@interface MultiPlayerTabs : UIView{
    id<PUSHTabDelegate>delegate;
}
@property (nonatomic,weak)id delegate;
@property(nonatomic,retain)NSMutableArray *toggleButtons;
@property(nonatomic,assign)int currentSelected;
@end

