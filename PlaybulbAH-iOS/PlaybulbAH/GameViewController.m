//
//  GameViewController.m
//  PlaybulbAH
//
//  Created by soedar on 4/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttonList;

@end

@implementation GameViewController

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


- (IBAction)buttonTapped:(UIButton*)button
{
    NSLog(@"%i", button.tag);
}

@end
