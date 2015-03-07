//
//  Account.h
//  Expenses
//
//  Created by Hendrik Noeller on 04.10.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpenseManager.h"
#import "Expense.h"

@interface Account : NSObject <NSCoding>

@property (strong, nonatomic) NSMutableArray *expenses;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSString *name;
- (NSString *)currencyWithSpace;

- (void)addExpense:(NSInteger)amount name:(NSString*)name;
- (void)removeExpenseAtIndex:(NSInteger)index;
- (void)editExepense:(NSInteger)amount name:(NSString*)name atIndex:(NSInteger)index;
- (void)moveExpenseFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (void)removeAllExpenses;

- (float)saldo;
- (float)positives;
- (float)negatives;

@end
