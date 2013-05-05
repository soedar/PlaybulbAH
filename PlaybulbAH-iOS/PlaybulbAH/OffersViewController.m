//
//  OffersViewController.m
//  PlaybulbAH
//
//  Created by soedar on 4/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "OffersViewController.h"
#import "AFNetworking.h"
#import "AFOAuth1Client.h"

@interface OffersViewController ()

@end

@implementation OffersViewController

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
    
   
    NSURL *url = [NSURL URLWithString:@"http://api.yelp.com/business_review_search?term=food&lat=37.776975&long=-122.4169947&ywsid=g-eXDxJYxb2gYNU_aHxnwg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"");
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
