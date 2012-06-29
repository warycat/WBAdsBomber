//
//  WBResponseHandler.h
//  WBAdsBomber
//
//  Created by Larry on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYWBEngine.h"



@protocol WBResponseDelegate <NSObject>

- (void)handleRequest:(WBRequest *)request withResult:(id)result;
- (void)handleRequest:(WBRequest *)request withError:(NSError *)error;

@end

@interface WBResponseHandler : NSObject <WBRequestDelegate>

@property (weak, nonatomic) id<WBResponseDelegate> delegate;

@end
