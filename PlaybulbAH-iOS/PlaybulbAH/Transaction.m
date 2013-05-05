//
//  Transaction.m
//  PlaybulbAH
//
//  Created by soedar on 5/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "Transaction.h"

@interface Transaction ()

@property (nonatomic, strong) NSString *txnId;
@property (nonatomic, strong) NSDictionary *dataDictionary;

@end

@implementation Transaction

+ (Transaction*) txnFromDictionary:(NSDictionary *)dictionary withId:(NSString *)txnId
{
    Transaction *txn = [[Transaction alloc] init];
    if (txn) {
        txn.dataDictionary = dictionary;
        txn.txnId = txnId;
    }
    return txn;
}

- (NSString*) cardCode
{
    return self.dataDictionary[@"cardCode"];
}

- (BOOL) claimed
{
    int claimed = [self.dataDictionary[@"claimed"] intValue];
    return claimed != 0;
}

- (NSString*) offerId
{
    return self.dataDictionary[@"offerId"];
}

- (NSString*) offerName
{
    return self.dataDictionary[@"offerName"];
}

@end
