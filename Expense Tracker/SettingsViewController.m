//
//  SettingsViewController.m
//  Expenses
//
//  Created by Hendrik Noeller on 19.07.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *currencySegmented;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.account.expenses count] == 0) {
        self.deleteButton.hidden = YES;
    } else {
        self.deleteButton.hidden = NO;
    }
    
    [self setSegmentedToCurrentCurrency];
    
    self.nameField.text = self.account.name;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.nameField becomeFirstResponder];
}

- (void)setSegmentedToCurrentCurrency
{
    [_currencySegmented setSelectedSegmentIndex:4];
    for (int i = 0; i < [_currencySegmented numberOfSegments]; i++) {
        if ([[_currencySegmented titleForSegmentAtIndex:i] isEqualToString:self.account.currency]) {
            [_currencySegmented setSelectedSegmentIndex:i];
        }
    }
}


- (IBAction)didChangeName:(id)sender
{
    self.account.name = self.nameField.text;
}

- (IBAction)didChangeCurrency:(id)sender
{
    if ([_currencySegmented selectedSegmentIndex] == 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SETTINGS_CUSTOM_TITLE", @"")
                                                        message:NSLocalizedString(@"SETTINGS_CUSTOM_MESSAGE", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"SETTINGS_CUSTOM_CANCEL", @"")
                                              otherButtonTitles:NSLocalizedString(@"SETTINGS_CUSTOM_OK", @""), nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [self.nameField resignFirstResponder];
        [alert show];
    } else {
        self.account.currency = [_currencySegmented titleForSegmentAtIndex:[_currencySegmented selectedSegmentIndex]];
    }
}
- (IBAction)deleteAllEntrys:(id)sender
{
    [[[UIActionSheet alloc] initWithTitle:@"Delete all entrys?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles: nil] showFromRect:_deleteButton.frame inView:self.view animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.account removeAllExpenses];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.account.currency = [alertView textFieldAtIndex:0].text;
    }
    [self setSegmentedToCurrentCurrency];
}

@end
