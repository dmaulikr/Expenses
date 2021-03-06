//
//  Expense_TrackerTests.m
//  ExpensesTests
//
//  Created by Hendrik Noeller on 29.06.14.
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

#import <XCTest/XCTest.h>
#import "ExpenseManager.h"
#import "Account.h"
#import "Expense.h"

@interface Expense_TrackerTests : XCTestCase
@property (strong, nonatomic) NSMutableArray *accountBuffer;
@end

@implementation Expense_TrackerTests


- (void)setUp
{
    [super setUp];
    
    //Temporarily keeps the data saved on disk and clears the disk for testing
    ExpenseManager *manager = [[ExpenseManager alloc] init];
    self.accountBuffer = manager.accounts;
    manager.accounts = [[NSMutableArray alloc] init];
    [manager save];
}

- (void)tearDown
{
    //Resaves the data to disk, to restore it to the state it had before running the tests
    ExpenseManager *manager = [[ExpenseManager alloc] init];
    manager.accounts = self.accountBuffer;
    [manager save];
    
    [super tearDown];
}

- (void)testSetUpProcedure
{
    ExpenseManager *manager = [[ExpenseManager alloc] init];
    XCTAssertEqualObjects(manager.accounts, [[NSMutableArray alloc] init]);
}

- (void)testDiskSave
{
    ExpenseManager *manager = [[ExpenseManager alloc] init];
    
    [manager addAccount];
    [manager addAccount];
    [manager addAccount];
    
    Account *accountA = [manager accountAtIndex:0];
    Account *accountB = [manager accountAtIndex:1];
    Account *accountC = [manager accountAtIndex:2];
    
    accountA.name = @"A";
    accountB.name = @"B";
    accountC.name = @"C";
    
    [accountA addExpense:4200 name:@"fourtytwo" date:[NSDate dateWithTimeIntervalSince1970:42]];
    [accountA addExpense:5200 name:@"fiftytwo" date:[NSDate dateWithTimeIntervalSince1970:52]];
    
    [manager save]; //this is needed in the test scenaria as the test does not utilze the shared manager, to which the expenses call their save command
    
    manager = nil;
    
    ExpenseManager *retreivedManager = [[ExpenseManager alloc] init];
    
    XCTAssertEqual([retreivedManager.accounts count], 3);
    
    Account *retreivedAccountA = [retreivedManager accountAtIndex:0];
    Account *retreivedAccountB = [retreivedManager accountAtIndex:1];
    Account *retreivedAccountC = [retreivedManager accountAtIndex:2];
    
    XCTAssertEqualObjects(retreivedAccountA.name, @"A");
    XCTAssertEqualObjects(retreivedAccountB.name, @"B");
    XCTAssertEqualObjects(retreivedAccountC.name, @"C");
    
    XCTAssertEqual([retreivedAccountA.expenses count], 2);
    
    Expense *retreivedExpense42 = [accountA expenseAtIndex:0];
    Expense *retreivedExpense52 = [accountA expenseAtIndex:1];
    
    XCTAssertEqualObjects(retreivedExpense42.name, @"fourtytwo");
    XCTAssertEqual(retreivedExpense42.amount, 4200);
    XCTAssertEqualObjects(retreivedExpense42.date, [NSDate dateWithTimeIntervalSince1970:42]);
    XCTAssertEqualObjects(retreivedExpense52.name, @"fiftytwo");
    XCTAssertEqual(retreivedExpense52.amount, 5200);
    XCTAssertEqualObjects(retreivedExpense52.date, [NSDate dateWithTimeIntervalSince1970:52]);
    
}

- (void)testMoveAccountToIndex
{
    ExpenseManager *manager = [[ExpenseManager alloc] init];
    
    [manager addAccount];
    [manager addAccount];
    [manager addAccount];
    
    Account *accountA = [manager accountAtIndex:0];
    Account *accountB = [manager accountAtIndex:1];
    Account *accountC = [manager accountAtIndex:2];
    
    [manager moveAccountAtIndex:0 toIndex:0];
    XCTAssertEqual([manager accountAtIndex:0], accountA);
    XCTAssertEqual([manager accountAtIndex:1], accountB);
    XCTAssertEqual([manager accountAtIndex:2], accountC);
    
    [manager moveAccountAtIndex:3 toIndex:0];
    XCTAssertEqual([manager accountAtIndex:0], accountA);
    XCTAssertEqual([manager accountAtIndex:1], accountB);
    XCTAssertEqual([manager accountAtIndex:2], accountC);
    
    [manager moveAccountAtIndex:0 toIndex:3];
    XCTAssertEqual([manager accountAtIndex:0], accountA);
    XCTAssertEqual([manager accountAtIndex:1], accountB);
    XCTAssertEqual([manager accountAtIndex:2], accountC);
    
    [manager moveAccountAtIndex:0 toIndex:1];
    XCTAssertEqual([manager accountAtIndex:0], accountB);
    XCTAssertEqual([manager accountAtIndex:1], accountA);
    XCTAssertEqual([manager accountAtIndex:2], accountC);
}

- (void)testAddExpense
{
    Account *account = [[Account alloc] init];
    [account addExpense:100 name:@"A" date:[NSDate dateWithTimeIntervalSince1970:0]];
    [account addExpense:200 name:@"B" date:[NSDate dateWithTimeIntervalSince1970:1]];
    [account addExpense:300 name:@"C" date:[NSDate dateWithTimeIntervalSince1970:2]];
    
    XCTAssertEqual([account expenseAtIndex:0].amount, 100);
    XCTAssertEqual([account expenseAtIndex:1].amount, 200);
    XCTAssertEqual([account expenseAtIndex:2].amount, 300);
    
    XCTAssertEqual([account expenseAtIndex:0].name, @"A");
    XCTAssertEqual([account expenseAtIndex:1].name, @"B");;
    XCTAssertEqual([account expenseAtIndex:2].name, @"C");
    
    XCTAssertEqual([account expenseAtIndex:0].date, [NSDate dateWithTimeIntervalSince1970:0]);
    XCTAssertEqual([account expenseAtIndex:1].date, [NSDate dateWithTimeIntervalSince1970:1]);
    XCTAssertEqual([account expenseAtIndex:2].date, [NSDate dateWithTimeIntervalSince1970:2]);
}

- (void)testConsolidate
{
    Account *account = [[Account alloc] init];
    
    [account consolidateAllExpenses];
    XCTAssertEqual([account.expenses count], 0);
    
    [account addExpense:100 name:@"A" date:[NSDate date]];
    [account addExpense:200 name:@"B" date:[NSDate date]];
    [account addExpense:300 name:@"C" date:[NSDate date]];
    [account consolidateAllExpenses];
    
    XCTAssertEqual([account.expenses count], 1);
    XCTAssertEqual([account expenseAtIndex:0].amount, 600);
    
    Account *accountNegative = [[Account alloc] init];
    
    [accountNegative addExpense:100 name:@"A" date:[NSDate date]];
    [accountNegative addExpense:-200 name:@"B" date:[NSDate date]];
    [accountNegative addExpense:-300 name:@"C" date:[NSDate date]];
    [accountNegative consolidateAllExpenses];
    
    XCTAssertEqual([accountNegative.expenses count], 1);
    XCTAssertEqual([accountNegative expenseAtIndex:0].amount, -400);
}

- (void)testSorting
{
    Account *account = [[Account alloc] init];
    [account addExpense:1 name:@"C" date:[NSDate dateWithTimeIntervalSince1970:1]];
    [account addExpense:2 name:@"B" date:[NSDate dateWithTimeIntervalSince1970:0]];
    [account addExpense:3 name:@"A" date:[NSDate dateWithTimeIntervalSince1970:2]];
    
    [account sortExpensesByMode:Amount];
    XCTAssertEqual([account expenseAtIndex:0].amount, 1);
    XCTAssertEqual([account expenseAtIndex:1].amount, 2);
    XCTAssertEqual([account expenseAtIndex:2].amount, 3);
    
    [account sortExpensesByMode:AmountDescending];
    XCTAssertEqual([account expenseAtIndex:0].amount, 3);
    XCTAssertEqual([account expenseAtIndex:1].amount, 2);
    XCTAssertEqual([account expenseAtIndex:2].amount, 1);
    
    [account sortExpensesByMode:Name];
    XCTAssertEqualObjects([account expenseAtIndex:0].name, @"A");
    XCTAssertEqualObjects([account expenseAtIndex:1].name, @"B");
    XCTAssertEqualObjects([account expenseAtIndex:2].name, @"C");
    
    [account sortExpensesByMode:NameDescending];
    XCTAssertEqualObjects([account expenseAtIndex:0].name, @"C");
    XCTAssertEqualObjects([account expenseAtIndex:1].name, @"B");
    XCTAssertEqualObjects([account expenseAtIndex:2].name, @"A");
    
    [account sortExpensesByMode:Date];
    XCTAssertEqual([account expenseAtIndex:0].amount, 2);
    XCTAssertEqual([account expenseAtIndex:1].amount, 1);
    XCTAssertEqual([account expenseAtIndex:2].amount, 3);
    
    [account sortExpensesByMode:DateDescending];
    XCTAssertEqual([account expenseAtIndex:0].amount, 3);
    XCTAssertEqual([account expenseAtIndex:1].amount, 1);
    XCTAssertEqual([account expenseAtIndex:2].amount, 2);
}

@end
