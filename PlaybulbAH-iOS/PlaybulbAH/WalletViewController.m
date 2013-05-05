//
//  WalletViewController.m
//  PlaybulbAH
//
//  Created by soedar on 5/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "WalletViewController.h"
#import <Firebase/Firebase.h>
#import "Transaction.h"
#import "Colors.h"

@interface WalletViewController ()

@property (nonatomic, weak) IBOutlet UITableView *txnTableView;
@property (nonatomic, strong) NSArray *txnList;

@property (nonatomic, strong) NSArray *claimedList;
@property (nonatomic, strong) NSArray *unclaimedList;


@end

@implementation WalletViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Wallet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *url = @"https://playbulb.firebaseio.com/transactions";
    Firebase* dataRef = [[Firebase alloc] initWithUrl:url];
    [dataRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *txnDictionary = snapshot.value;
        
        NSMutableArray *txnList = [NSMutableArray array];
        NSMutableArray *unclaimedList = [NSMutableArray array];
        NSMutableArray *claimedList = [NSMutableArray array];
        
        for (NSString *key in [txnDictionary allKeys]) {
            Transaction *txn = [Transaction txnFromDictionary:txnDictionary[key] withId:key];
            [txnList addObject:txn];
            (txn.claimed) ? [claimedList addObject:txn] : [unclaimedList addObject:txn];
        }
        
        self.txnList = txnList;
        self.claimedList = claimedList;
        self.unclaimedList = unclaimedList;
        
        [self.txnTableView reloadData];
    }];
    [self.view setBackgroundColor:BACKGROUND_COLOR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource and delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? self.unclaimedList.count : self.claimedList.count;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? @"Unclaimed" : @"Claimed";
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"txnCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    Transaction *txn = (indexPath.section == 0) ? self.unclaimedList[indexPath.row] : self.claimedList[indexPath.row];
    
    cell.textLabel.text = txn.offerName;
    cell.detailTextLabel.text = txn.cardCode;
    
    
    return cell;
}

@end
