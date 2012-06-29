//
//  WBResponseHandler.m
//  WBAdsBomber
//
//  Created by Larry on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WBResponseHandler.h"

@implementation WBResponseHandler

@synthesize delegate = _delegate;

- (void)request:(WBRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([self.delegate respondsToSelector:@selector(handleRequest:withResult:)]) {
        [self.delegate handleRequest:request withResult:result];
    }
}

- (void)request:(WBRequest *)request didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(handleRequest:withError:)]) {
        [self.delegate handleRequest:request withError:error];
    }
}

@end
