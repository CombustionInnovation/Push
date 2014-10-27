//
//  GetContacts.h
//  Push
//
//  Created by Daniel Nasello on 9/20/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactsDelegate.h"


@protocol ContactsDelegate <NSObject>
-(void)returnPhoneNumbers:(NSMutableArray*)numbers;
-(void)userMustEnableContacts;
@end

@interface GetContacts : NSObject{
    id<ContactsDelegate>delegate;
}


@property(nonatomic,strong)NSMutableArray *people;
@property(nonatomic,strong)NSArray*generalArray;
@property(nonatomic,strong)NSMutableArray *contactsArray;

@property (nonatomic,weak)id delegate;
-(NSMutableArray *)getContacts:(Boolean*)asc;
-(NSMutableArray *)filterPeople:(NSMutableArray *)array :(NSString *)filter;
-(NSInteger)getContactCount;
@end
