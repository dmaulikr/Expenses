//
//  AccountCell.h
//  Expenses
//
//  Created by Hendrik Noeller on 04.10.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompletionCircleView.h"
#import "Account.h"

@interface AccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CompletionCircleView *completionCircle;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *saldoLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastExpenseLabel;

@property (strong, nonatomic) Account *account;

@end
