//
//  YYWBEngine.m
//  WBAdsBomber
//
//  Created by Larry on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YYWBEngine.h"

@implementation YYWBEngine
@synthesize dataDelegate = _dataDelegate;

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret
{
    NSLog(@"yyinit");
    if (self = [super init])
    {
        self.appKey = theAppKey;
        self.appSecret = theAppSecret;
        
        isUserExclusive = NO;
        
        //[self readAuthorizeDataFromKeychain];
    }
    
    return self;
}

- (void)logOut
{
    //[self deleteAuthorizeDataInKeychain];
    
    if ([delegate respondsToSelector:@selector(engineDidLogOut:)])
    {
        [delegate engineDidLogOut:self];
    }
}

- (void)authorize:(WBAuthorize *)authorize didSucceedWithAccessToken:(NSString *)theAccessToken userID:(NSString *)theUserID expiresIn:(NSInteger)seconds
{
    NSLog(@"yyauthorize");
    self.accessToken = theAccessToken;
    self.userID = theUserID;
    self.expireTime = [[NSDate date] timeIntervalSince1970] + seconds;
    
    if ([self.dataDelegate respondsToSelector:@selector(saveWithAccessToken:userID:expiresAt:)]) {
        [self.dataDelegate saveWithAccessToken:self.accessToken
                                        userID:self.userID
                                     expiresAt:[NSDate dateWithTimeIntervalSince1970:self.expireTime]];        
    }

    //    [self saveAuthorizeDataToKeychain];
    
    if ([delegate respondsToSelector:@selector(engineDidLogIn:)])
    {
        [delegate engineDidLogIn:self];
    }
    //prevent auto login
    [self loadRequestWithMethodName:@"account/end_session.json"
                         httpMethod:@"GET"
                             params:nil
                       postDataType:kWBRequestPostDataTypeNone
                   httpHeaderFields:nil];
}

- (void)setAuthorizeDataWithAccessToken:(NSString *)theAccessToken userID:(NSString *)theUserID expiresAt:(NSDate *)expiration
{
    self.accessToken = theAccessToken;
    self.userID = theUserID;
    self.expireTime = [expiration timeIntervalSince1970];
}

- (void)saveAuthorizeDataToKeychain
{
    NSLog(@"saveAuthorizeDataToKeychain This should never be called");
}

- (void)readAuthorizeDataFromKeychain
{
    NSLog(@"readAuthorizeDataFromKeychain This should never be called");
}

- (void)deleteAuthorizeDataInKeychain
{
    NSLog(@"deleteAuthorizeDataInKeychain This should never be called");
}@end
