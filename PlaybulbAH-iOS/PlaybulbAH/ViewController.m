//
//  ViewController.m
//  PlaybulbAH
//
//  Created by soedar on 4/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"
#import "OffersViewController.h"
#import "Colors.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self setupStartGameButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupStartGameButton
{
    self.startButton.backgroundColor = BUTTON_BACKGROUND_COLOR;
    self.startButton.layer.masksToBounds = YES;
    self.startButton.layer.cornerRadius = 8.0f;
    
    [self.startButton setTitle:@"PLAY" forState:UIControlStateNormal];
}


- (IBAction)startButtonTapped:(id)sender
{
    GameViewController *gameViewController = [[GameViewController alloc] init];
    [self presentViewController:gameViewController animated:YES completion:nil];
}

@end
