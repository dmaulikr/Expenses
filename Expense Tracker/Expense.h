//
//  Expense.h
//  Expense Tracker
//
//  Created by Hendrik Noeller on 29.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject <NSCoding>
@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSInteger amount; //in cents
@end
