//
//  ExpenseManager.m
//  Expense Tracker
//
//  Created by Hendrik Noeller on 29.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "ExpenseManager.h"
@interface ExpenseManager ()
@property (strong, nonatomic) NSString *createdExpenseName;
@property (nonatomic) BOOL createdExpensePositive;
@property (nonatomic, copy) void (^completion)();
@end
@implementation ExpenseManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self load];
        if (!_expenses) {
            _expenses = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)load
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/expenses", docDir];
    _expenses = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
}

- (void)save
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/expenses", docDir];
    [NSKeyedArchiver archiveRootObject:_expenses toFile:fileName];
}


#pragma mark - Expense Management

- (void)addExpense:(NSInteger)amount name:(NSString *)name
{
    Expense *expense = [[Expense alloc] init];
    expense.name = name;
    expense.amount = amount;
    [self.expenses addObject:expense];
    [self save];
}

- (void)removeExpenseAtIndex:(NSInteger)index
{
    [_expenses removeObjectAtIndex:index];
    [self save];
}

- (void)moveExpenseFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    Expense *temp = _expenses[fromIndex];
    [_expenses removeObjectAtIndex:fromIndex];
    [_expenses insertObject:temp atIndex:toIndex];
    [self save];
}


#pragma mark - Value Getters

- (float)saldo {
    NSInteger saldo = 0;
    for (Expense *expense in _expenses) {
        saldo = saldo+expense.amount;
    }
    return saldo/100;
}

- (float)positives {
    NSInteger positives = 0;
    for (Expense *expense in _expenses) {
        if(expense.amount > 0) {
            positives = positives + expense.amount;
        }
    }
    return positives/100;
}

- (float)negatives {
    NSInteger negatives = 0;
    for (Expense *expense in _expenses) {
        if(expense.amount < 0) {
            negatives = negatives - expense.amount;
        }
    }
    return negatives/100;
}


#pragma mark - AlertView Management

- (void)showAddAlertView:(void(^)())completion
{
    _completion = completion;
    _createdExpensePositive = YES;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add money"
                                                        message:@"Enter a name"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Next", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
    [[alertView textFieldAtIndex:0] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [alertView show];
}



- (void)showSpendAlertView:(void(^)())completion
{
    _completion = completion;
    _createdExpensePositive = NO;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Spend money"
                                                        message:@"Enter a name"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Next", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
    [[alertView textFieldAtIndex:0] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([alertView.message isEqualToString:@"Enter a name"]) {
            _createdExpenseName = [alertView textFieldAtIndex:0].text;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add entry"
                                                                message:@"Enter the amount"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Add", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
            [alertView show];
        } else if ([alertView.message isEqualToString:@"Enter the amount"]) {
            int value = [[alertView textFieldAtIndex:0].text floatValue]*100;
            if (!_createdExpensePositive) value = -value;
            [self addExpense:value name:_createdExpenseName];
            _completion();
        }
    }
}

@end
