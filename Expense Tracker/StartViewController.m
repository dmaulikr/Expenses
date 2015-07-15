//
//  StartViewController.m
//  Expenses
//
//  Created by Hendrik Noeller on 29.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "StartViewController.h"
#import "ExpenseManager.h"
#import "Account.h"

#import "ExpensesTableViewController.h"
#import "SettingsViewController.h"

#import "CompletionCircleView.h"
#import "AccountCell.h"

@interface StartViewController ()
@property (strong, nonatomic) ExpenseManager *manager;
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
    self.manager = [ExpenseManager sharedManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableView Data Source & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.manager.accounts count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //Account Cell
        AccountCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell" forIndexPath:indexPath];
        cell.account = self.manager.accounts[indexPath.row];
        
        return cell;
    } else {
        //Last Cell = Plus cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell" forIndexPath:indexPath];
        return cell;
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"ACCOUNT_LIST_ACCOUNTS", @"");
    }
    return @"";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.manager removeAccountAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self addAccount];
    }
}


#pragma mark - Storyboarding

- (IBAction)addAccount
{
    [self.manager addAccount];
    [self performSegueWithIdentifier:@"Settings" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([segue.destinationViewController isKindOfClass:[ExpensesTableViewController class]]) {
            ExpensesTableViewController *destination = segue.destinationViewController;
            UITableViewCell *cell = sender;
            destination.account = self.manager.accounts[[self.tableView indexPathForCell:cell].row];
        }
    } else if ([segue.destinationViewController isKindOfClass:[SettingsViewController class]]) {
        SettingsViewController *destination = segue.destinationViewController;
        destination.account = [self.manager.accounts lastObject];
    }
}


@end
