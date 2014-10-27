//
//  PUSHForgotPasswordViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/18/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHForgotPasswordViewController.h"
#import "ECPhoneNumberFormatter.h"
#import "MBProgressHud.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

@interface PUSHForgotPasswordViewController (){
    NSArray *inputs;
    NSArray *alertMessages;

}

@end

@implementation PUSHForgotPasswordViewController


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
    

    
    inputs = [[NSArray alloc]init];
    alertMessages =[[NSArray alloc]init];
    
    inputs = @[self.userName,self.phoneNumber];
    alertMessages=@[@"USERNAME",@"PHONE NUMBER"];
    
    int i = 0;
    for(UITextField *input in inputs)
    {
        
        UIColor *color = [UIColor whiteColor];
        input.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[alertMessages objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: color}];
        input.textColor=[UIColor whiteColor];
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
    [self.view addGestureRecognizer:endkeyboard];
    
    
    [self.phoneNumber addTarget:self
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
}



-(void)phoneChanged
{
    ECPhoneNumberFormatter *formatter = [[ECPhoneNumberFormatter alloc] init];
    NSString *formattedNumber = [formatter stringForObjectValue:self.phoneNumber.text];
    [self.phoneNumber setText:formattedNumber];
    
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
        
        if(i == 1)
        {
       
     
         
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
            
                
        NSString *username = [self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *phone = [self.phoneNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
                
                
                NSDictionary *params = @{
                                         @"username": [NSString stringWithFormat:@"%@",username],
                                         @"phone": [NSString stringWithFormat:@"%@",phone],
                                         };
                
                
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager POST:@"http://combustionlaboratory.com/push/php/forgotPW.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    
                    
                    NSString *status = responseObject[@"status"];
                    
                    if ([status isEqualToString:@"one"])
                    {
                        [self showAlert:@"New password has been texted to you!"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    }
                    else if([status isEqualToString:@"two"])
                    {
                        
                        [self showAlert:@"Username/Phone Combination Incorrect!!"];
                    }
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [self showAlert:@"There was an error"];
                }];
            }
        
        
        i++;

        }
    }

    


- (IBAction)cancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)okCLicked:(id)sender
{
    [self sendInitialForm];
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

@end
