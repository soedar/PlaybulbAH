//
//  Offer.h
//  PlaybulbAH
//
//  Created by soedar on 5/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offer : NSObject<NSCoding>

@property (nonatomic, readonly) int cost;
@property (nonatomic, readonly) int reward;
@property (nonatomic, readonly) CGFloat profit;
@property (nonatomic, strong, readonly) NSString *offerID;
@property (nonatomic, strong, readonly) NSString *shortDescription;
@property (nonatomic, strong, readonly) NSString *longDescription;
@property (nonatomic, strong, readonly) NSString *offerName;
@property (nonatomic, strong, readonly) NSString *vendorID;
@property (nonatomic, strong, readonly) NSString *vendorName;

+ (Offer*) offerFromDictionary:(NSDictionary*)dictionary withId:(NSString*)offerId;

@end
