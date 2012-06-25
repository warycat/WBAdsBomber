//
//  TargetsViewController.h
//  WBAdsBomber
//
//  Created by Larry on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYWBEngine.h"
#import "Bomber.h"

@interface TargetsViewController : UITableViewController <WBEngineDelegate,WBDataDelegate>

@property (strong, nonatomic)YYWBEngine *engine;
@property (strong, nonatomic)NSArray *targets;
@property (strong, nonatomic)Bomber *bomber;

@end
