//
//  MapCode.h
//  MapCode
//
//  Created by Dmitry Shmidt on 26/07/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@interface MapcodeHelper : NSObject
+ (instancetype)sharedInstance;
//+ (NSArray *)countriesISODictionary;
+ (NSString *)mapcodeCoordinate:(CLLocationCoordinate2D)coordinate error:(NSError **)error;
+ (NSArray *)mapcodeCoordinate:(CLLocationCoordinate2D)coordinate inRegionCode:(NSString *)regionCode error:(NSError **)error;
+ (CLLocationCoordinate2D)coordinateFromMapcode:(NSString *)mapcode error:(NSError **)error;
+ (NSArray *)countriesList;
+ (NSDictionary *)iso3166_3To2Codes;
+ (NSDictionary *)iso3166_2To3Codes;
+ (NSDictionary *)countriesISO3166_1_3Dictionary;
@end
