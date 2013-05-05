//
//  OffersViewController.m
//  PlaybulbAH
//
//  Created by soedar on 4/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "OffersViewController.h"
#import "OfferDetailsViewController.h"
#import "Offer.h"
#import <Firebase/Firebase.h>

@interface OffersViewController ()

@property (nonatomic, weak) IBOutlet UITableView *offersTableView;

@property (nonatomic, strong) NSArray *offerList;
@end

@implementation OffersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Offers";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSString *url = @"https://playbulb.firebaseio.com/offers";
    Firebase* dataRef = [[Firebase alloc] initWithUrl:url];
    [dataRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // do some stuff once
        NSDictionary *offerDictionary = snapshot.value;
        
        NSMutableArray *offerList = [NSMutableArray array];
        for (NSString *key in [offerDictionary allKeys]) {
            Offer *offer = [Offer offerFromDictionary:offerDictionary[key]];
            [offerList addObject:offer];
        }
        
        self.offerList = offerList;
        [self.offersTableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource and delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.offerList.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"offerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    Offer *offer = self.offerList[indexPath.row];
    
    cell.textLabel.text = offer.offerName;
    cell.detailTextLabel.text = offer.shortDescription;
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Offer *offer = self.offerList[indexPath.row];
    OfferDetailsViewController *detailsViewController = [[OfferDetailsViewController alloc] initWithOffer:offer];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

@end
