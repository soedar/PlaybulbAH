//
//  OffersViewController.m
//  PlaybulbAH
//
//  Created by soedar on 4/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "OffersViewController.h"
#import "OfferDetailsViewController.h"

@interface OffersViewController ()

@property (nonatomic, weak) IBOutlet UITableView *offersTableView;

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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource and delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"offerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    cell.textLabel.text = @"Name of company";
    cell.detailTextLabel.text = @"Name of offer";
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OfferDetailsViewController *detailsViewController = [[OfferDetailsViewController alloc] init];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

@end
