//
//  DetailViewController.m
//  WBAdsBomber
//
//  Created by Larry on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize webView;
@synthesize userID = _userID;

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
    self.title = self.userID;
    NSString *URLString = [@"http://weibo.com/u/" stringByAppendingString:self.userID];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:URLRequest];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
