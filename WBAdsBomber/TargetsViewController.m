//
//  TargetsViewController.m
//  WBAdsBomber
//
//  Created by Larry on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TargetsViewController.h"
#import "Victim.h"
#import "AppDelegate.h"

@interface TargetsViewController ()
@property (strong, nonatomic) UITableViewCell *selectedCell;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation TargetsViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize selectedCell = _selectedCell;
@synthesize engine = _engine;
@synthesize targets = _targets;
@synthesize bomber = _bomber;

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    _managedObjectContext = appDelegate.managedObjectContext;
    return _managedObjectContext;
}

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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedCell.accessoryType = UITableViewCellAccessoryNone;
    self.selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSDictionary *target = [self.targets objectAtIndex:indexPath.row];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Victim"];
    NSString *uid = [target objectForKey:@"idstr"];
    NSString *name = [target objectForKey:@"name"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@",uid];
    fetchRequest.predicate = predicate;
    NSError *error = nil;
    NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%@",error);
        abort();
    }
    if ([fetchedResults lastObject]) {
        return;
    }
    Victim *victim = [NSEntityDescription insertNewObjectForEntityForName:@"Victim" inManagedObjectContext:self.managedObjectContext];
    victim.name = name;
    victim.userID = uid;
    victim.struck = self.bomber;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
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
    NSLog(@"engineNotAuthorized this should never be called");
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
