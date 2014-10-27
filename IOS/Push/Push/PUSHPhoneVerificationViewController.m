//
//  PUSHPhoneVerificationViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/13/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHPhoneVerificationViewController.h"
#import "MBProgressHud.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
@interface PUSHPhoneVerificationViewController ()

@end

@implementation PUSHPhoneVerificationViewController

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
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.alertHolder setClipsToBounds:YES];
    [self.alertHolder.layer setCornerRadius:5.0f];
    
    self.codeInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ENTER CODE" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.codeInput.layer.cornerRadius = 4.0;
    self.codeInput.tag = 0;
    
    [self.codeInput setBorderStyle:UITextBorderStyleNone];
    self.codeInput.layer.borderWidth = 1.0;
    self.codeInput.layer.borderColor = [UIColor whiteColor].CGColor;
    self.codeInput.layer.masksToBounds = YES;
    [self.codeInput setLeftViewMode:UITextFieldViewModeAlways];
    [self.codeInput setLeftView:spacerView];
    self.codeInput.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.codeInput.delegate = self;
    
    UITapGestureRecognizer *endkeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress)];
    endkeyboard.numberOfTapsRequired = 1;
    endkeyboard.delegate = self;
    [self.view addGestureRecognizer:endkeyboard];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.45] /*#000000*/];
  
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


-(void)showVerificationAlert
{
    [self.view setHidden:NO];
    
}

-(void)hideVerificationAlert
{
    [self.view setHidden:YES];
    [self.codeInput setText:@""];
}

- (IBAction)resendButtonPressed:(id)sender
{
    [self reSendCode];
}
- (IBAction)cancelVerificationPressed:(id)sender
{
    [self hideVerificationAlert];
}
- (IBAction)okVerificationButtonPressed:(id)sender
{
    [self.delegate tryToVerify:self.codeInput.text:self.signupDictionary];
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

-(void)reSendCode;
{
    [self.delegate resendCodeButtonPressed:self.signupDictionary];
}

-(void)codeResent
{
    [self showAlert:@"Verification Code re-sent!"];
}


-(void)showHud
{
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)hideHud
{
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

-(void)codeWasWrong
{
    [self showAlert:@"Code was Incorrect"];
}


- (IBAction)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate tryToVerify:self.codeInput.text:self.signupDictionary];
    [self.view endEditing:YES];
}




-(void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Slow down!"
                          message: message
                          delegate: nil
                          cancelButtonTitle: @"Okay"
                          otherButtonTitles:nil];
    [alert show];
}












@end
