//
//  PUSHChangePasswordViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/15/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHChangePasswordViewController.h"
#import "MBProgressHud.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "PUSHPhoneVerificationViewController.h"
@interface PUSHChangePasswordViewController (){
    NSArray *inputs;
    NSArray *alertMessages;
 
}

@end

@implementation PUSHChangePasswordViewController

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
    
    inputs = @[self.oldPassword,self.tnp,self.confirmPassword];
    alertMessages=@[@"OLD PASSWORD",@"NEW PASSWORD",@"CONFIRM PASSWORD"];
    
    int i = 0;
    for(UITextField *input in inputs)
    {
        
        UIColor *color = [UIColor whiteColor];
        input.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[alertMessages objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: color}];
        
        input.restorationIdentifier = [alertMessages objectAtIndex:i];
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
        input.layer.cornerRadius = 4.0;
        input.tag = i;
        
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


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didLongPress
{
    [self.view endEditing:YES];
}

- (IBAction)cancelChange:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        //[self.scrollView setContentOffset:CGPointMake(0,self.scrollView.frame.origin.y + (30 * (textField.tag + 1))) animated:YES];
        [textField resignFirstResponder];
        [t becomeFirstResponder];
    }
    
    
}

-(void)resetView
{
    [self.view endEditing:YES];
   // [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) ];
   // [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

-(IBAction)textFieldDidBeginEditing:(UITextField *)textField
{
 //   [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.2)];
    if(textField.tag == inputs.count - 1)
    {
        UITextField *t = [inputs objectAtIndex:textField.tag];
   //     [self.scrollView setContentOffset:CGPointMake(0,self.scrollView.frame.origin.y + (30 * (textField.tag ))) animated:YES];
    }
    else
    {
        UITextField *t = [inputs objectAtIndex:textField.tag + 1];
//        [self.scrollView setContentOffset:CGPointMake(0,self.scrollView.frame.origin.y + (30 * (textField.tag))) animated:YES];
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
            if(self.tnp.text.length<6)
            {
                [self showAlert:@"Password cannot be less than 6 characters"];
            }
            
                       else if(![self.tnp.text isEqualToString:self.confirmPassword.text])
            {
                    [self showAlert:@"Passwords Do Not Match"];
            }
            else
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                
                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                  NSString *user = [defaults objectForKey:@"user_id"];
                
                NSString *oldpassword = [self.oldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *newpassword = [self.tnp.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *user_id = [user stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         
                
                
                NSDictionary *params = @{
                                         @"oldpassword": [NSString stringWithFormat:@"%@",oldpassword],
                                         @"newpassword": [NSString stringWithFormat:@"%@",newpassword],
                                         @"user_id": [NSString stringWithFormat:@"%@",user_id],
                                         };
                
                
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager POST:@"http://combustionlaboratory.com/push/php/changePassword.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"JSON: %@", responseObject);
                    
                    
                    NSString *status = responseObject[@"status"];
                    
                    if ([status isEqualToString:@"one"])
                    {
                        
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:newpassword forKey:@"password"];
                        [defaults synchronize];
                        

                    [self dismissViewControllerAnimated:YES completion:^{
                        //where i tell delegate to toast;
                    }];
                        
                        
                    }
          
                    else if([status isEqualToString:@"two"])
                    {
                        [self showAlert:@"Old Password Incorrect"];
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


//
- (IBAction)goChanged:(id)sender {
    [self sendInitialForm];
}


@end

