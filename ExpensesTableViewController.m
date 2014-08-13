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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_manager.expenses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Expense *expense = _manager.expenses[indexPath.row];
    if(expense.amount >= 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellPositive" forIndexPath:indexPath];
        
        cell.textLabel.text = expense.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"+ %@%.02f", [_manager currencyWithSpace], (((float)expense.amount)/100.0)];
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellNegative" forIndexPath:indexPath];
        
        cell.textLabel.text = expense.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"- %@%.02f", [_manager currencyWithSpace], (((float)expense.amount)/-100.0)];
        
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
        [_manager removeExpenseAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [_manager moveExpenseFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
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
                destination.manager = _manager;
                destination.expense = _manager.expenses[[self.tableView indexPathForCell:cell].row];
                destination.indexOfExpense = [self.tableView indexPathForCell:cell].row;
            } else if ([sender isKindOfClass:[UIBarButtonItem class]]) {
                destination.manager = _manager;
            }
        }
    }
}

@end
