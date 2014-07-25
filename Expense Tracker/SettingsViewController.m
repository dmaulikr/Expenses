//
//  SettingsViewController.m
//  Expense Tracker
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
    for (int i = 0; i < [_currencySegmented numberOfSegments]; i++) {
        if ([[_currencySegmented titleForSegmentAtIndex:i] isEqualToString:_manager.currency]) {
            [_currencySegmented setSelectedSegmentIndex:i];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didChangeCurrency:(id)sender
{
    _manager.currency = [_currencySegmented titleForSegmentAtIndex:[_currencySegmented selectedSegmentIndex]];
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

@end
