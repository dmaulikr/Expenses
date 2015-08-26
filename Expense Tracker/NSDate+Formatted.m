//
//  NSDate+Formatted.m
//  Routenplaner
//
//  Created by Hendrik Noeller on 17.08.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import "NSDate+Formatted.h"

static NSDateFormatter *dateFormatter;
static NSDateFormatter *timeFormatter;

@implementation NSDate (Formatted)

- (NSString *)formattedDate
{
    return [[self dateFormatter] stringFromDate:self];
}

- (NSString *)formattedTime
{
    return [[self timeFormatter] stringFromDate:self];
}

- (NSString *)formattedWhole
{
    return [NSString stringWithFormat:@"%@ %@", [self formattedDate], [self formattedTime]];
}

- (NSDateFormatter *)dateFormatter
{
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.YYYY"];
    }
    return dateFormatter;
}

- (NSDateFormatter *)timeFormatter
{
    if(!timeFormatter) {
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
    }
    return timeFormatter;
}

@end
