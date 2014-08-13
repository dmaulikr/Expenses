//
//  AddEntryViewController.h
//  Expenses
//
//  Created by Hendrik Noeller on 30.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseManager.h"

@interface AddEntryViewController : UIViewController
@property (strong, nonatomic) ExpenseManager *manager;
@property (strong, nonatomic) Expense *expense;
@property (nonatomic) NSInteger indexOfExpense;
@end
