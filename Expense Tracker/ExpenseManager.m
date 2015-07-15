//
//  ExpenseManager.m
//  Expenses
//
//  Created by Hendrik Noeller on 29.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
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

#import "ExpenseManager.h"
#import "StaticValues.h"
@interface ExpenseManager ()
@property (strong, nonatomic) NSString *accountsFileName;
@end

@implementation ExpenseManager

+ (ExpenseManager*)sharedManager
{
    static ExpenseManager *expenseManager;
    static dispatch_once_t expenseManagerOncePredicate;
    dispatch_once(&expenseManagerOncePredicate, ^{
        expenseManager = [[ExpenseManager alloc] init];
    });
    return expenseManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self load];
        if (!_accounts) {
            _accounts = [[NSMutableArray alloc] init];
        }
        [self updateTintColor];
    }
    return self;
}

- (void)load
{
    _accounts = [NSKeyedUnarchiver unarchiveObjectWithFile:self.accountsFileName];
}

- (void)save
{
    [self updateTintColor];
    [NSKeyedArchiver archiveRootObject:_accounts toFile:self.accountsFileName];
}

- (NSString *)accountsFileName
{
    if (!_accountsFileName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        _accountsFileName = [NSString stringWithFormat:@"%@/accounts", docDir];
    }
    return _accountsFileName;
}



- (void)addAccount
{
    [self.accounts addObject:[[Account alloc] init]];
    [self save];
}

- (void)removeAccountAtIndex:(NSInteger)index
{
    [self.accounts removeObjectAtIndex:index];
    [self save];
}



- (void)updateTintColor
{
    for (Account *account in self.accounts) {
        if ([account.expenses count] > 0 && [account saldo] < 0.0) {
            [[[UIApplication sharedApplication] delegate].window setTintColor:RED_COLOR];
            return;
        }
    }
    [[[UIApplication sharedApplication] delegate].window setTintColor:GREEN_COLOR];
}

@end
