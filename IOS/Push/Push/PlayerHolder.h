//
//  PlayerHolder.h
//  Push
//
//  Created by Daniel Nasello on 9/18/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface PlayerHolder : UIView

@property(nonatomic,strong)UIImageView *im;
@property(nonatomic,strong)NSString*image;
@property(nonatomic,strong)NSDictionary*player;
@property(nonatomic,strong)UIView* pictureHolder;
@property(nonatomic,strong)UILabel *personName;
@property(nonatomic,assign)int playerId;
-(NSString *)getPlayerId;
-(void)setPLayerStats:(NSDictionary *)player;
-(void)playerHasLost:(NSString *)position;
@end
