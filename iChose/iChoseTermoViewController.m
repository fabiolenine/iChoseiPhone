//
//  iChoseTermoViewController.m
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 17/10/13.
//  Copyright (c) 2013 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import "iChoseTermoViewController.h"

@interface iChoseTermoViewController ()

@end

@implementation iChoseTermoViewController
@synthesize btVoltar, ivFundoJanela;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ([[UIScreen mainScreen ] bounds].size.height >= 568.0f)
    {
        ivFundoJanela.frame  = CGRectMake(13, 102, 294, 452);
    }
    else
    {
        ivFundoJanela.frame  = CGRectMake(13, 102, 294, 365);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btVoltar:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
