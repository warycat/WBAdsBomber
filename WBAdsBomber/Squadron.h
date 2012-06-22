//
//  Squadron.h
//  WBAdsBomber
//
//  Created by Larry on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Squadron : NSManagedObject

@property (nonatomic, retain) NSString * appKey;
@property (nonatomic, retain) NSString * appSecret;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *bombers;
@end

@interface Squadron (CoreDataGeneratedAccessors)

- (void)addBombersObject:(NSManagedObject *)value;
- (void)removeBombersObject:(NSManagedObject *)value;
- (void)addBombers:(NSSet *)values;
- (void)removeBombers:(NSSet *)values;

@end
