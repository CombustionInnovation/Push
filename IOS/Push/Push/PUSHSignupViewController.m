//
//  PUSHSignupViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/13/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHSignupViewController.h"
#import "PUSHPhoneVerificationViewController.h"
#import "ECPhoneNumberFormatter.h"
#import "MBProgressHud.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
@interface PUSHSignupViewController (){
    NSArray *inputs;
    NSArray *alertMessages;
    PUSHPhoneVerificationViewController *phoneVerification;
}




@end

@implementation PUSHSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *storyBoard = [self storyboard];
    phoneVerification = [storyBoard instantiateViewControllerWithIdentifier:@"phoneVerification"];
    [phoneVerification hideVerificationAlert];
    [self.view addSubview:phoneVerification.view];
    phoneVerification.delegate = self;
    phoneVerification.type = 0;
    [phoneVerification didMoveToParentViewController:self];
    
    inputs = [[NSArray alloc]init];
    alertMessages =[[NSArray alloc]init];
    
    inputs = @[self.signupName,self.signupUsername,self.signupPhone,self.signupPassword,self.signupConfirmPassword];
    alertMessages=@[@"NAME",@"USERNAME",@"PHONE NUMBER*",@"PASSWORD",@"CONFIRM PASSWORD"];
    
    int i = 0;
    for(UITextField *input in inputs)
    {
        
        UIColor *color = [UIColor whiteColor];
        input.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[alertMessages objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: color}];
        
        input.restorationIdentifier = [alertMessages objectAtIndex:i];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
        input.layer.cornerRadius = 4.0;
        input.tag = i;
        [input setTextColor:[UIColor whiteColor]];
        [input setBorderStyle:UITextBorderStyleNone];
        input.layer.borderWidth = 1.0;
        input.layer.borderColor = [UIColor whiteColor].CGColor;
        input.layer.masksToBounds = YES;
        [input setLeftViewMode:UITextFieldViewModeAlways];
        [input setLeftView:spacerView];
        input.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        input.delegate = self;
        input.frame = CGRectMake(input.frame.origin.x,input.frame.origin.y,input.frame.size.width,35);
        
        i++;
    }
    
    
    UITapGestureRecognizer *endkeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress)];
    endkeyboard.numberOfTapsRequired = 1;
    endkeyboard.delegate = self;
    [self.scrollView addGestureRecognizer:endkeyboard];
    
    
    [self.signupPhone addTarget:self
                        action:@selector(phoneChanged)
              forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.tag == inputs.count - 1)
    {
        NSLog(@"done");
        [self resetView];
        [self sendInitialForm];

    }
    else
    {
        UITextField *t = [inputs objectAtIndex:textField.tag + 1];
        [self.scrollView setContentOffset:CGPointMake(0,self.scrollView.frame.origin.y + (30 * (textField.tag + 1))) animated:YES];
        [textField resignFirstResponder];
        [t becomeFirstResponder];
    }
    
    
}

-(void)didLongPress
{
    [self resetView];
}

-(void)resetView
{
    [self.view endEditing:YES];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) ];
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

-(IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.2)];
    if(textField.tag == inputs.count - 1)
    {
        UITextField *t = [inputs objectAtIndex:textField.tag];
        [self.scrollView setContentOffset:CGPointMake(0,self.scrollView.frame.origin.y + (30 * (textField.tag ))) animated:YES];
    }
    else
    {
        UITextField *t = [inputs objectAtIndex:textField.tag + 1];
        [self.scrollView setContentOffset:CGPointMake(0,self.scrollView.frame.origin.y + (30 * (textField.tag))) animated:YES];
    }

  
}




- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)goSignup:(id)sender
{
    //[phoneVerification showVerificationAlert];
    
     [self sendInitialForm];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    
    if([touch.view isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
    return NO;
}


-(void)phoneChanged
{
    ECPhoneNumberFormatter *formatter = [[ECPhoneNumberFormatter alloc] init];
    NSString *formattedNumber = [formatter stringForObjectValue:self.signupPhone.text];
    [self.signupPhone setText:formattedNumber];
    
}


-(void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"PUSH"
                          message: message
                          delegate: nil
                          cancelButtonTitle: @"Okay"
                          otherButtonTitles:nil];
    [alert show];
}









-(void)sendInitialForm
{
    
    [self resetView];
    int i = 0;
    for(UITextField *input in inputs)
    {
        if(input.text.length < 1)
        {
            [self showAlert:[NSString stringWithFormat:@"%@ Cannot Be Empty",input.restorationIdentifier]];
            break;
        }
        
        if(i == inputs.count -1)
        {
            if(self.signupName.text.length>30)
            {
                [self showAlert:@"Name Cannot Be more than 30 Characters"];
            }
            
            if(self.signupUsername.text.length<6 || self.signupUsername.text.length > 13)
            {
                [self showAlert:@"Username must be between 6 and 13 characters"];
            }

            else if(self.signupPassword.text.length < 6)
            {
                [self showAlert:@"Password Must Be at Least 6 Characters"];
            }
            else if(![self.signupPassword.text isEqualToString:self.signupConfirmPassword.text])
            {
                [self showAlert:@"Passwords Do Not Match"];
            }
            else
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                
              //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                NSString *name = [self.signupName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *phone = [self.signupPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *username = [self.signupUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *password = [self.signupPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                
                
                
                NSDictionary *params = @{
                                         @"username": [NSString stringWithFormat:@"%@",username],
                                         @"phone": [NSString stringWithFormat:@"%@",phone],
                                         @"password": [NSString stringWithFormat:@"%@",password],
                                         @"name": [NSString stringWithFormat:@"%@",name],
                                         };
                
                
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager POST:@"http://combustionlaboratory.com/push/php/signUpVerified.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    
                    
                    NSString *status = responseObject[@"status"];
                    
                    if ([status isEqualToString:@"one"])
                    {
                        
                        phoneVerification.signupDictionary = params;
                        [phoneVerification.phoneToVerify setText:self.signupPhone.text];
                        [phoneVerification showVerificationAlert];
                      
                        
                    }
                    else if([status isEqualToString:@"two"])
                    {
                    
                           [self showAlert:@"Username is Taken!"];
                    }
                    else if ([status isEqualToString:@"three"])
                        
                    {
                            [self showAlert:@"Phone Number in use!"];
                    }
                    else
                    {
                        [self showAlert:@"There was an error"];
                    }
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [self showAlert:@"There was an error"];
                }];
            }
        }
        
        i++;
    }


}


//phone verificaiton delegation methods
-(void)userDidVerify:(NSString*)username:(NSString *)password
{
    [phoneVerification hideVerificationAlert];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate userRegistered:username:password];
    }];
  
}
-(void)userCanceledVerification
{
    
}


-(void)tryToVerify:(NSString *)code:(NSDictionary *)dict
{
    [self finalSignup:code:dict];
}
-(void)resendCodeButtonPressed:(NSDictionary *)dict
{
    [self reSendCode:dict];
}
// end delegate

-(void)finalSignup:(NSString *)codes:(NSDictionary *)dict
{
    

        [self.view endEditing:YES];
        if(codes.length <4)
        {
            [self showAlert:@"Invalid Security Code"];
        }
        else
        {
            
            [phoneVerification showHud];
            
            NSString *name = [dict objectForKey:(@"name")];
            NSString *username = [dict objectForKey:(@"username")];
            NSString *phone = [dict objectForKey:(@"phone")];
            NSString *password = [dict objectForKey:(@"password")];
            NSString *code = codes;
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            
            
            
            
            NSDictionary *params = @{
                                     @"username": [NSString stringWithFormat:@"%@",username],
                                     @"phone": [NSString stringWithFormat:@"%@",phone],
                                     @"password": [NSString stringWithFormat:@"%@",password],
                                     @"name": [NSString stringWithFormat:@"%@",name],
                                     @"code": [NSString stringWithFormat:@"%@",code],
                                     };
            
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:@"http://combustionlaboratory.com/push/php/pushSignup.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                
                
                NSString *status = responseObject[@"status"];
                
                if ([status isEqualToString:@"one"])
                {
       
                    
                    [self userDidVerify:username:password];
                }
                else if([status isEqualToString:@"two"])
                {
                    [self showAlert:@"Username taken"];
                }
                else if ([status isEqualToString:@"three"])
                {
                    [self showAlert:@"Phone in use"];
                }
                else if ([status isEqualToString:@"four"])
                {
                    [self showAlert:@"Invalid Security Code"];
                }
                else
                {
                    [self showAlert:@"There was an error"];
                }
                
                     [phoneVerification hideHud];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [phoneVerification hideHud];
            }];
            
        }
        
    }



-(void)reSendCode:(NSDictionary *)dict
{
    
        [phoneVerification showHud];
    
    
        [self.view endEditing:YES];
        
        NSString *name = [dict objectForKey:(@"name")];
        NSString *username = [dict objectForKey:(@"username")];
        NSString *phone = [dict objectForKey:(@"phone")];
        NSString *password = [dict objectForKey:(@"password")];
    
    
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        
        
        
        NSDictionary *params = @{
                                 @"username": [NSString stringWithFormat:@"%@",username],
                                 @"phone": [NSString stringWithFormat:@"%@",phone],
                                 @"password": [NSString stringWithFormat:@"%@",password],
                                 @"name": [NSString stringWithFormat:@"%@",name],
                
                                 };
        
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://combustionlaboratory.com/push/php/signUpVerified.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            
            NSString *status = responseObject[@"status"];
            
            if ([status isEqualToString:@"one"])
            {
                [self showAlert:@"Code has been sent to your phone"];
            }
            else if([status isEqualToString:@"two"])
            {
                [self showAlert:@"Username taken"];
            }
            else if ([status isEqualToString:@"three"])
            {
                [self showAlert:@"Phone in use"];
            }
            else if ([status isEqualToString:@"four"])
            {
                [self showAlert:@"Invalid Security Code"];
            }
            else
            {
                [self showAlert:@"There was an error"];
            }
            
            [phoneVerification hideHud];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
   
   
        }];
        
    

    
}






@end
