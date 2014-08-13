//
//  NSString+CommaFloatValue.m
//  Expenses
//
//  Created by Hendrik Noeller on 30.06.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "NSString+CommaFloatValue.h"

@implementation NSString (CommaFloatValue)

- (float)commaFloatValue
{
    return [self stringByReplacingOccurrencesOfString:@"," withString:@"."].floatValue;
}

@end
