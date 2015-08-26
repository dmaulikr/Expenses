//
//  Account.m
//  Expenses
//
//  Created by Hendrik Noeller on 04.10.14.
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

#import "Account.h"
#import "ExpenseManager.h"
#import "CsvString.h"

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
        _sortingMode = [coder decodeIntForKey:@"sort"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_expenses forKey:@"expenses"];
    [aCoder encodeObject:_currency forKey:@"currency"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeInt:_sortingMode forKey:@"sort"];
}

- (void)save
{
    [[ExpenseManager sharedManager] save];
}

- (Expense*)expenseAtIndex:(NSUInteger)index
{
    return self.expenses[index];
}

#pragma mark - Expense Management

- (void)addExpense:(NSInteger)amount name:(NSString *)name date:(NSDate *)date
{
    Expense *expense = [[Expense alloc] init];
    expense.name = name;
    expense.date = date;
    expense.amount = amount;
    [self.expenses addObject:expense];
    [self reSort];
    [self save];
}

- (void)removeExpenseAtIndex:(NSUInteger)index
{
    [_expenses removeObjectAtIndex:index];
    [self save];
}

- (void)editExepense:(NSInteger)amount name:(NSString*)name date:(NSDate*)date atIndex:(NSUInteger)index
{
    Expense *expense = [[Expense alloc] init];
    expense.name = name;
    expense.date = date;
    expense.amount = amount;
    [_expenses setObject:expense atIndexedSubscript:index];
    [self reSort];
    [self save];
}

- (void)consolidateAllExpenses
{
    if ([_expenses count] > 0) {
        Expense *consolidation = [[Expense alloc] init];
        consolidation.name = NSLocalizedString(@"EXPENSE_CONSOLIDATION", @"");
        consolidation.date = [NSDate date];
        consolidation.amount = self.saldo*100;
        [self removeAllExpenses];
        [_expenses addObject:consolidation];
    }
}

- (void)removeAllExpenses
{
    [_expenses removeAllObjects];
    [self save];
}


#pragma mark - Sorting

- (void)sortExpensesByName:(BOOL)descending
{
   self.expenses = [[self.expenses sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
       Expense *expense1 = (Expense*)obj1;
       Expense *expense2 = (Expense*)obj2;
       if (descending) {
           return [expense2.name compare:expense1.name];
       } else {
           return [expense1.name compare:expense2.name];
       }
    }] mutableCopy];
}

- (void)sortExpensesByDate:(BOOL)descending
{
    self.expenses = [[self.expenses sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Expense *expense1 = (Expense*)obj1;
        Expense *expense2 = (Expense*)obj2;
        if (descending) {
            return [expense2.date compare:expense1.date];
        } else {
            return [expense1.date compare:expense2.date];
        }
    }] mutableCopy];
}

- (void)sortExpensesByAmount:(BOOL)descending
{
    self.expenses = [[self.expenses sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Expense *expense1 = (Expense*)obj1;
        Expense *expense2 = (Expense*)obj2;
        if (descending) {
            if (expense1.amount > expense2.amount) {
                return NSOrderedAscending;
            } else if (expense1.amount < expense2.amount) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        } else {
            if (expense2.amount > expense1.amount) {
                return NSOrderedAscending;
            } else if (expense2.amount < expense1.amount) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }
    }] mutableCopy];
}

- (void)sortExpensesByMode:(aSortingMode)mode
{
    self.sortingMode = mode;
    [self reSort];
    [self save];
}

- (void)sortExpensesByNextMode
{
    switch (self.sortingMode) {
        case AmountDescending:
            [self sortExpensesByMode:Name];
            break;
            
        default:
            [self sortExpensesByMode:self.sortingMode + 1];
            break;
    }
}

- (void)reSort
{
    switch (self.sortingMode) {
        case Name:
            [self sortExpensesByName:NO];
            break;
            
        case NameDescending:
            [self sortExpensesByName:YES];
            break;
            
        case Date:
            [self sortExpensesByDate:NO];
            break;
            
        case DateDescending:
            [self sortExpensesByDate:YES];
            break;
            
        case Amount:
            [self sortExpensesByAmount:NO];
            break;
            
        case AmountDescending:
            [self sortExpensesByAmount:YES];
            break;
            
        default:
            break;
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

- (void)setName:(NSString *)name
{
    _name = name;
    [self save];
}

- (NSURL *)csvFile
{
    CsvString* csv = [[CsvString alloc] init];
    
    [csv addStringCell:NSLocalizedString(@"NAME", @"")];
    [csv addStringCell:NSLocalizedString(@"DATE", @"")];
    [csv addStringCell:NSLocalizedString(@"AMOUNT", @"")];
    [csv newLine];
    for (Expense *expense in self.expenses) {
        [csv addStringCell:expense.name];
        [csv addTimeAndDateCell:expense.date];
        [csv addDoubleCell:expense.amount/100.0];
        [csv newLine];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.csv", docDir, self.name];
    
    if ([[csv.csvString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileName atomically:YES])
        return [NSURL fileURLWithPath:fileName];
    else
        return nil;
}

@end
