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

@interface WalletViewController ()

@property (nonatomic, weak) IBOutlet UITableView *txnTableView;
@property (nonatomic, strong) NSArray *txnList;

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
        // do some stuff once
        NSDictionary *txnDictionary = snapshot.value;
        
        NSMutableArray *txnList = [NSMutableArray array];
        for (NSString *key in [txnDictionary allKeys]) {
            Transaction *txn = [Transaction txnFromDictionary:txnDictionary[key] withId:key];
            [txnList addObject:txn];
        }
        
        self.txnList = txnList;
        [self.txnTableView reloadData];
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
    return self.txnList.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"txnCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    Transaction *txn = self.txnList[indexPath.row];
    
    cell.textLabel.text = txn.offerName;
    cell.detailTextLabel.text = txn.cardCode;
    
    
    return cell;
}

@end
