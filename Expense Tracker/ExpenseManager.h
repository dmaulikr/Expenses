//
//  ExpenseManager.h
//  Expenses
//
//  Created by Hendrik Noeller on 29.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "Expense.h"

@interface ExpenseManager : NSObject
@property (strong, nonatomic) NSMutableArray *accounts;

+ (ExpenseManager*)sharedManager;
- (void)save;

- (void)addAccount;
- (void)removeAccountAtIndex:(NSInteger)index;

@end
