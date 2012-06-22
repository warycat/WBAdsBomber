//
//  CreateSquadronViewController.m
//  WBAdsBomber
//
//  Created by Larry on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateSquadronViewController.h"

@interface CreateSquadronViewController ()

@end

@implementation CreateSquadronViewController
@synthesize delegate = _delegate;
@synthesize keyTextField;
@synthesize secretTextField;

- (IBAction)clickDone:(id)sender {
    [self.delegate createSquadronWithKey:self.keyTextField.text andSecret:self.secretTextField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

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

- (void)viewDidUnload
{
    [self setKeyTextField:nil];
    [self setSecretTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
