//
//  MapCode.m
//  MapCode
//
//  Created by Dmitry Shmidt on 26/07/14.
//  Copyright (c) 2014 Dmitry Shmidt. All rights reserved.
//

#import "MapcodeHelper.h"
#import "mapcoder.h"
#import "NSString+LengthComparison.h"
@implementation MapcodeHelper
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static MapcodeHelper  *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
+ (NSArray *)countriesList{
    return [[self.class.countriesISODictionary valueForKey:@"name"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}
//+ (NSDictionary *)countriesISO3166_1_3Dictionary{
//NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"bundle"];
//NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
//    NSString *jsonPath = [bundle pathForResource:@"country"
//                                                         ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
//    NSError *error = nil;
//    id json = [NSJSONSerialization JSONObjectWithData:data
//                                              options:kNilOptions
//                                                error:&error];
//    NSLog(@"JSON: %@", json);
//    return nil;
//}
+ (NSDictionary *)countriesISO3166_1_3Dictionary{
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
//    NSArray *countryIds = [NSLocale availableLocaleIdentifiers];
//    NSLog(countryIds.description);
    NSMutableDictionary *countriesDict = [[NSMutableDictionary alloc] initWithCapacity:countryCodes.count];
    
    for (NSString *countryCode in countryCodes) {
        
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        NSString *iso3166_1_3 = self.class.iso3166_2To3Codes[countryCode];
        if (iso3166_1_3) {
            [countriesDict setObject:iso3166_1_3 forKey:displayNameString];
        }
    }
    
    return countriesDict.copy;
}
+ (NSArray *)countriesISODictionary{
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
    
    NSMutableArray *countriesDictsArray = [[NSMutableArray alloc] initWithCapacity:countryCodes.count];
    
    for (NSString *countryCode in countryCodes) {
        
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        NSString *iso3166_1_3 = self.class.iso3166_2To3Codes[countryCode];
//        NSAssert(iso3166_1_3, @"");
        if (iso3166_1_3.length > 0) {
            NSDictionary *cd = @{@"name": displayNameString, @"3166-1_3":iso3166_1_3, @"3166-1_2":countryCode};
            [countriesDictsArray addObject:cd];
        }else NSLog(@"miss %@", countryCode);
        
        
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [countriesDictsArray sortedArrayUsingDescriptors:sortDescriptors];
    return countriesDictsArray;
}
+ (NSDictionary *)iso3166_3To2Codes{
    NSString *myPlistFilePath = [[NSBundle mainBundle] pathForResource: @"iso3166_1_3_to_iso3166_1_2" ofType: @"plist"];
    return [NSDictionary dictionaryWithContentsOfFile: myPlistFilePath];
}
+ (NSDictionary *)iso3166_2To3Codes{
    NSString *myPlistFilePath = [[NSBundle mainBundle] pathForResource: @"iso3166_1_2_to_iso3166_1_3" ofType: @"plist"];
    return [NSDictionary dictionaryWithContentsOfFile: myPlistFilePath];
}
+ (NSString *)mapcodeCoordinate:(CLLocationCoordinate2D)coordinate error:(NSError **)error{

    return [self mapcodeCoordinate:coordinate inRegionCode:nil error:error].firstObject;
}
+ (NSArray *)mapcodeCoordinate:(CLLocationCoordinate2D)coordinate inRegionCode:(NSString *)regionCode error:(NSError **)error{
    double lat = coordinate.latitude;
    double lon =  coordinate.longitude;
    
    if (regionCode.length == 3) {
        regionCode = self.class.iso3166_3To2Codes[regionCode];
    }
    NSLog(@"%0.6f,%0.6f region code is %@", lat,lon,regionCode);
    int tc = text2tc(regionCode.UTF8String, 0);
    NSLog(@"tc is %d", tc);
    if (tc == -1) {
        tc = 0;//Search international
    }
    char *r[64];
    int i;
    //text2tc((regionCode.length > 0 ? regionCode.UTF8String : NULL) ,0);
    int nrresults = coord2mc(r, lat,lon,tc );

    if (nrresults > 0) {
        NSLog(@"%d possible mapcodes for %0.6f,%0.6f:\n",nrresults,lat,lon);
        NSMutableArray *ma = [NSMutableArray array];
        
        for(i = 0; i < nrresults; i++)
        {
            // show context (unless it is international)
            NSString *mapCode;
            if ( strcmp(r[i*2+1],"AAA") != 0 ) {
//                printf("1 %s ",r[i*2+1]);
                mapCode = [NSString stringWithFormat:@"%s %s",r[i*2+1], r[i*2]];
            }else{
                //INT
                mapCode = [NSString stringWithCString:r[i*2] encoding:NSUTF8StringEncoding];
            }
            // show mapcode
//            printf("2 %s\n", r[i*2] );
            [ma addObject:mapCode];
        }

        NSArray *arraySortedByStringLength = [ma.copy sortedArrayUsingSelector:@selector(lengthCompare:)];
        return arraySortedByStringLength;
    }else {
//        NSLog(@"%d possible mapcodes for %0.6f,%0.6f:\n",nrresults,lat,lon);
//        NSDictionary *userInfo = @{
//                                   NSLocalizedDescriptionKey: [NSString stringWithFormat:@"No valid mapcodes for coordinate %0.6f, %0.6f", lat,lon],
//                                   //                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation timed out.", nil),
//                                   //                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
//                                   };
//        *error = [NSError errorWithDomain:@"mapcode.com"
//                                     code:-57
//                                 userInfo:userInfo];
        
    }
    
    return nil;
    //
    //    double lat = 52.376514;
    //    double lon =  4.908542;
    //
    //    char *r[64];
    //    int nrresults = coord2mc( r, lat,lon,0 );
    //    
    //
}

+ (CLLocationCoordinate2D)coordinateFromMapcode:(NSString *)mapcode error:(NSError * __autoreleasing *)error{
    const char *userinput = mapcode.UTF8String;
    double lat,lon;
    int err = mc2coord(&lat, &lon, userinput, 0);
    if (err){
        if (error) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%s is not a valid mapcode.", userinput],
//                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The operation timed out.", nil),
//                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                                       };
            *error = [NSError errorWithDomain:@"mapcode.com"
                                         code:err
                                     userInfo:userInfo];
        }
        return kCLLocationCoordinate2DInvalid;
    }
    else{
        NSLog(@"\"%s\" represents %0.6f,%0.6f\n", userinput,lat,lon);
    return CLLocationCoordinate2DMake(lat, lon);
    }
//    int defaultcontext = text2tc("USA",0);
//    const char *userinput = "IN VY.HV";
//    double lat,lon;
//    int err = mc2coord(&lat,&lon,userinput,defaultcontext);
//    if (err)
//        printf("\"%s\" is not a valid mapcode\n", userinput);
//    else
//        printf("\"%s\" represents %0.6f,%0.6f\n",userinput,lat,lon);

}
@end
