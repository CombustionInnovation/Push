//
//  PUSHSetUsernameViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/16/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHSetUsernameViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

@interface PUSHSetUsernameViewController (){
    BOOL userNameValid;
}

@end

@implementation PUSHSetUsernameViewController

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
     [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.45] /*#000000*/];
    
    userNameValid = NO;
    
    UITapGestureRecognizer *endkeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress)];
    endkeyboard.numberOfTapsRequired = 1;
    endkeyboard.delegate = self;
    [self.view addGestureRecognizer:endkeyboard];
    
    
    [self.containerView setClipsToBounds:YES];
    [self.containerView.layer setCornerRadius:5.0f];
    
    self.myUsername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ENTER USERNAME" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.myUsername.layer.cornerRadius = 4.0;
    self.myUsername.tag = 0;
    [self.myUsername setTextColor:[UIColor whiteColor]];
    [self.myUsername setBorderStyle:UITextBorderStyleNone];
    self.myUsername.layer.borderWidth = 1.0;
    self.myUsername.layer.borderColor = [UIColor whiteColor].CGColor;
    self.myUsername.layer.masksToBounds = YES;
    [self.myUsername setLeftViewMode:UITextFieldViewModeAlways];
    [self.myUsername setLeftView:spacerView];
    self.myUsername.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.myUsername.delegate = self;
    
    [self.myUsername addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
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

- (IBAction)cancelUsernameCreate:(id)sender {
    [self.delegate userNameWasCanceled];
    [self.myUsername setText:@""];
}


- (IBAction)addUsernameToAccount:(id)sender {
    if(self.myUsername.text.length > 4)
    {
        [self setUserName];
    }
}

-(void)showVerificationAlert
{
    [self.view setHidden:NO];
    self.containerView.transform = CGAffineTransformMakeScale(0.41,0.41);
    [UIView animateWithDuration:0.31
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.containerView.transform = CGAffineTransformIdentity;
                     }completion:^(BOOL finished) {
                         
                         
                     }];
    
}

-(void)hideVerificationAlert
{
    [self.view setHidden:YES];
  //  [self.codeInput setText:@""];
}

- (IBAction)textFieldShouldReturn:(UITextField *)textField {
    
    [self didLongPress];
    [self validateUsername];
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

-(void)validateUsername
{
    if(self.myUsername.text.length > 4)
       {
           [self setUserName];
       }
    
}


-(void)textFieldDidChange
{
   int length = self.myUsername.text.length;
    if(length < 6 || length > 13)
    {
        userNameValid = NO;
        [self.verificationLabel setBadText];
    }
    else
    {
        
        [self checkUsernameIsValid:self.myUsername.text];
        
    }
}
-(void)checkUsernameIsValid:(NSString *)username
{
    
    NSDictionary *params = @{
                             @"username":[NSString stringWithFormat:@"%@",username],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/push/php/usernameLive.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"status"];

        if ([status isEqualToString:@"one"])
        {
            userNameValid = YES;
            [self.verificationLabel setGoodText];
        }
        else
            
        {
            userNameValid = NO;
            [self.verificationLabel setBadText];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"issue");
          userNameValid = NO;
    }];

}




-(void)setUserName
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults objectForKey:@"user_id"];
    
    NSDictionary *params = @{
                             @"username":[NSString stringWithFormat:@"%@",self.myUsername.text],
                             @"user_id":[NSString stringWithFormat:@"%@",user_id],
                             };
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://combustionlaboratory.com/push/php/updateUsername.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        NSString *status = responseObject[@"status"];
        
        if ([status isEqualToString:@"one"])
        {
            userNameValid = YES;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.myUsername.text forKey:@"username"];
            [defaults synchronize];
            
                [self.verificationLabel setGoodText];
                [self.delegate usernameWasSet];
    
        }
        else if([status isEqualToString:@"two"])
            
        {
            userNameValid = NO;
            [self.verificationLabel setBadText];
        }
        else if([status isEqualToString:@"three"])
        {
                 [self toastMessage:@"Username cannot contain special characters!"]; 
        }
        else
        {
            [self toastMessage:@"There was an error!"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"issue");
        userNameValid = NO;
    }];
    
}


-(void)hideView
{
    [self.view setHidden:YES];
    [self.myUsername setText:@""];
    [self.verificationLabel closeText];
}


-(void)toastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color =[UIColor colorWithRed:0.824 green:0.204 blue:0.039 alpha:1];
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = 200.f;
	hud.removeFromSuperViewOnHide = YES;
    
	[hud hide:YES afterDelay:3];
}


@end
