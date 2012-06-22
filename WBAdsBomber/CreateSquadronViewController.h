//
//  CreateSquadronViewController.h
//  WBAdsBomber
//
//  Created by Larry on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateSquadronDelegate <NSObject>

-(void)createSquadronWithKey:(NSString *)key andSecret:(NSString *)secret;

@end

@interface CreateSquadronViewController : UIViewController
@property (weak, nonatomic) id<CreateSquadronDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *secretTextField;

@end
