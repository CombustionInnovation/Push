//
//  UploadPhoto.h
//  Push
//
//  Created by Daniel Nasello on 10/6/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadPhotoProtocol.h"

@interface UploadPhoto : NSObject{
    id<UploadPhotoProtocol> delegate;
}
-(void)uploadPhoto:(UIImage *)image;
@property(nonatomic,weak)id delegate;
@end
