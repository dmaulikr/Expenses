//
//  SettingsViewController.m
//  Expenses
//
//  Created by Hendrik Noeller on 19.07.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
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
    [self setSegmentedToCurrentCurrency];
}

- (void)setSegmentedToCurrentCurrency
{
    [_currencySegmented setSelectedSegmentIndex:4];
    for (int i = 0; i < [_currencySegmented numberOfSegments]; i++) {
        if ([[_currencySegmented titleForSegmentAtIndex:i] isEqualToString:_manager.currency]) {
            [_currencySegmented setSelectedSegmentIndex:i];
        }
    }
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
        [alert show];
    } else {
        _manager.currency = [_currencySegmented titleForSegmentAtIndex:[_currencySegmented selectedSegmentIndex]];
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
        [_manager removeAllExpenses];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _manager.currency = [alertView textFieldAtIndex:0].text;
    } else {
        [self setSegmentedToCurrentCurrency];
    }
}

@end
