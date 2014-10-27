//
//  SyncPhoneBookButton.m
//  Push
//
//  Created by Daniel Nasello on 9/20/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "SyncPhoneBookButton.h"

@implementation SyncPhoneBookButton



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initClass];
    }
    return self;
}


-(void)initClass
{
    [self setBackgroundImage:[UIImage imageNamed:@"contacts"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"contactspressed"] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"contactschecked"] forState:UIControlStateSelected];
    
    [self addTarget:self
             action:@selector(wasClicked)
   forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)wasClicked
{
    [self initContacts];
}


-(void)initContacts
{
    NSLog(@"DDD");
    [self.delegate willStartPhoneProcess];
  //  self.contacts.delegate = self;
    //[self.contacts getContacts:0];
    GetContacts *c = [[GetContacts alloc]init];
    c.delegate = self;
    [c getContacts:0];
}









//contact manager delegate

-(void)returnPhoneNumbers:(NSMutableArray*)numbers
{
    NSLog(@"numbers %@",numbers);
    [self syncSocialNumbers:numbers];
}
-(void)userMustEnableContacts
{
    [self.delegate userDeniedPhonebookPermissions];
}




-(void)syncSocialNumbers:(NSMutableArray *)numbers
{
    
    
    NSString *phoneNumberString = [numbers componentsJoinedByString:@","];
    
    NSLog(@"the numbers %@", phoneNumberString);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    
    NSDictionary *params = @{
                             @"user_id":[NSString stringWithFormat:@"%@",user_id],
                             @"phones":[NSString stringWithFormat:@"%@",phoneNumberString],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/push/php/getFriendsPhoneNumbers.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"status"];
        NSString *fname = responseObject[@"fname"];
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults synchronize];
        
        if ([status isEqualToString:@"one"])
        {
             [self.delegate didSendNumbers];
        }
        else
            
        {
           [self.delegate numberSyncFail];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"issue");
        [self.delegate numberSyncFail];
        
    }];
    
  
  
}




//end contact manager delegate

@end
