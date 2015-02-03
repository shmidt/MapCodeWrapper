//
//  NSString+LengthComparison.h
//  MapCode
//
//  Created by Dmitry Shmidt on 11/08/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LengthComparison)
- (NSComparisonResult)lengthCompare:(NSString *)aString;
@end
