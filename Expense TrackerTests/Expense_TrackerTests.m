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
@end

@implementation Expense_TrackerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMoveAccountToIndex
{
    ExpenseManager *manager = [[ExpenseManager alloc] init];
    while ([manager.accounts count] > 0) {
        [manager removeAccountAtIndex:0];
    }
    
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
    [account addExpense:100 name:@"A"];
    [account addExpense:200 name:@"B"];
    [account addExpense:300 name:@"C"];
    
    XCTAssertEqual([account expenseAtIndex:0].amount, 100);
    XCTAssertEqual([account expenseAtIndex:1].amount, 200);
    XCTAssertEqual([account expenseAtIndex:2].amount, 300);
    
    XCTAssertEqual([account expenseAtIndex:0].name, @"A");
    XCTAssertEqual([account expenseAtIndex:1].name, @"B");
    XCTAssertEqual([account expenseAtIndex:2].name, @"C");
}

- (void)testMoveExpenseToIndex
{
    Account *account = [[Account alloc] init];
    [account addExpense:100 name:@"A"];
    [account addExpense:200 name:@"B"];
    [account addExpense:300 name:@"C"];
    
    [account moveExpenseFromIndex:0 toIndex:0];
    XCTAssertEqual([account expenseAtIndex:0].amount, 100);
    XCTAssertEqual([account expenseAtIndex:1].amount, 200);
    XCTAssertEqual([account expenseAtIndex:2].amount, 300);
    
    [account moveExpenseFromIndex:0 toIndex:1];
    XCTAssertEqual([account expenseAtIndex:0].amount, 200);
    XCTAssertEqual([account expenseAtIndex:1].amount, 100);
    XCTAssertEqual([account expenseAtIndex:2].amount, 300);
}

- (void)testConsolidate
{
    Account *account = [[Account alloc] init];
    
    [account consolidateAllExpenses];
    XCTAssertEqual([account.expenses count], 0);
    
    [account addExpense:100 name:@"A"];
    [account addExpense:200 name:@"B"];
    [account addExpense:300 name:@"C"];
    [account consolidateAllExpenses];
    
    XCTAssertEqual([account.expenses count], 1);
    XCTAssertEqual([account expenseAtIndex:0].amount, 600);
    
}

@end
