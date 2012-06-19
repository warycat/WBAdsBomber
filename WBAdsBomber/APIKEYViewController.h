//
//  APIKEYViewController.h
//  WBAdsBomber
//
//  Created by Larry on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APIKEYDelegate <NSObject>
-(void)addkey:(NSDictionary *)key;
@end

@interface APIKEYViewController : UIViewController
@property (weak, nonatomic) id<APIKEYDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;

@end
