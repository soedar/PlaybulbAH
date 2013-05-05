//
//  OfferDetailsViewController.m
//  PlaybulbAH
//
//  Created by soedar on 5/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "OfferDetailsViewController.h"
#import <Firebase/Firebase.h>

@interface OfferDetailsViewController ()

@property (nonatomic, strong) Offer *offer;

@property (nonatomic, weak) IBOutlet UILabel *longDescLabel;
@property (nonatomic, weak) IBOutlet UILabel *offerLabel;

@end

@implementation OfferDetailsViewController

- (id)initWithOffer:(Offer *)offer
{
    self = [self init];
    if (self) {
        self.offer = offer;
        self.title = offer.vendorName;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.offerLabel.text = self.offer.offerName;
    self.longDescLabel.text = self.offer.longDescription;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makeTransaction:(id)sender
{
    Firebase *newFbTransaction = [[[Firebase alloc] initWithUrl:@"https://playbulb.firebaseio.com/transactions"] childByAutoId];

    NSDictionary *transaction = @{@"comment": @"",
                                  @"isClaimed": @(0),
                                  @"offerId": @(self.offer.offerID),
                                  @"timeStamp": @((int)[[NSDate date] timeIntervalSince1970])};
    [newFbTransaction setValue:transaction withCompletionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
        
        NSString *message = [NSString stringWithFormat:@"You have purchased %@'s %@", self.offer.vendorName, self.offer.shortDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Complete" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddMoreLives" object:@(self.offer.reward)];
    }];
}

@end
