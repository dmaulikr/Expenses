//
//  Account.m
//  Expenses
//
//  Created by Hendrik Noeller on 04.10.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "Account.h"

@implementation Account
- (instancetype)init
{
    self = [super init];
    if (self) {
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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _expenses = [coder decodeObjectForKey:@"expenses"];
        _currency = [coder decodeObjectForKey:@"currency"];
        _name = [coder decodeObjectForKey:@"name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_expenses forKey:@"expenses"];
    [aCoder encodeObject:_currency forKey:@"currency"];
    [aCoder encodeObject:_name forKey:@"name"];
}

- (void)save
{
    [[ExpenseManager sharedManager] save];
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

- (void)setName:(NSString *)name
{
    _name = name;
    [self save];
}

@end
