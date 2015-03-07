//
//  ExpenseManager.m
//  Expenses
//
//  Created by Hendrik Noeller on 29.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
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
            [self updateTintColor];
        }
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
