//
//  NSDictionary+JSONDict.h
//  Push
//
//  Created by Daniel Nasello on 9/27/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONDict)
-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end
