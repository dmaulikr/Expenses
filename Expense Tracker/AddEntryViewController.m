//
//  AddEntryViewController.m
//  Expense Tracker
//
//  Created by Hendrik Noeller on 30.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "AddEntryViewController.h"
#import "Expense.h"
#import "NSString+CommaFloatValue.h"

@interface AddEntryViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *addSpendSegmented;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation AddEntryViewController

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
    _addSpendSegmented.selectedSegmentIndex = 1;
    _descriptionTextField.text = @"";
    _amountTextField.text = @"";
    [self updateInfoLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_expense) {
        _descriptionTextField.text = _expense.name;
        if (_expense.amount < 0) {
            _amountTextField.text = [NSString stringWithFormat:@"%.02f", ((float)_expense.amount)/-100.0];
            _addSpendSegmented.selectedSegmentIndex = 1;
        } else {
            _amountTextField.text = [NSString stringWithFormat:@"%.02f", ((float)_expense.amount)/100.0];
            _addSpendSegmented.selectedSegmentIndex = 0;
        }
        _amountTextField.text = [_amountTextField.text stringByReplacingOccurrencesOfString:@"." withString:@","];
        
        _infoLabel.hidden = YES;
        self.navigationItem.title = @"Edit Entry";
        [self.amountTextField becomeFirstResponder];
    } else {
        _infoLabel.hidden = NO;
        self.navigationItem.title = @"Add Entry";
        [self.descriptionTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _expense = nil;
    _indexOfExpense = 0;
}

- (IBAction)segmentedDidChange:(id)sender
{
    [self updateInfoLabel];
}

- (IBAction)amountFieldDidChange:(id)sender
{
    [self updateInfoLabel];
}

- (void)updateInfoLabel
{
    float value = 0.0;
    if (_addSpendSegmented.selectedSegmentIndex == 1) {
        value = _manager.saldo-_amountTextField.text.floatValue;
    } else if (_addSpendSegmented.selectedSegmentIndex == 0) {
        
        value = _manager.saldo+_amountTextField.text.floatValue;
    }
    _infoLabel.text = [NSString stringWithFormat:@"You are left with $%.02f", value];
    _infoLabel.text = [_infoLabel.text stringByReplacingOccurrencesOfString:@"." withString:@","];
    if (value < 0) {
        _infoLabel.textColor = [UIColor redColor];
    } else {
        _infoLabel.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)done:(id)sender
{
    NSInteger amount = _amountTextField.text.commaFloatValue*100;
    if (_addSpendSegmented.selectedSegmentIndex == 1) {
        amount = -amount;
    }
    if (_expense) {
        [_manager editExepense:amount name:_descriptionTextField.text atIndex:_indexOfExpense];
    } else {
        [_manager addExpense:amount name:_descriptionTextField.text];
    }
    [self closeModalView];
}

- (IBAction)cancel:(id)sender
{
    [self closeModalView];
}

- (void)closeModalView
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
