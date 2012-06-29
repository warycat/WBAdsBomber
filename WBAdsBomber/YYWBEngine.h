//
//  YYWBEngine.h
//  WBAdsBomber
//
//  Created by Larry on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WBEngine.h"
@protocol WBDataDelegate <NSObject>
@optional
- (void)saveWithAccessToken:(NSString *)theAccessToken userID:(NSString *)theUserID expiresAt:(NSDate *)expiration;
@end

@interface YYWBEngine : WBEngine

@property (weak, nonatomic) id<WBDataDelegate> dataDelegate;
- (void)setAuthorizeDataWithAccessToken:(NSString *)theAccessToken userID:(NSString *)theUserID expiresAt:(NSDate *)expiration;
- (void)loadRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(WBRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields 
                          handler:(id<WBRequestDelegate>)handler;
@end
