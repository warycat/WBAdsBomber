//
//  VictimsViewController.m
//  WBAdsBomber
//
//  Created by Larry on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VictimsViewController.h"
#import "AppDelegate.h"
#import "Victim.h"
#import "Bomber.h"
#import "Squadron.h"

#define kTimeInterval 10.0

@interface VictimsViewController ()

@end

@implementation VictimsViewController

@synthesize timer = _timer;
@synthesize bombers = _bombers;
@synthesize engine = _engine;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize image = _image;
@synthesize handler = _handler;

- (IBAction)play:(id)sender {
    [self.timer fire];
}

- (IBAction)pause:(id)sender {
    [self.timer invalidate];
    self.timer = nil;
    self.bombers = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self pause:nil];
}

- (UIImage *)image
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.image;
}

- (NSArray *)bombers
{
    if (_bombers) {
        return _bombers;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Bomber"];
    NSError *error = nil;
    _bombers = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%@",error);
        abort();
    }
    return _bombers;
}

- (YYWBEngine *)engine
{
    if (_engine) {
        return _engine;
    }
    _engine = [[YYWBEngine alloc]init];
    _engine.delegate = self;
    return _engine;
}

- (void)addVictims:(NSString *)uid
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            uid,@"uid",
                            [NSNumber numberWithInt:200].stringValue,@"count",
                            //[NSNumber numberWithInt:cursor].stringValue,@"cursor",
                            nil];
    [self.engine loadRequestWithMethodName:@"friendships/followers/active.json"
                                httpMethod:@"GET"
                                    params:params
                              postDataType:kWBRequestPostDataTypeNone
                          httpHeaderFields:nil];
}

- (WBResponseHandler *)handler
{
    if (_handler) {
        return _handler;
    }
    _handler = [[WBResponseHandler alloc]init];
    _handler.delegate = self;
    NSLog(@"handler");
    return _handler;
}

- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image
{
    NSLog(@"%@ %@",text,image);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            image,@"pic",
                            (text ? text : @""),@"status",
                            nil];  
    
    [self.engine loadRequestWithMethodName:@"statuses/upload.json"
                         httpMethod:@"POST"
                             params:params
                       postDataType:kWBRequestPostDataTypeMultipart
                   httpHeaderFields:nil
                            handler:self.handler];
}

- (void)strike:(NSTimer *)timer
{
    static NSInteger i = 0;
    Bomber *bomber = [self.bombers objectAtIndex:i];
    i = (i+1) % self.bombers.count;
    Squadron *squadron = bomber.squadron;
    self.engine.appKey = squadron.appKey;
    self.engine.appSecret = squadron.appSecret;
    [self.engine setAuthorizeDataWithAccessToken:bomber.accessToken userID:bomber.userID expiresAt:bomber.expiration];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Victim"];
    NSError *error = nil;
    NSArray *fetchedResults = nil;
    NSPredicate *predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"struck == nil"];
    fetchRequest.predicate = predicate;
    fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%@",error);
        abort();
    }
    NSMutableString *text = [NSMutableString stringWithString:@"#cat#"];
    for (Victim *victim in fetchedResults) {
        [text appendFormat:@"@%@ ",victim.name];
    }
    if (text.length > 140) {
        text = [NSMutableString stringWithString:@"#cat#"];
        for (Victim *victim in fetchedResults) {
            NSUInteger length = text.length + victim.name.length + 2;
            if (length > 140) {
                break;
            }
            victim.struck = bomber;
            [text appendFormat:@"@%@ ",victim.name];
        }
        [self sendWeiBoWithText:text image:self.image];
    }else {
        predicate = [NSPredicate predicateWithFormat:@"date == nil"];
        fetchRequest.predicate = predicate;
        fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"%@",error);
            abort();
        }   
        Victim *victim = [fetchedResults lastObject];
        if (!victim) {
            NSLog(@"no victim to add");
        }else {
            NSLog(@"v %d %@",text.length,victim.name);
            victim.date = [NSDate date];
            [self addVictims:victim.userID];                 
        }
    }

}

- (NSTimer *)timer
{
    if (_timer) {
        return _timer;
    }
    if (!self.bombers.count) {
        return nil;
    }
    NSTimeInterval timeInterval = kTimeInterval / self.bombers.count;
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(strike:) userInfo:nil repeats:YES];
    return _timer;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Victim"];
    NSSortDescriptor *sectionSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"struck.userID" ascending:NO];
    NSSortDescriptor *rowSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sectionSortDescriptor,rowSortDescriptor,nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:20];
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:self.managedObjectContext
                                                                     sectionNameKeyPath:@"struck.userID"
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
    Victim *victim = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = victim.name;
    cell.detailTextLabel.text = victim.date.description;
}

#pragma mark - Table view data source

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName
{
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VictimCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
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
    NSLog(@"%@",engine.request.url);
    NSLog(@"%@",error);
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    //NSLog(@"%@",result);
    NSArray *users = [result objectForKey:@"users"];
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Victim"];
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    NSLog(@"%d %d",count,users.count);
    for (NSDictionary *user in users) {
        NSString *name = [user objectForKey:@"name"];
        NSString *uid = [user objectForKey:@"idstr"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", uid];
        fetchRequest.predicate = predicate;
        NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"%@",error);
            abort();
        }
        if ([fetchedResults lastObject]) {
            NSLog(@"exist");
            continue;
        }
        Victim *victim = [NSEntityDescription insertNewObjectForEntityForName:@"Victim" inManagedObjectContext:self.managedObjectContext];
        victim.name = name;
        victim.userID = uid;
    }
}

#pragma mark - WBresponse delegate

- (void)handleRequest:(WBRequest *)request withResult:(id)result
{
    NSLog(@"%@",result);
}

- (void)handleRequest:(WBRequest *)request withError:(NSError *)error
{
    NSLog(@"%@",error);
}


@end
