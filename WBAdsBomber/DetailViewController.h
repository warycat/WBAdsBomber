//
//  DetailViewController.h
//  WBAdsBomber
//
//  Created by Larry on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *userID;
@end
