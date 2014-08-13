//
//  ExpenseManager.m
//  Expenses
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
        if (!_currency) {
            if ([NSLocaleIdentifier isEqualToString:@"en_US"]) {
                _currency = @"$";
            } else if ([NSLocaleIdentifier isEqualToString:@"jp_JP"]) {
                _currency = @"¥";
            } else if ([NSLocaleIdentifier isEqualToString:@"en_GB"]) {
                _currency = @"£";
            } else
                _currency = @"€";
            }
    }
    return self;
}

- (void)load
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *expensesFileName = [NSString stringWithFormat:@"%@/expenses", docDir];
    NSString *currencyFileName = [NSString stringWithFormat:@"%@/currency", docDir];
    _expenses = [NSKeyedUnarchiver unarchiveObjectWithFile:expensesFileName];
    _currency = [NSKeyedUnarchiver unarchiveObjectWithFile:currencyFileName];
    [self updateApplicationTintColor];
}

- (void)save
{
    [self updateApplicationTintColor];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *expensesFileName = [NSString stringWithFormat:@"%@/expenses", docDir];
    NSString *currencyFileName = [NSString stringWithFormat:@"%@/currency", docDir];
    [NSKeyedArchiver archiveRootObject:_expenses toFile:expensesFileName];
    [NSKeyedArchiver archiveRootObject:_currency toFile:currencyFileName];
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

- (void)editExepense:(NSInteger)amount name:(NSString*)name atIndex:(NSInteger)index
{
    Expense *expense = [[Expense alloc] init];
    expense.name = name;
    expense.amount = amount;
    [_expenses setObject:expense atIndexedSubscript:index];
    [self save];
}

- (void)moveExpenseFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    Expense *temp = _expenses[fromIndex];
    [_expenses removeObjectAtIndex:fromIndex];
    [_expenses insertObject:temp atIndex:toIndex];
    [self save];
}

- (void)removeAllExpenses
{
    [_expenses removeAllObjects];
    [self save];
}

- (void)updateApplicationTintColor
{
    if([self percentUsed] >= 1.0) {
        [[[[UIApplication sharedApplication] delegate] window] setTintColor:[UIColor redColor]];
    } else {
        [[[[UIApplication sharedApplication] delegate] window] setTintColor:[UIColor colorWithRed:0.0 green:0.721 blue:0.5215 alpha:1.0]];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}


#pragma mark - Value Getters

- (float)saldo {
    float saldo = 0;
    for (Expense *expense in _expenses) {
        saldo = saldo+expense.amount;
    }
    return saldo/100;
}

- (float)positives {
    float positives = 0;
    for (Expense *expense in _expenses) {
        if(expense.amount > 0) {
            positives = positives + expense.amount;
        }
    }
    return positives/100;
}

- (float)negatives {
    float negatives = 0;
    for (Expense *expense in _expenses) {
        if(expense.amount < 0) {
            negatives = negatives - expense.amount;
        }
    }
    return negatives/100;
}

- (float)percentUsed
{
    float positives = [self positives];
    if (positives == 0.0) {
        return 0.0;
    }
    float negatives = [self negatives];
    float value = negatives / positives;
    return value;
}

- (NSString *)currencyWithSpace
{
    if ([_currency isEqualToString:@""]) {
        return _currency;
    }
    return [_currency stringByAppendingString:@" "];
}

- (void)setCurrency:(NSString *)currency
{
    _currency = currency;
    [self save];
}

@end
