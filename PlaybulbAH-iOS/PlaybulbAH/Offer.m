//
//  Offer.m
//  PlaybulbAH
//
//  Created by soedar on 5/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "Offer.h"

@interface Offer ()

@property (nonatomic, strong) NSDictionary *dataDictionary;

@end

@implementation Offer

+ (Offer*) offerFromDictionary:(NSDictionary *)dictionary
{
    Offer *offer = [[Offer alloc] init];
    if (offer) {
        offer.dataDictionary = dictionary;
    }
    return offer;
}

- (int) cost
{
    return [self.dataDictionary[@"cost"] intValue];
}

- (int) reward
{
    return [self.dataDictionary[@"reward"] intValue];
}

- (NSString*) shortDescription
{
    return self.dataDictionary[@"description"];
}

- (NSString*) longDescription
{
    return self.dataDictionary[@"longDescription"];
}

- (NSString*) offerName
{
    return self.dataDictionary[@"offerName"];
}

- (NSString*) vendorID
{
    return self.dataDictionary[@"vendorID"];
}

- (NSString*) vendorName
{
    return self.dataDictionary[@"vendorName"];
}

- (int) offerID
{
    return [self.dataDictionary[@"offerId"] intValue];
}




@end
