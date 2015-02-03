//
//  NSString+LengthComparison.m
//  MapCode
//
//  Created by Dmitry Shmidt on 11/08/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//

#import "NSString+LengthComparison.h"

@implementation NSString (LengthComparison)
- (NSComparisonResult)lengthCompare:(NSString *)aString
{
    if ([self length] < [aString length]) {
        return NSOrderedAscending;
    } else if ([self length] > [aString length]) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}
@end
