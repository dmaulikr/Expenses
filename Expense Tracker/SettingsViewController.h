//
//  SettingsViewController.h
//  Expenses
//
//  Created by Hendrik Noeller on 19.07.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseManager.h"

@interface SettingsViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) ExpenseManager* manager;
@end
