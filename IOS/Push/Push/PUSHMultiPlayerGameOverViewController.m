//
//  PUSHMultiPlayerGameOverViewController.m
//  Push
//
//  Created by Daniel Nasello on 9/11/14.
//  Copyright (c) 2014 Combustion Innovation Group. All rights reserved.
//

#import "PUSHMultiPlayerGameOverViewController.h"

@interface PUSHMultiPlayerGameOverViewController ()

@end

@implementation PUSHMultiPlayerGameOverViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setGameOverImage:(NSInteger)score
{
    
    UIImage *imglink =[UIImage imageNamed:@"welcometopush"];
    
    if(score < 10)
    {
        imglink  = [UIImage imageNamed:@"tryagain"];
    }
    else if(score>9 && score<30)
    {
        imglink   = [UIImage imageNamed:@"wompwomp"];
    }
    else if(score >29 && score < 140)
    {
        
        imglink   = [UIImage imageNamed:@"welcometopush"];
    }
    else if(score>139 && score <400)
    {
        imglink   = [UIImage imageNamed:@"lookinggood"];
    }
    else if(score>399 && score <600)
    {
        imglink   = [UIImage imageNamed:@"notbad"];
    }
    else if(score>599 && score<900)
    {
        imglink   = [UIImage imageNamed:@"awesomejob"];
    }
    
    else if(score>899 && score <1800)
    {
        imglink   = [UIImage imageNamed:@"professionalpusher"];
    }
    else if(score>1799 && score<3600)
    {
        imglink   = [UIImage imageNamed:@"professionalpusher"];
    }
    else if(score>3599 && score<7200)
    {
        imglink   = [UIImage imageNamed:@"welcometomtolympus"];
    }
    else if(score>7199 && score<14400)
    {
        imglink   = [UIImage imageNamed:@"highlydedicated"];
    }
    else if(score>13999 && score<28000)
    {
        imglink   = [UIImage imageNamed:@"mindovermatter"];
    }
    else
    {
        imglink   = [UIImage imageNamed:@"mindovermatter"];
    }
    
    [self.enourageMentImage setImage:imglink];
}



- (IBAction)littleXpressed:(id)sender {
    NSLog(@"fucke tapped");
    [self.delegate gOverMultiXpressed];
}
@end
