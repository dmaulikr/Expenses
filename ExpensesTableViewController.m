//
//  ExpensesTableViewController.m
//  Expenses
//
//  Created by Hendrik Noeller on 29.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "ExpensesTableViewController.h"
#import "Expense.h"
#import "AddEntryViewController.h"
#import "SettingsViewController.h"
#import "StaticValues.h"

@interface ExpensesTableViewController ()
@property (strong, nonatomic) NSString* createdExpenseName;
@end

@implementation ExpensesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.navigationItem.title = self.account.name;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }
    return [self.account.expenses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        Expense *expense = self.account.expenses[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        cell.textLabel.text = expense.name;
        
        if(expense.amount >= 0) {
            cell.detailTextLabel.textColor = GREEN_COLOR;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"+ %@%.02f", [self.account currencyWithSpace], (((float)expense.amount)/100.0)];
        } else {
            cell.detailTextLabel.textColor = RED_COLOR;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"- %@%.02f", [self.account currencyWithSpace], (((float)expense.amount)/-100.0)];
        }
        
        return cell;
    } else {
        UITableViewCell *cell;
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellAdd" forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSum" forIndexPath:indexPath];
            
            cell.textLabel.text = @"Σ";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%.02f", [self.account currencyWithSpace], self.account.saldo];
        }
        return cell;
    }
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.account removeExpenseAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.account moveExpenseFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *destinationNavigation = segue.destinationViewController;
        if([destinationNavigation.viewControllers[0] isKindOfClass:[AddEntryViewController class]]) {
            AddEntryViewController *destination = destinationNavigation.viewControllers[0];
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell *cell = sender;
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                if (indexPath.section == 0) {
                    destination.account = self.account;
                    destination.expense = self.account.expenses[indexPath.row];
                    destination.indexOfExpense = [self.tableView indexPathForCell:cell].row;
                } else {
                    destination.account = self.account;
                }
            } else if ([sender isKindOfClass:[UIButton class]]) {
                destination.account = self.account;
            }
        }
    } else if ([segue.destinationViewController isKindOfClass:[SettingsViewController class]]) {
        SettingsViewController* destination = segue.destinationViewController;
        destination.account = self.account;
    }
}

@end
