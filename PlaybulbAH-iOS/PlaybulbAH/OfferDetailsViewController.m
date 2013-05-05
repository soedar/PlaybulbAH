//
//  OfferDetailsViewController.m
//  PlaybulbAH
//
//  Created by soedar on 5/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "OfferDetailsViewController.h"

@interface OfferDetailsViewController ()

@property (nonatomic, strong) Offer *offer;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
