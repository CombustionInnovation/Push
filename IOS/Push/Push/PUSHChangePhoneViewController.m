//
//  PUSHChangePhoneViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/15/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHChangePhoneViewController.h"
#import "ECPhoneNumberFormatter.h"
#import "MBProgressHud.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "PUSHPhoneVerificationViewController.h"
@interface PUSHChangePhoneViewController (){
       PUSHPhoneVerificationViewController *phoneVerification;
}

@end

@implementation PUSHChangePhoneViewController

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
    
    [self.myPhoneNumber addTarget:self
                         action:@selector(phoneChanged)
               forControlEvents:UIControlEventEditingChanged];
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *lt = [defaults objectForKey:@"phone_number"];
       ECPhoneNumberFormatter *formatter = [[ECPhoneNumberFormatter alloc] init];
        NSString *formattedNumber = [formatter stringForObjectValue:lt];
    
        [self.myPhoneLabnel setText:formattedNumber];
        [self.myPhoneNumber setText:formattedNumber];
    
    UITextField *input = self.myPhoneNumber;
    UIColor *color = [UIColor whiteColor];
    input.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PHONE NUMBER"attributes:@{NSForegroundColorAttributeName: color}];
    input.textColor = [UIColor whiteColor];
    input.restorationIdentifier = @"PHONE NUMBER";
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    input.layer.cornerRadius = 4.0;
    input.tag = 0;
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
    
    UIStoryboard *storyBoard = [self storyboard];
    phoneVerification = [storyBoard instantiateViewControllerWithIdentifier:@"phoneVerification"];
    [phoneVerification hideVerificationAlert];
    [self.view addSubview:phoneVerification.view];
    phoneVerification.delegate = self;
    phoneVerification.type = 0;
    [phoneVerification didMoveToParentViewController:self];
    
    UITapGestureRecognizer *endkeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress)];
    endkeyboard.numberOfTapsRequired = 1;
    endkeyboard.delegate = self;
    [self.view addGestureRecognizer:endkeyboard];
}

-(void)didLongPress
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)textFieldShouldReturn:(UITextField *)textField {
    

        NSLog(@"done");
        [self resetView];
        [self sendInitialForm];
        
  
    
    
}



-(void)resetView
{
    [self.view endEditing:YES];
    
}

-(void)sendInitialForm
{
        if(self.myPhoneNumber.text.length > 2)
        {
    
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *user = [defaults objectForKey:@"user_id"];
    
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = @{
                             @"user_id": [NSString stringWithFormat:@"%@",user],
                             @"phone": [NSString stringWithFormat:@"%@",self.myPhoneNumber.text],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/push/php/sendVerificationNewNumber.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"status"];
        
        if ([status isEqualToString:@"one"])
        {
            phoneVerification.signupDictionary = params;
            [phoneVerification.phoneToVerify setText:self.myPhoneNumber.text];
            [phoneVerification showVerificationAlert];
            
        }
        else if([status isEqualToString:@"two"])
        {
            
            [self showAlert:@"Phone number taken!"];
        }
        else
        {
            [self showAlert:@"There was an Error"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self showAlert:@"There was an error"];
    }];
        }
        else
        {
             [self showAlert:@"It seems like you don't have a valid number"];
        }
}

-(void)phoneChanged
{
    ECPhoneNumberFormatter *formatter = [[ECPhoneNumberFormatter alloc] init];
    NSString *formattedNumber = [formatter stringForObjectValue:self.myPhoneNumber.text];
    [self.myPhoneNumber setText:formattedNumber];
    
}
- (IBAction)cancelChangePhone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)okButtonPressed:(id)sender {
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

//phone verificaiton delegation methods
-(void)userDidVerify:(NSString*)username:(NSString *)password
{
    [phoneVerification hideVerificationAlert];
    [self toastMessage:@"Phone Number Updated!"];
    self.myPhoneLabnel.text = self.myPhoneNumber.text;
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.myPhoneNumber.text forKey:@"phone_number"];
    [defaults synchronize];
    
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


-(void)finalSignup:(NSString *)codes:(NSDictionary *)dict
{

    
    NSString *phone = [dict objectForKey:(@"phone")];
    NSString *user_id = [dict objectForKey:(@"user_id")];
    NSString *code = codes;
    
    [phoneVerification showHud];

    
    
    
    
    NSDictionary *params = @{
                             @"user_id": [NSString stringWithFormat:@"%@",user_id],
                             @"phone": [NSString stringWithFormat:@"%@",phone],
                             @"code": [NSString stringWithFormat:@"%@",code],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/push/php/userPhoneChange.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"status"];
        
        if ([status isEqualToString:@"one"])
        {
            [phoneVerification hideVerificationAlert];
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:phone forKey:@"phone_number"];
            [defaults synchronize];
            [self.myPhoneLabnel setText:self.myPhoneNumber.text];
            [self toastMessage:@"Phone Number Updated!"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if([status isEqualToString:@"two"])
        {
            [self showAlert:@"Phone Number Taken"];
        }
        else if ([status isEqualToString:@"three"])
        {
                 [phoneVerification hideHud];
            [self showAlert:@"Invalid Security Code"];
        }
        else
        {
            [self showAlert:@"There was an error"];
        }
        
        [phoneVerification hideHud];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [phoneVerification hideHud];

        [self showAlert:@"There was an error"];
    }];
}

-(void)reSendCode:(NSDictionary *)dict
  {
      [self.view endEditing:YES];

      
      [phoneVerification showHud];
      
  
      
      
      
      AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
      [manager POST:@"http://combustionlaboratory.com/push/php/sendVerificationNewNumber.php" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                   [phoneVerification hideHud];
              [self showAlert:@"Invalid Security Code"];
          }
          else
          {
              [self showAlert:@"There was an error"];
          }
          
            [phoneVerification hideHud];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [phoneVerification hideHud];
          
      }];

  }




-(void)toastMessage:(NSString *)message
{
    MBProgressHUD *huds = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    huds.color =[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1];
    // Configure for text only and offset down
    huds.mode = MBProgressHUDModeText;
    huds.labelText = message;
    huds.margin = 10.f;
    huds.yOffset = 200.f;
    huds.removeFromSuperViewOnHide = YES;
    
    [huds hide:YES afterDelay:3];
}


@end
