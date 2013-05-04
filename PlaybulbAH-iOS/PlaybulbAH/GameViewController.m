//
//  GameViewController.m
//  PlaybulbAH
//
//  Created by soedar on 4/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "GameViewController.h"

const CGFloat DEFAULT_TICK_DURATION = 0.3;
const int MAX_DISTRACTIONS = 3;

typedef enum {
    BoxStateEmpty,
    BoxStateTarget,
    BoxStateDistraction
} BoxState;

@interface GameViewController ()

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttonList;
@property (nonatomic) CGFloat tickDuration;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) int targetIndex;
@property (nonatomic) int targetTicksRemaining;

@property (nonatomic, strong) NSMutableArray *distractionIndexes;
@property (nonatomic) int distractionsTickRemaining;


@property (nonatomic) int redCount;
@property (nonatomic) int blueCount;
@property (nonatomic, weak) IBOutlet UILabel *redLabel;
@property (nonatomic, weak) IBOutlet UILabel *blueLabel;

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tickDuration = DEFAULT_TICK_DURATION;
        self.targetTicksRemaining = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.redLabel.text = @"0";
    self.blueLabel.text = @"0";
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.tickDuration target:self selector:@selector(tick:) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Box logic

- (void) setButtonAtIndex:(int)index withState:(BoxState)boxState
{
    UIButton *button = self.buttonList[index];
    switch (boxState) {
        case BoxStateEmpty:
            button.backgroundColor = [UIColor blackColor];
            break;
        case BoxStateTarget:
            button.backgroundColor = [UIColor redColor];
            break;
        case BoxStateDistraction:
            button.backgroundColor = [UIColor blueColor];
            break;
    }
}

- (BoxState) boxStateAtIndex:(int) index
{
    if (index == self.targetIndex) {
        return BoxStateTarget;
    }

    else if ([self.distractionIndexes containsObject:@(index)]) {
        return BoxStateDistraction;
    }

    return BoxStateEmpty;
}

#pragma mark - Ticks

- (void) tick:(NSTimer*)timer
{
    [self hideDistractions];
    [self adjustTarget];
    [self showDistractions];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.tickDuration target:self selector:@selector(tick:) userInfo:nil repeats:NO];
}

- (BOOL) shouldShowTargetThisTick {
    return arc4random()%2;
}

#pragma mark - Target and Distraction logic

- (void) adjustTarget
{
    // If we should continue to show the target, we decrement the count
    if (self.targetTicksRemaining > 0) {
        self.targetTicksRemaining--;
    }
    
    else {
        // Set currently highlighted box to empty
        if (self.targetIndex != -1) {
            [self setButtonAtIndex:self.targetIndex withState:BoxStateEmpty];
            self.targetIndex = -1;
        }
        
        // If there are no more ticks left, determine if we want to show target this round
        if ([self shouldShowTargetThisTick]) {
            self.targetTicksRemaining = arc4random()%2+1;
            self.targetIndex = arc4random()%self.buttonList.count;
            [self setButtonAtIndex:self.targetIndex withState:BoxStateTarget];
        }
    }
}

- (void) hideDistractions
{
    if (self.distractionsTickRemaining > 0) {
        self.distractionsTickRemaining--;
    }
    else {
        for (NSNumber *index in self.distractionIndexes) {
            [self setButtonAtIndex:index.intValue withState:BoxStateEmpty];
        }
        self.distractionIndexes = [NSMutableArray array];
    }
}

- (void) showDistractions
{
    if (self.distractionIndexes.count == 0) {
        int numberDistractions = arc4random()%(MAX_DISTRACTIONS+1);
        
        int i=0;
        // Generate number of distractions
        while (i < numberDistractions) {
            int index = -1;
            do {
                index = arc4random()%9;
            } while (self.targetIndex == index);
            
            [self setButtonAtIndex:index withState:BoxStateDistraction];
            [self.distractionIndexes addObject:@(index)];
            i++;
        }
        
        self.distractionsTickRemaining = arc4random()%3;
    }
}


#pragma mark - Button actions

- (IBAction)buttonTapped:(UIButton*)button
{
    BoxState boxState = [self boxStateAtIndex:button.tag];
    switch (boxState) {
        case BoxStateTarget:
            [self setButtonAtIndex:self.targetIndex withState:BoxStateEmpty];
            self.targetIndex = -1;
            self.redCount++;
            break;
        case BoxStateDistraction:
            self.blueCount++;
            break;
        case BoxStateEmpty:
            break;
    }
    
    [self updateLabels];
}

- (void) updateLabels
{
    self.blueLabel.text = [NSString stringWithFormat:@"%i", self.blueCount];
    self.redLabel.text = [NSString stringWithFormat:@"%i", self.redCount];
}

@end
