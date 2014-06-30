//
//  NSString+CommaFloatValue.m
//  Expense Tracker
//
//  Created by Hendrik Noeller on 30.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "NSString+CommaFloatValue.h"

@implementation NSString (CommaFloatValue)

- (float)commaFloatValue
{
    NSString *newSelf = [self stringByReplacingOccurrencesOfString:@"," withString:@"."];
    return newSelf.floatValue;
}

@end
