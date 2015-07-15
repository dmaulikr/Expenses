//
//  ExpensesTableViewController.h
//  Expenses
//
//  Created by Hendrik Noeller on 29.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@interface ExpensesTableViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) Account* account;
@end
