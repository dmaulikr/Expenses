//
//  CsvString.m
//  OvTG
//
//  Created by Hendrik on 14.01.14.
//  Copyright (c) 2014 AppTeam. All rights reserved.
//

#import "CsvString.h"
@interface CsvString ()
@property (nonatomic) BOOL newlined;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (nonatomic) int lines;
@end
@implementation CsvString


- (id)init
{
    self = [super init];
    if (self) {
        _separator = @";";
        _csvString = @"";
        _newlined = YES;
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"de_DE"]];
        [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [_dateFormatter setDateFormat:@"dd.MM.YYYY"];
        _timeFormatter = [[NSDateFormatter alloc] init];
        [_timeFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"de_DE"]];
        [_timeFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [_timeFormatter setDateFormat:@"hh:mm"];
        
        _lines = 0;
    }
    return self;
} 




- (void)addStringCell:(NSString*)string
{
    if(string) {
        string = [self safeString:string];
        if(!_newlined) _csvString = [_csvString stringByAppendingString:_separator];
        else _lines++;
        _newlined = NO;
        _csvString = [_csvString stringByAppendingString:string];
    }
}

- (void)addStringCells:(NSArray*)array
{
    if(array) {
        for (NSString *string in array) {
            [self addStringCell:string];
        }
    }
}

- (void)addIntegerCell:(int)integer
{
    [self addStringCell:[NSString stringWithFormat:@"%d", integer]];
}

- (void)addIntegerCells:(NSArray*)array
{
    if(array) {
        for (int i = 0; i < array.count; i++) {
            [self addIntegerCell:(int)array[i]];
        }
    }
}

- (void)addDoubleCell:(double)doub
{
    [self addStringCell:[[NSString stringWithFormat:@"%2.2f", doub] stringByReplacingOccurrencesOfString:@"." withString:@","]];
}

- (NSString*)addDateCell:(NSDate*)date
{
    if(date) {
        [self addStringCell:[_dateFormatter stringFromDate:date]];
        return [_dateFormatter stringFromDate:date];
    }
    return nil;
}

- (void)addDateCells:(NSArray*)array
{
    if(array) {
        for(NSDate *date in array) {
            [self addStringCell:[_dateFormatter stringFromDate:date]];
        }
    }
}

- (NSString*)addTimeCell:(NSDate*)time
{
    if(time) {
        [self addStringCell:[_timeFormatter stringFromDate:time]];
        return [_timeFormatter stringFromDate:time];
    }
    return nil;
}

- (void)addTimeCells:(NSArray*)array
{
    if(array ) {
        for(NSDate *time in array) {
            [self addTimeCell:time];
        }
    }
}

- (NSString*)addTimeAndDateCell:(NSDate*)date
{
    if(date) {
        NSString* string = [NSString stringWithFormat:@"%@ %@",[_dateFormatter stringFromDate:date] ,[_timeFormatter stringFromDate:date]];
        [self addStringCell:string];
        return string;
    }
    return nil;
}

- (void)addTimeAndDateCells:(NSArray*)array
{
    if(array) {
        for (NSDate *date in array) {
            [self addTimeAndDateCell:date];
        }
    }
}



- (void)addStringCell:(NSString*)string withInteger:(int)integer
{
    if(string) {
        [self addStringCell:[NSString stringWithFormat:@"%@%d", string, integer]];
    }
}

- (void)addStringCell:(NSString *)string withDouble:(double)doub
{
    if(string) {
        [self addStringCell:[NSString stringWithFormat:@"%@%2.2f", string, doub]];
    }
}

- (void)addStringCell:(NSString *)string withDate:(NSDate*)date
{
    if(string) {
        [self addStringCell:[NSString stringWithFormat:@"%@%@", string, [_dateFormatter stringFromDate:date]]];
    }
}

- (void)addStringCell:(NSString *)string withTime:(NSDate*)time
{
    if(string) {
        [self addStringCell:[NSString stringWithFormat:@"%@%@", string, [_dateFormatter stringFromDate:time]]];
    }
}


- (void)addEmptyCell
{
    _csvString = [_csvString stringByAppendingString:_separator];
}

- (void)newLine
{
    _csvString = [_csvString stringByAppendingString:@"\n"];
    _newlined = YES;
}

- (void)reset
{
    _lines = 0;
    _newlined = YES;
    _csvString = @"";
}




- (int)numberOfLines
{
    return _lines;
}



- (NSString*)safeString:(NSString*)string
{
    string = [string stringByReplacingOccurrencesOfString:_separator withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return string;
}

@end
