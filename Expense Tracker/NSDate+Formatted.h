//
//  NSDate+Formatted.h
//  Routenplaner
//
//  Created by Hendrik Noeller on 17.08.14.
//  Copyright (c) 2014 Hendrik Noeller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatted)

- (NSString *)formattedDate;
- (NSString *)formattedTime;
- (NSString *)formattedWhole;

@end
