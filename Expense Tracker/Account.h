//
//  Account.h
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

#import <Foundation/Foundation.h>
#import "Expense.h"

@interface Account : NSObject <NSCoding>

@property (strong, nonatomic) NSMutableArray *expenses;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSString *name;
- (NSString *)currencyWithSpace;

- (Expense*)expenseAtIndex:(NSUInteger)index;
- (void)addExpense:(NSInteger)amount name:(NSString*)name;
- (void)removeExpenseAtIndex:(NSUInteger)index;
- (void)editExepense:(NSInteger)amount name:(NSString*)name atIndex:(NSUInteger)index;
- (void)moveExpenseFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)consolidateAllExpenses;
- (void)removeAllExpenses;

- (float)saldo;
- (float)positives;
- (float)negatives;

@end
