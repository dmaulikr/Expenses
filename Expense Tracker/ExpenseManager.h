//
//  ExpenseManager.h
//  Expense Tracker
//
//  Created by Hendrik Noeller on 29.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expense.h"

@interface ExpenseManager : NSObject
@property (strong, nonatomic) NSMutableArray *expenses;

- (void)addExpense:(NSInteger)amount name:(NSString*)name;
- (void)removeExpenseAtIndex:(NSInteger)index;
- (void)editExepense:(NSInteger)amount name:(NSString*)name atIndex:(NSInteger)index;
- (void)moveExpenseFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

- (float)saldo;
- (float)positives;
- (float)negatives;
@end
