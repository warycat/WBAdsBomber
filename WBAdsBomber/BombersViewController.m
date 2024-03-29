//
//  BombersViewController.m
//  WBAdsBomber
//
//  Created by Larry on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BombersViewController.h"
#import "AppDelegate.h"
#import "Bomber.h"
#import "TargetsViewController.h"
#import "DetailViewController.h"

@interface BombersViewController ()

@end

@implementation BombersViewController

@synthesize squadron = _squadron;
@synthesize engine = _engine;
@synthesize fetchedResultsController = _fetchedResultsController;

- (IBAction)addBomber:(id)sender {
    [self.engine logIn];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TargetsSegue"]) {
        NSLog(@"TargetsSegue");
        YYWBEngine *engine = [[YYWBEngine alloc]initWithAppKey:self.squadron.appKey appSecret:self.squadron.appSecret];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Bomber *bomber = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [engine setAuthorizeDataWithAccessToken:bomber.accessToken userID:bomber.userID expiresAt:bomber.expiration];
        TargetsViewController *targetsViewController = segue.destinationViewController;
        engine.delegate = segue.destinationViewController;
        targetsViewController.engine = engine;
        targetsViewController.bomber = bomber;
    }
    
    if ([segue.identifier isEqualToString:@"DetailSegue"]) {
        NSLog(@"DetailSegue");

        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Bomber *bomber = [self.fetchedResultsController objectAtIndexPath:indexPath];
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.userID = bomber.userID;
    }
}

- (YYWBEngine *)engine
{
    if (_engine) {
        return _engine;
    }
    _engine = [[YYWBEngine alloc]initWithAppKey:self.squadron.appKey appSecret:self.squadron.appSecret];
    _engine.delegate = self;
    _engine.dataDelegate = self;
    _engine.isUserExclusive = NO;
    return _engine;
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bomber"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.squadron == %@",self.squadron];
    fetchRequest.predicate = predicate;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"expiration" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:20];
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:self.managedObjectContext
                                                                     sectionNameKeyPath:Nil
                                                                              cacheName:Nil];
    _fetchedResultsController.delegate = self;
	NSError *error = nil;
	if (![_fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    return _fetchedResultsController;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Bomber *bomber = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = bomber.userID;
    cell.detailTextLabel.text = bomber.expiration.description;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BomberCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DetailSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Bomber *bomber = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:bomber];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }    
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - WBDataDelegate

- (void)saveWithAccessToken:(NSString *)theAccessToken userID:(NSString *)theUserID expiresAt:(NSDate *)expiration
{
    NSLog(@"save");
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bomber"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@",theUserID];
    fetchRequest.predicate = predicate;
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%@",error);
        abort();
    }
    Bomber *bomber = nil;
    if ((bomber = [results lastObject])) {
        bomber.accessToken = theAccessToken;
        bomber.userID = theUserID;
        bomber.expiration = expiration;
    }else {
        bomber = [NSEntityDescription insertNewObjectForEntityForName:@"Bomber"
                                               inManagedObjectContext:self.managedObjectContext];
        bomber.accessToken = theAccessToken;
        bomber.userID = theUserID;
        bomber.expiration = expiration;
        bomber.squadron = self.squadron;
    }
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
}

@end
