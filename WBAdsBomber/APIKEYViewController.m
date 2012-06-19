//
//  APIKEYViewController.m
//  WBAdsBomber
//
//  Created by Larry on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "APIKEYViewController.h"



@interface APIKEYViewController ()

@end

@implementation APIKEYViewController
@synthesize delegate = _delegate;
@synthesize idTextField;
@synthesize keyTextField;

- (IBAction)done:(id)sender {
    NSString *idText = self.idTextField.text;
    NSString *keyText = self.keyTextField.text;
    if ([idText isEqualToString:@""] || [keyText isEqualToString:@""]) {
        return;
    }
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:idText,@"id",keyText,@"key", nil];
    [self.delegate addkey:result];
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
    NSLog(@"DidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    NSLog(@"DidUnload");
    [self setIdTextField:nil];
    [self setKeyTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
