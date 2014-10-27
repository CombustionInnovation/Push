//
//  NSDictionary+JSONDict.m
//  Push
//
//  Created by Daniel Nasello on 9/27/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "NSDictionary+JSONDict.h"

@implementation NSDictionary (JSONDict)
-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end

