//
//  StartViewController.m
//  Expense Tracker
//
//  Created by Hendrik Noeller on 29.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "StartViewController.h"
#import "ExpenseManager.h"
#import "ExpensesTableViewController.h"
#import "PieChartView.h"
#import "AddEntryViewController.h"

@interface StartViewController ()
@property (strong, nonatomic) ExpenseManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *saldoLabel;
@property (weak, nonatomic) IBOutlet UILabel *positivesLabel;
@property (weak, nonatomic) IBOutlet UILabel *negativesLabel;
@property (weak, nonatomic) IBOutlet PieChartView *pieChartView;
@end

@implementation StartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _manager = [[ExpenseManager alloc] init];
    [self updateInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateInfo];
}

- (void)updateInfo
{
    _saldoLabel.text = [NSString stringWithFormat:@"$%.02f", [_manager saldo]];
    _positivesLabel.text = [NSString stringWithFormat:@"$%.02f", [_manager positives]];
    _negativesLabel.text = [NSString stringWithFormat:@"$%.02f", [_manager negatives]];
    
    if(_manager.positives == 0.0 && _manager.negatives == 0.0) {
        _pieChartView.sliceArray = @[@1.0];
        _pieChartView.colorsArray = @[(id)[UIColor lightGrayColor].CGColor];
    } else {
        float negative = _manager.negatives / _manager.positives;
        float positive = 1.0-negative;
        if (negative < 0) {
            negative = 0.0;
        } else if (negative > 1.0) {
            negative = 1.0;
        }
        
        if (positive < 0) {
            positive = 0.0;
        } else if (positive > 1.0) {
            positive = 1.0;
        }
        
        _pieChartView.sliceArray = @[[NSNumber numberWithFloat:positive], [NSNumber numberWithFloat:negative]];
        _pieChartView.colorsArray = @[(id)_positivesLabel.textColor.CGColor, (id)_negativesLabel.textColor.CGColor];
        [_pieChartView setNeedsDisplay];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ExpensesTableViewController class]]) {
        ExpensesTableViewController *destination = segue.destinationViewController;
        destination.manager = _manager;
    } else if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *destinationNavigation = segue.destinationViewController;
        if([destinationNavigation.viewControllers[0] isKindOfClass:[AddEntryViewController class]]) {
            AddEntryViewController *destination = destinationNavigation.viewControllers[0];
            destination.manager = _manager;
        }
    }
}


@end
