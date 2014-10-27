//
//  GetContacts.m
//  Push
//
//  Created by Daniel Nasello on 9/20/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "GetContacts.h"
#import <AddressBook/AddressBook.h>
@implementation GetContacts


-(NSMutableArray *)getContacts:(Boolean*)asc
{
    NSLog(@"DD");
    
    ABAddressBookRef m_addressbook = ABAddressBookCreate();
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(m_addressbook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        // Do whatever you want here.
        if (!m_addressbook)
        {
            NSLog(@"opening address book");
        }
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(m_addressbook);
        CFIndex nPeople = ABAddressBookGetPersonCount(m_addressbook);
        NSArray *arrayOfPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(m_addressbook);
        
        NSMutableArray *firstNames = [[NSMutableArray alloc] init];
        NSMutableArray *people = [[NSMutableArray alloc] init];
        int i = 0;
        
        if(arrayOfPeople.count>0)
        {
            for(NSUInteger index = 0; index <= ([arrayOfPeople count]-1); index++){
                
                ABRecordRef currentPerson = (__bridge ABRecordRef)[arrayOfPeople objectAtIndex:index];
                NSString *currentFirstName = [self stringNull:(__bridge_transfer NSString *)ABRecordCopyValue(currentPerson, kABPersonFirstNameProperty)];
                NSString *lastName = [self stringNull:(__bridge_transfer NSString *)ABRecordCopyValue(currentPerson, kABPersonLastNameProperty)];
                NSString *fullname = [NSString stringWithFormat:@"%@ %@",currentFirstName,lastName];
                
                NSString *image = [self stringNull:(__bridge_transfer NSString *)ABRecordCopyValue(currentPerson, kABPersonImageFormatThumbnail)];
                
                
                NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
                NSString *mobilenum;
                NSString *mobilenums;
                ABMultiValueRef multiPhones = ABRecordCopyValue(currentPerson, kABPersonPhoneProperty);
                
                for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                    NSString *mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(multiPhones, i);
                    NSString * mnum;
                    if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
                        NSLog(@"mobile:");
                        mobilenum = [self stringNull:mobileLabel];
                        
                        if(mobilenum.length == 0)
                        {
                            mobilenum =@"";
                        }
                        else
                        {
                            mobilenum = phoneNumber;
                        }
                    }
                    
                    
                    [phoneNumbers addObject:phoneNumber];
                    NSLog(@"All numbers %@", phoneNumber);
                }
                
                
                if(mobilenum.length > 0)
                {
                    
                    NSDictionary* contactData = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 currentFirstName,@"firstname",
                                                 [NSString stringWithFormat:@"%d",i],@"contactID",
                                                 lastName, @"lastname",
                                                 fullname,@"fullname",
                                                 [NSString stringWithFormat:@"%@ %@",currentFirstName, lastName],@"full",
                                                 mobilenum,@"mobilenumber",
                                                 phoneNumbers,@"phonenumberarray",
                                                 image,@"icon",
                                                 [NSString stringWithFormat:@"%@",@"0"],@"selected",
                                                 nil];
                    
                    [people addObject: contactData];
                }
                
                
                if(index == arrayOfPeople.count - 1)
                {
                    
                    NSSortDescriptor *sort;
                    
                    if(asc)
                    {
                        sort=[NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES];
                    }
                    else
                    {
                        sort=[NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:NO];
                    }
                    [people sortUsingDescriptors:[NSArray arrayWithObject:sort]];
                    
                  //  [self.delegate contactsIsDone:people];
                    
                    
                    [self extractNames:people];
                }
                
                
                
                
                
                i++;
            }
            
            
            
            //OPTIONAL: The following line sorts the first names alphabetically
            //    sortedFirstNames = [firstNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }
        else
        {

        }
    }
    else
    {
        [self.delegate userMustEnableContacts];
    }
    
    
    
    return self.people;
    
}

-(NSInteger)getContactCount
{
    return [self.people count];
    
}


-(NSMutableArray *)extractNames:(NSMutableArray *)people
{
    
    
    NSMutableArray *numbers = [[NSMutableArray alloc]init];
    for(int i=0;i<people.count;i++)
    {
        
        NSDictionary *tmpDict = [people objectAtIndex:i];
        NSString *fname = [tmpDict objectForKey:(@"firstname")];
        NSString *lname = [tmpDict objectForKey:(@"lastname")];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",fname, lname];
        NSString *phone_number = [tmpDict objectForKey:(@"mobilenumber")];
        NSString *pn =  [phone_number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [numbers addObject:pn];
        
        if( i == people.count - 1)
        {
            [self.delegate returnPhoneNumbers:numbers];
        }
    }
    
    return numbers;
    
}



-(NSString *)stringNull:(NSString *)string
{
    NSString *cleanString;
    
    if(string == nil)
    {
        cleanString = @"" ;
    }
    else
    {
        cleanString = string;
    }
    
    
    return cleanString;
}




-(NSMutableArray *)filterPeople:(NSMutableArray *)array:(NSString *)filter
{
    NSMutableArray *filteredArray = [[NSMutableArray alloc]init];
    
    
    NSString *trimmedString = [filter stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *capitalized = [[[filter substringToIndex:1] uppercaseString] stringByAppendingString:[filter substringFromIndex:1]];
    NSString *uppercase = [trimmedString  uppercaseString];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(firstname CONTAINS %@) or (lastname CONTAINS %@) or  (firstname CONTAINS %@) or (lastname CONTAINS %@) or (mobilenumber CONTAINS %@)", trimmedString,trimmedString,capitalized,capitalized, trimmedString];
    
    filteredArray = [[array filteredArrayUsingPredicate:predicate]mutableCopy];
    
    return filteredArray;
    
}
@end
