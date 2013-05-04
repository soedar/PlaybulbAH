//
//  GameViewController.m
//  PlaybulbAH
//
//  Created by soedar on 4/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "GameViewController.h"

const CGFloat DEFAULT_TICK_DURATION = 1;

@interface GameViewController ()

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttonList;
@property (nonatomic) CGFloat tickDuration;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tickDuration = DEFAULT_TICK_DURATION;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.tickDuration target:self selector:@selector(tick:) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Ticks

- (void) tick:(NSTimer*)timer
{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.tickDuration target:self selector:@selector(tick:) userInfo:nil repeats:NO];
}

#pragma mark - Button actions

- (IBAction)buttonTapped:(UIButton*)button
{
    NSLog(@"%i", button.tag);
}

@end
