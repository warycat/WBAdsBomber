//
//  VictimsViewController.h
//  WBAdsBomber
//
//  Created by Larry on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchedResultsViewController.h"
#import "YYWBEngine.h"

@interface VictimsViewController : FetchedResultsViewController <WBEngineDelegate>

@property (strong, nonatomic)NSTimer *timer;
@property (strong, nonatomic)NSArray *bombers;
@property (strong, nonatomic)YYWBEngine *engine;

@end
