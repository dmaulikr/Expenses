//
//  SettingsViewController.m
//  Expenses
//
//  Created by Hendrik Noeller on 19.07.14.
//  Copyright (c) 2015 Hendrik Noeller. All rights reserved.
//
/*Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.*/
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *currencySegmented;
@property (weak, nonatomic) IBOutlet UIButton *consolidateButton;
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

- (IBAction)consolidateAllEntrys:(id)sender
{
    [self.nameField resignFirstResponder];
    [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"SETTINGS_CONSOLIDATE?", @"")
                                 delegate:self
                        cancelButtonTitle:NSLocalizedString(@"SETTINGS_CANCEL", @"")
                   destructiveButtonTitle:NSLocalizedString(@"SETTINGS_CONSOLIDATE", @"")
                        otherButtonTitles:nil] showFromRect:_deleteButton.frame inView:self.view animated:YES];
}

- (IBAction)deleteAllEntrys:(id)sender
{
    [self.nameField resignFirstResponder];
    [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"SETTINGS_DELETE?", @"")
                                 delegate:self
                        cancelButtonTitle:NSLocalizedString(@"SETTINGS_CANCEL", @"")
                   destructiveButtonTitle:NSLocalizedString(@"SETTINGS_DELETE", @"")
                        otherButtonTitles:nil] showFromRect:_consolidateButton.frame inView:self.view animated:YES];
}

- (IBAction)share:(id)sender
{
    [self.nameField resignFirstResponder];
    NSURL *csvFile = [self.account csvFile];
    if (csvFile) {
        [self presentViewController:[[UIActivityViewController alloc] initWithActivityItems:@[csvFile] applicationActivities:@[]] animated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([actionSheet.title isEqualToString:NSLocalizedString(@"SETTINGS_DELETE?", @"")]) {
            [self.account removeAllExpenses];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([actionSheet.title isEqualToString:NSLocalizedString(@"SETTINGS_CONSOLIDATE?", @"")]) {
            [self.account consolidateAllExpenses];
            [self.navigationController popViewControllerAnimated:YES];
        }
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
