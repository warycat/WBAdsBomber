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
#import "WBResponseHandler.h"

@interface VictimsViewController : FetchedResultsViewController <WBEngineDelegate,WBResponseDelegate>

@property (strong, nonatomic)NSTimer *timer;
@property (strong, nonatomic)NSArray *bombers;
@property (strong, nonatomic)YYWBEngine *engine;
@property (strong, nonatomic)UIImage *image;
@property (strong, nonatomic)NSString *url;
@property (strong, nonatomic)WBResponseHandler *handler;

@end
