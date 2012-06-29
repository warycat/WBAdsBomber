//
//  MainViewController.m
//  WBAdsBomber
//
//  Created by Larry on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "Victim.h"
#import "ImageViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize imagePickerController = _imagePickerController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize flipsidePopoverController = _flipsidePopoverController;
@synthesize imageView = _imageView;

- (IBAction)selectImage:(id)sender {
    [self presentModalViewController:self.imagePickerController animated:YES];
    
}

- (IBAction)deleteVictims:(id)sender {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Victim"];
    NSError *error = nil;
    [fetchRequest setIncludesPropertyValues:NO];
    NSArray *fetchedResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%@",error);
        abort();
    }
    for (Victim *victim in fetchedResults) {
        [self.managedObjectContext deleteObject:victim];
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (UIImagePickerController *)imagePickerController
{
    if (_imagePickerController) {
        return _imagePickerController;
    }
    _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    return _imagePickerController;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    ImageViewController *imageViewController = [storyboard instantiateViewControllerWithIdentifier:@"ImageViewController"];
    [self.imagePickerController pushViewController:imageViewController animated:YES];
    imageViewController.imageView.image = image;
    imageViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWithImage:)];
}

- (void)doneWithImage:(id)sender
{
    NSLog(@"%@",sender);
    ImageViewController *imageViewController = (ImageViewController *)self.imagePickerController.topViewController;
    self.imageView.image = imageViewController.imageView.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.image = imageViewController.imageView.image;
    [self dismissModalViewControllerAnimated:YES];
}

@end
