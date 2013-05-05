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
@property (nonatomic, strong) NSString *offerID;

@end

@implementation Offer

+ (Offer*) offerFromDictionary:(NSDictionary *)dictionary withId:(NSString *)offerId
{
    Offer *offer = [[Offer alloc] init];
    if (offer) {
        offer.dataDictionary = dictionary;
        offer.offerID = offerId;
    }
    return offer;
}

#pragma mark - NSCoding

- (id) initWithCoder:(NSCoder *)aDecoder
{
    NSString *offerID = [aDecoder decodeObjectForKey:@"OfferId"];
    NSDictionary *dataDictionary = [aDecoder decodeObjectForKey:@"Data"];
    
    return [Offer offerFromDictionary:dataDictionary withId:offerID];
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.dataDictionary forKey:@"Data"];
    [aCoder encodeObject:self.offerID forKey:@"OfferId"];
}

#pragma mark - Accessors

- (int) cost
{
    return [self.dataDictionary[@"cost"] intValue];
}

- (int) reward
{
    return [self.dataDictionary[@"reward"] intValue];
}

- (CGFloat) profit
{
    return [self.dataDictionary[@"devProfit"] floatValue];
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



@end
