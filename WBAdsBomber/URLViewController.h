//
//  URLViewController.h
//  WBAdsBomber
//
//  Created by Larry on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYWBEngine.h"

@interface URLViewController : UIViewController <UITextFieldDelegate,WBEngineDelegate>

@property (weak, nonatomic) IBOutlet UITextField *LongTextField;

@property (weak, nonatomic) IBOutlet UILabel *ShortLabel;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) YYWBEngine *engine;

@end
