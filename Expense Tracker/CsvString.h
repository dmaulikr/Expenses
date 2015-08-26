//
//  CsvString.h
//  OvTG
//
//  Created by Hendrik on 14.01.14.
//  Copyright (c) 2014 AppTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CsvString : NSObject
@property (strong, nonatomic) NSString* separator;
@property (strong, nonatomic) NSString* csvString;

- (void)addStringCell:(NSString*)string;
- (void)addStringCells:(NSArray*)array;
- (void)addIntegerCell:(int)integer;
- (void)addIntegerCells:(NSArray*)array;
- (void)addDoubleCell:(double)doub;
- (NSString*)addDateCell:(NSDate*)date;
- (void)addDateCells:(NSArray*)array;
- (NSString*)addTimeCell:(NSDate*)time;
- (void)addTimeCells:(NSArray*)array;
- (NSString*)addTimeAndDateCell:(NSDate*)date;
- (void)addTimeAndDateCells:(NSArray*)array;


- (void)addStringCell:(NSString*)string withInteger:(int)integer;
- (void)addStringCell:(NSString *)string withDouble:(double)doub;
- (void)addStringCell:(NSString *)string withDate:(NSDate*)date;
- (void)addStringCell:(NSString *)string withTime:(NSDate*)time;

- (void)addEmptyCell;
- (void)newLine;
- (void)reset;

- (int)numberOfLines;
@end
