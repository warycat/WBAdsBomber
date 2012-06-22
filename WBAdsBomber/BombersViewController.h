//
//  BombersViewController.h
//  WBAdsBomber
//
//  Created by Larry on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchedResultsViewController.h"
#import "YYWBEngine.h"
#import "Squadron.h"


@interface BombersViewController : FetchedResultsViewController<WBEngineDelegate,WBDataDelegate>

@property (strong, nonatomic) Squadron *squadron;
@property (strong, nonatomic) YYWBEngine *engine;

@end
