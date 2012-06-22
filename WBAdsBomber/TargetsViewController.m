//
//  TargetsViewController.m
//  WBAdsBomber
//
//  Created by Larry on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TargetsViewController.h"

@interface TargetsViewController ()

@end

@implementation TargetsViewController

@synthesize engine = _engine;
@synthesize targets = _targets;


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.engine.userID,@"uid",
                            [NSNumber numberWithInt:200],@"count",
                            [NSNumber numberWithInt:0],@"trim_status", nil];
    [self.engine loadRequestWithMethodName:@"friendships/friends.json"
                                httpMethod:@"GET"
                                    params:params
                              postDataType:kWBRequestPostDataTypeNone
                          httpHeaderFields:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.targets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TargetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [[self.targets objectAtIndex:indexPath.row]objectForKey:@"name"];
    cell.detailTextLabel.text = [[self.targets objectAtIndex:indexPath.row]objectForKey:@"description"];
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
#pragma mark - WBEngin delegate

- (void)engineAlreadyLoggedIn:(WBEngine *)engine;
{
    NSLog(@"engineAlreadyLoggedIn");
}

// Log in successfully.
- (void)engineDidLogIn:(WBEngine *)engine
{
    NSLog(@"engineDidLogIn");
}

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failed To Log In"
                                                   message:@"relaunch this app"
                                                  delegate:self
                                         cancelButtonTitle:@"ok"
                                         otherButtonTitles: nil];
    [alert show];
    abort();
}

// Log out successfully.
- (void)engineDidLogOut:(WBEngine *)engine;
{
    NSLog(@"engineDidLogOut");
}

// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
- (void)engineNotAuthorized:(WBEngine *)engine
{
    NSLog(@"engineNotAuthorized this show never be called");
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    NSLog(@"engineAuthorizeExpired this is common after 24 hours, let the user log in again");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"engineAuthorizeExpired"
                                                   message:@"this is common after 24 hours"
                                                  delegate:self
                                         cancelButtonTitle:@"ok"
                                         otherButtonTitles: nil];
    [alert show];
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"%@",engine.request.url);
    NSLog(@"%@",result);
    self.targets = [result objectForKey:@"users"];
    [self.tableView reloadData];
}

@end
