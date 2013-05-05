//
//  Transaction.h
//  PlaybulbAH
//
//  Created by soedar on 5/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property (nonatomic, readonly) BOOL claimed;
@property (nonatomic, strong, readonly) NSString *cardCode;
@property (nonatomic, strong, readonly) NSString *offerId;
@property (nonatomic, strong, readonly) NSString *txnId;

+ (Transaction*) txnFromDictionary:(NSDictionary*)dictionary withId:(NSString*)txnId;

@end
