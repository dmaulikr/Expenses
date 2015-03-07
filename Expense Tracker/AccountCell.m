//
//  AccountCell.m
//  Expenses
//
//  Created by Hendrik Noeller on 04.10.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "AccountCell.h"
#import "StaticValues.h"

@implementation AccountCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setAccount:(Account *)account
{
    _account = account;
    
    
    //Updating the Circle
    float positives = self.account.positives;
    float negatives = self.account.negatives;
    
    if(positives <= 0.0 && negatives == 0.0) {
        
        self.completionCircle.dataExisting = NO;
        
    } else {
        
        self.completionCircle.dataExisting = YES;
        float completion = negatives / positives;

        if (completion < 0) {
            completion = 0.0;
        } else if (completion > 1.0) {
            completion = 1.0;
        }

        self.completionCircle.completion = completion;
    }
    
    //Updating the Title
    self.nameLabel.text = self.account.name;
    
    //Updating them Moneyz (in the Label, that is)
    self.saldoLabel.text = [NSString stringWithFormat:@"%@%.02f", [self.account currencyWithSpace], [self.account saldo]];
    if (self.account.saldo < 0) {
        self.saldoLabel.textColor = RED_COLOR;
    } else {
        self.saldoLabel.textColor = GREEN_COLOR;
    }
    
    //Updating the "Last Expense" thingy
    if ([self.account.expenses count] == 0) {
        self.lastExpenseLabel.text = NSLocalizedString(@"ACCOUNT_CELL_NO_EXPENSES", @"");
    } else {
        Expense *lastExpense = [self.account.expenses lastObject];
        self.lastExpenseLabel.text = [NSString stringWithFormat:@"%@ (%@%.02f)", lastExpense.name, account.currencyWithSpace, lastExpense.amount / 100.0];
    }
}

@end
