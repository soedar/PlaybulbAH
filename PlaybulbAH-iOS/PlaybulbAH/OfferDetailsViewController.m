//
//  OfferDetailsViewController.m
//  PlaybulbAH
//
//  Created by soedar on 5/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "OfferDetailsViewController.h"
#import <Firebase/Firebase.h>
#import "Colors.h"

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
    
    [self.view setBackgroundColor:BACKGROUND_COLOR];
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
                                  @"cardCode": [self cardCode],
                                  @"isClaimed": @(0),
                                  @"offerId": self.offer.offerID,
                                  @"offerName": self.offer.offerName,
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

- (NSString *)cardCode
{
    NSMutableString *cardCode = [NSMutableString string];
    for (int i=0;i<3;i++) {
        [cardCode appendFormat:@"%i", [self random4DigitNumber]];
        if (i < 2) {
            [cardCode appendString:@"-"];
        }
    }
    return cardCode;
}

- (int) random4DigitNumber
{
    return (int) (arc4random() % 9000) + 1000;
}

@end
