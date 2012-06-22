//
//  Bomber.h
//  WBAdsBomber
//
//  Created by Larry on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Squadron;

@interface Bomber : NSManagedObject

@property (nonatomic, retain) NSString * accessToken;
@property (nonatomic, retain) NSDate * expiration;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) Squadron *squadron;

@end
