//
//  SlidingTabManager.h
//  Push
//
//  Created by Daniel Nasello on 10/3/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingTabManager : UIView
@property(nonatomic, assign)NSInteger numberOfTabs;
@property(nonatomic,strong)NSArray*labels;
@property(nonatomic,retain)NSMutableArray *toggleButtons;
@property(nonatomic,assign)NSInteger currentlySelected;
-(void)createTabs;
-(void)setDefaultTab;
@property(nonatomic,strong)UIView *redSliderView;
@property(nonatomic,strong)NSMutableArray *labelWidths;
@end
