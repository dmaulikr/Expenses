//
//  ExpensesTableViewController.m
//  Expenses
//
//  Created by Hendrik Noeller on 29.06.14.
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

- (void)viewDidAppear:(BOOL)animated
{
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
        return 1;
    }
    return [self.account.expenses count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row < [tableView numberOfRowsInSection:0]-1) {
            Expense *expense = self.account.expenses[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellAdd" forIndexPath:indexPath];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellSum" forIndexPath:indexPath];
        
        cell.textLabel.text = @"Σ";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%.02f", [self.account currencyWithSpace], self.account.saldo];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"ENTRY_LIST_EXPENSES", @"");
    }
    return @"";
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 1 || (indexPath.section == 0 && indexPath.row == [tableView numberOfRowsInSection:0]-1)) {
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.account removeExpenseAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
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
                
                if (indexPath.section == 0 && indexPath.row < [self.tableView numberOfRowsInSection:0]-1) {
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
