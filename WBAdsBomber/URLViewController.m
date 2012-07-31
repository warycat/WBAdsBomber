//
//  URLViewController.m
//  WBAdsBomber
//
//  Created by Larry on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "URLViewController.h"
#import "AppDelegate.h"
#import "Bomber.h"
#import "Squadron.h"

@interface URLViewController ()

@end

@implementation URLViewController
@synthesize LongTextField;
@synthesize ShortLabel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize engine = _engine;

- (IBAction)deleteURL:(id)sender {
    self.LongTextField.text = @"";
    self.ShortLabel.text = @"";
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.short_url = @"";
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    _managedObjectContext = appDelegate.managedObjectContext;
    return _managedObjectContext;
}


- (void)viewDidUnload
{
    [self setLongTextField:nil];
    [self setShortLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bomber"];
    NSError *error = nil;
    NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%@",error);
        abort();
    }
    Bomber *bomber = [fetchedResults lastObject];
    if (bomber) {
        Squadron *squadron = bomber.squadron;
        self.engine = [[YYWBEngine alloc]initWithAppKey:squadron.appKey appSecret:squadron.appSecret];
        [self.engine setAuthorizeDataWithAccessToken:bomber.accessToken userID:bomber.userID expiresAt:bomber.expiration];
        self.engine.delegate = self;
        NSString *url = [@"http://" stringByAppendingString:self.LongTextField.text];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url_long", nil];
        [self.engine loadRequestWithMethodName:@"short_url/shorten.json" httpMethod:@"GET" params:params postDataType:kWBRequestPostDataTypeNone httpHeaderFields:nil];
    }
}


- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"%@",result);
    NSArray *urls = [result objectForKey:@"urls"];
    NSDictionary *urlDict = [urls lastObject];
    NSString *url = [urlDict objectForKey:@"url_short"];
    self.ShortLabel.text = url;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.short_url = [url substringFromIndex:7 ];
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
@end
