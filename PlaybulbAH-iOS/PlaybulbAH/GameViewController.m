//
//  GameViewController.m
//  PlaybulbAH
//
//  Created by soedar on 4/5/13.
//  Copyright (c) 2013 Playbulb. All rights reserved.
//

#import "GameViewController.h"
#import "OffersViewController.h"
#import "WalletViewController.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat DEFAULT_TICK_DURATION = 0.18;
const int MAX_DISTRACTIONS = 5;
const int GAME_DURATION = 1000;
const int TARGET_GOAL = 10;
const int INITIAL_LIFE = 1;

typedef enum {
    BoxStateEmpty,
    BoxStateTarget,
    BoxStateDistraction
} BoxState;

@interface GameViewController ()

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttonList;
@property (nonatomic) CGFloat tickDuration;
@property (nonatomic, strong) NSTimer *tickTimer;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic) int targetIndex;
@property (nonatomic) int targetTicksRemaining;

@property (nonatomic, strong) NSMutableArray *distractionIndexes;
@property (nonatomic) int distractionsTickRemaining;


@property (nonatomic) int scoreCount;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;


@property (nonatomic) int timeLeft;
@property (nonatomic, weak) IBOutlet UILabel *gameTimerLabel;

@property (nonatomic, strong) UIAlertView *startAlertView;
@property (nonatomic, strong) UIAlertView *endAlertView;
@property (nonatomic, strong) UIAlertView *purchaseAlertView;

@property (nonatomic) int lifeCount;
@property (nonatomic, weak) IBOutlet UILabel *lifeLabel;

@property (nonatomic, weak) IBOutlet UIButton *startButton;
@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tickDuration = DEFAULT_TICK_DURATION;
        self.lifeCount = INITIAL_LIFE;
        self.targetTicksRemaining = 0;
        self.distractionsTickRemaining = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.timeLeft = GAME_DURATION;
    [self updateGameTimerLabel];
    [self updateLabels];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLivesAfterPurchase:) name:@"AddMoreLives" object:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (IBAction)startGameTapped:(id)sender
{
    if (self.lifeCount > 0) {
        NSString *message = [NSString stringWithFormat:@"Get %i target before %i seconds", TARGET_GOAL, GAME_DURATION/1000];
        self.startAlertView = [[UIAlertView alloc] initWithTitle:@"Level 1"
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        [self.startAlertView show];
    }
    else {
        self.purchaseAlertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"You have ran out of lives!" delegate:self cancelButtonTitle:@"Get more lives" otherButtonTitles:nil];
        [self.purchaseAlertView show];
    }
}

- (IBAction)playBulbTapped:(id)sender
{
    [self showPlaybulbController];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.startAlertView) {
        [self startGame];
    }
    else if (alertView == self.endAlertView) {
        if (buttonIndex == 0) {
            [self startGame];
        }
    }
    else if (alertView == self.purchaseAlertView) {
        // launch purchase vc
        [self showPlaybulbController];
    }
}

- (void) startGame
{
    self.startButton.hidden = YES;
    self.scoreCount = 0;
    self.timeLeft = GAME_DURATION;
    [self updateLabels];
    [self updateGameTimerLabel];
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateGameTimer:) userInfo:nil repeats:YES];
    [self updateGameTimerLabel];
    self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:self.tickDuration target:self selector:@selector(tick:) userInfo:nil repeats:NO];
    
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat
                     animations:^{
        self.gameTimerLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:nil];
}

- (void) stopGame
{
    self.startButton.hidden = NO;
    [self.tickTimer invalidate];
    self.tickTimer = nil;
    
    for (int i=0;i<self.buttonList.count;i++) {
        [self setButtonAtIndex:i withState:BoxStateEmpty];
    }
    
    if (self.scoreCount < TARGET_GOAL) {
        // User lost a life!
        self.lifeCount--;
        
        if (self.lifeCount > 0) {
            self.endAlertView = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:@"-1 life" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil];
            [self.endAlertView show];
        }
        else {
            self.purchaseAlertView = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"You have ran out of lives!" delegate:self cancelButtonTitle:@"Get more lives" otherButtonTitles:nil];
            [self.purchaseAlertView show];
        }
    }
    else {
        self.endAlertView = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:@"You did it! Improve your score!" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil];
        [self.endAlertView show];
    }
    
    [self updateLabels];
}

#pragma mark - Game Timer

- (void) updateGameTimer:(NSTimer*)timer
{
    if (self.timeLeft <= 0) {
        [self.gameTimer invalidate];
        self.timeLeft = 0;
        [self stopGame];
        [self updateGameTimerLabel];
    }
    else {
        self.timeLeft -= 100;
        [self updateGameTimerLabel];
    }
    
}

- (void) updateGameTimerLabel
{
    self.gameTimerLabel.text = [NSString stringWithFormat:@"%.1f", (self.timeLeft/1000.0)];
}

#pragma mark - Box logic

- (void) setButtonAtIndex:(int)index withState:(BoxState)boxState
{
    UIButton *button = self.buttonList[index];
    switch (boxState) {
        case BoxStateEmpty:
            [button setImage:nil forState:UIControlStateNormal];
            break;
        case BoxStateTarget:
            [button setImage:[UIImage imageNamed:@"Mole"] forState:UIControlStateNormal];
            break;
        case BoxStateDistraction:
            [button setImage:[UIImage imageNamed:@"baby"] forState:UIControlStateNormal];
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
    
    self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:self.tickDuration target:self selector:@selector(tick:) userInfo:nil repeats:NO];
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
            self.targetTicksRemaining = 0;
            self.scoreCount++;
            break;
        case BoxStateDistraction:
            self.scoreCount = MAX(0, --self.scoreCount);
            break;
        case BoxStateEmpty:
            break;
    }
    
    [self updateLabels];
}

- (void) updateLabels
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%i", self.scoreCount];
    self.lifeLabel.text = [NSString stringWithFormat:@"%i", self.lifeCount];
}

#pragma mark - Notification

- (void) addLivesAfterPurchase:(NSNotification*)notification
{
    int lives = [notification.object intValue];
    self.lifeCount += lives;
    [self updateLabels];
}

#pragma mark - Playbulb methds

- (void) showPlaybulbController
{
    UIViewController *playbulbController = [self playbulbController];
    [self presentViewController:playbulbController
                       animated:YES completion:nil];
}

- (void) dismissPlaybulbViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)playbulbController
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style:UIBarButtonItemStyleBordered
                                   target:self action:@selector(dismissPlaybulbViewController)];
    UIBarButtonItem *backButton2 = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Back"
                                    style:UIBarButtonItemStyleBordered
                                    target:self action:@selector(dismissPlaybulbViewController)];
    
    OffersViewController *offersController = [[OffersViewController alloc] init];
    UINavigationController *offersNavController = [[UINavigationController alloc] initWithRootViewController:offersController];
    
    WalletViewController *walletController = [[WalletViewController alloc] init];
    UINavigationController *walletNavController = [[UINavigationController alloc] initWithRootViewController:walletController];
    
    offersController.navigationItem.leftBarButtonItem = backButton;
    walletController.navigationItem.leftBarButtonItem = backButton2;
    
    NSArray *tabViewControllers = [[NSArray alloc] initWithObjects:offersNavController, walletNavController, nil];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:tabViewControllers animated:YES];
    
    return tabBarController;
}


@end
