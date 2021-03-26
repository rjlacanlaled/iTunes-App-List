//
//  SoftwareDetails+CRUD.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import "SoftwareDetails+CRUD.h"
#import "FilePath.h"
#import "ITunesFetcher.h"

@implementation SoftwareDetails (CRUD)

#define FILE_PATH_NAME @"software_details.plist"

#pragma mark - Create

+ (SoftwareDetails *)createUsingDictionary: (NSDictionary *)softwareDetailsDictionary {
    SoftwareDetails *softwareDetails = [[SoftwareDetails alloc] init];
    softwareDetails.softwareID = [[softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_TRACK_ID] longValue];
    softwareDetails.name = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_TRACK_NAME];
    softwareDetails.thumbnailURL = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_THUMBNAIL_URL];
    softwareDetails.screenshotURLs = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_SCREENSHOT_URLS];
    softwareDetails.company = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_ARTIST_NAME];
    softwareDetails.mainGenre = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_PRIMARY_GENRE_NAME];
    softwareDetails.genres = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_GENRES];
    softwareDetails.supportedDevices = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_SUPPORTED_DEVICES];
    softwareDetails.softwareDescription = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_DESCRIPTION];
    softwareDetails.version = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_VERSION];
    softwareDetails.formattedPrice = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_FORMATTED_PRICE];
    softwareDetails.languageCodes = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_LANGUAGE_CODES];
    softwareDetails.averageUserRating = [[softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_AVERAGE_RATING] floatValue];
    softwareDetails.ratingCount = [[softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_RATING_COUNT] longValue];
    softwareDetails.averageUserRatingForCurrentVersion = [[softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_AVERAGE_RATING_CURRENT_VERSION] floatValue];
    softwareDetails.ratingCountForCurrentVersion = [[softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_RATING_COUNT_CURRENT_VERSION] longValue];
    softwareDetails.isFavorite = YES;
    softwareDetails.currency = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_CURRENCY];
    softwareDetails.contentRating  = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_TRACK_CONTENT_RATING];
    softwareDetails.fileSizeBytes = [[softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_FILE_SIZE_BYTES] longLongValue];
    softwareDetails.type = [softwareDetailsDictionary valueForKey:ITUNES_SOFTWARE_TYPE];
    softwareDetails.trackViewURL = [softwareDetailsDictionary valueForKey:ITUNES_SOFTWARE_TRACK_VIEW_URL];
    return softwareDetails;
}

#pragma mark - Read

+ (SoftwareDetails *)fetchDetailsWithDictionary: (NSDictionary *)softwareDictionary {
    SoftwareDetails *softwareDetails = nil;
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    for (SoftwareDetails *softwareDetailsInArray in softwareDetailsArray) {
        if (softwareDetailsInArray.softwareID == [[softwareDictionary valueForKeyPath:ITUNES_SOFTWARE_TRACK_ID] longValue]) {
            return softwareDetailsInArray;
        }
    }
    return softwareDetails;
}

+ (NSArray *)fetchAll {
    bool exists = [[NSFileManager defaultManager] fileExistsAtPath:[SoftwareDetails filePath]];
    return exists ? [NSKeyedUnarchiver unarchiveObjectWithFile:[SoftwareDetails filePath]] : nil;
}

+ (BOOL)softwareDetailsExistForDictionary: (NSDictionary *)softwareDictionary {
    return [SoftwareDetails fetchDetailsWithDictionary:softwareDictionary] == nil ? NO : YES;
}

+ (NSSet *)fetchAllGenre {
    NSMutableSet *genreSet = [[NSMutableSet alloc] init];
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    for (SoftwareDetails *softwareDetails in softwareDetailsArray) {
        for (NSString *genre in softwareDetails.genres) {
            [genreSet addObject:genre];
        }
    }
    return genreSet;
}

+ (NSDictionary *)fetchAllGenreWithSoftware {
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    NSMutableDictionary *softwareGenreDictionary = [[NSMutableDictionary alloc] init];
    for (SoftwareDetails *softwareDetails in softwareDetailsArray) {
        for (NSString *genre in softwareDetails.genres) {
            NSMutableArray *softwareArray = softwareGenreDictionary[genre];
            if (!softwareArray) {
                softwareArray = [[NSMutableArray alloc] init];
            }
            [softwareArray addObject:[SoftwareDetails convertSoftwareDetailsToDictionary:softwareDetails]];
            softwareGenreDictionary[genre] = softwareArray;
        }
    }
    return softwareGenreDictionary;
}

+ (NSDictionary *)fetchAllGenreSoftwareForSoftwareDetailsDictionary: (NSDictionary *)softwareDetailsDictionary {
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    NSMutableDictionary *softwareGenreDictionary = [[NSMutableDictionary alloc] init];
    NSArray *genresToFetch = [softwareDetailsDictionary valueForKeyPath:ITUNES_SOFTWARE_GENRES];
    for (SoftwareDetails *softwareDetails in softwareDetailsArray) {
        for (NSString *genre in softwareDetails.genres) {
            if ([genresToFetch containsObject:genre]) {
                NSMutableArray *softwareArray = softwareGenreDictionary[genre];
                if (!softwareArray) {
                    softwareArray = [[NSMutableArray alloc] init];
                }
                [softwareArray addObject:[SoftwareDetails convertSoftwareDetailsToDictionary:softwareDetails]];
                softwareGenreDictionary[genre] = softwareArray;
            }
        }
    }
    return softwareGenreDictionary;
}

+ (NSDictionary *)fetchAllCompanyWithSoftware {
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    NSMutableDictionary *softwareCompanyDictionary = [[NSMutableDictionary alloc] init];
    for (SoftwareDetails *softwareDetails in softwareDetailsArray) {
        NSMutableArray *softwareArray = softwareCompanyDictionary[softwareDetails.company];
        if (!softwareArray) {
            softwareArray = [[NSMutableArray alloc] init];
        }
        [softwareArray addObject:[SoftwareDetails convertSoftwareDetailsToDictionary:softwareDetails]];
        softwareCompanyDictionary[softwareDetails.company] = softwareArray;
        
    }
    return softwareCompanyDictionary;
}

+ (NSDictionary *)fetchAllSupportedDeviceWithSoftware {
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    NSMutableDictionary *softwareSupportedDeviceDictionary = [[NSMutableDictionary alloc] init];
    for (SoftwareDetails *softwareDetails in softwareDetailsArray) {
        for (NSString *supportedDevice in softwareDetails.supportedDevices) {
            NSMutableArray *softwareArray = softwareSupportedDeviceDictionary[supportedDevice];
            if (!softwareArray) {
                softwareArray = [[NSMutableArray alloc] init];
            }
            [softwareArray addObject:[SoftwareDetails convertSoftwareDetailsToDictionary:softwareDetails]];
            softwareSupportedDeviceDictionary[supportedDevice] = softwareArray;
        }
    }
    return softwareSupportedDeviceDictionary;
}


+ (NSSet *)fetchAllCompany {
    NSMutableSet *companySet = [[NSMutableSet alloc] init];
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    for (SoftwareDetails *softwareDetails in softwareDetailsArray) {
        [companySet addObject:softwareDetails.company];
    }
    return companySet;
}

+ (NSSet *)fetchAllSupportedDevices {
    NSMutableSet *supportedDevicesSet = [[NSMutableSet alloc] init];
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    for (SoftwareDetails *softwareDetails in softwareDetailsArray) {
        for (NSString *supportedDevice in softwareDetails.supportedDevices) {
            [supportedDevicesSet addObject:supportedDevice];
        }
    }
    return supportedDevicesSet;
}

+ (NSArray *)fetchAllSoftwareDetailsForGenre: (NSString *)genre {
    NSMutableArray *genreSoftwareDetails = [[NSMutableArray alloc] init];
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    for (SoftwareDetails *softwareDetails in softwareDetailsArray) {
        for (NSString *genreInArray in softwareDetails.genres) {
            if ([genre isEqualToString:genreInArray]) {
                [genreSoftwareDetails addObject:softwareDetailsArray];
            }
        }
    }
    genreSoftwareDetails = [genreSoftwareDetails valueForKeyPath:@"distinctUnionOfArrays"];
    return genreSoftwareDetails;
}

+ (NSArray *)fetchAllCompanySoftwareForSoftwareDetailsDictionary: (NSDictionary *)softwareDetailsDictionary {
    NSMutableArray *companySoftwareDetails = [[NSMutableArray alloc] init];
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    for (SoftwareDetails *softwareDetails in softwareDetailsArray) {
        if ([softwareDetails.company isEqualToString:[softwareDetailsDictionary valueForKey:ITUNES_SOFTWARE_ARTIST_NAME]]) {
            if (![companySoftwareDetails containsObject:softwareDetails] &&
                softwareDetails.softwareID != [[softwareDetailsDictionary valueForKey:ITUNES_SOFTWARE_TRACK_ID] longValue]) {
                [companySoftwareDetails addObject:softwareDetails];
            }
        }
    }
    companySoftwareDetails = [[SoftwareDetails convertSoftwareDetailsArrayToDictionaryArray:companySoftwareDetails] mutableCopy];
    return companySoftwareDetails;
}

+ (NSArray *)fetchAllSoftwareDetailsForSupportedDevice: (NSString *)supportedDevice {
    NSMutableArray *supportedDeviceSoftwareDetails = [[NSMutableArray alloc] init];
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    for (SoftwareDetails *softwareDetails in softwareDetailsArray) {
        for (NSString *supportedDeviceInArray in softwareDetails.genres) {
            if ([supportedDevice isEqualToString:supportedDeviceInArray]) {
                [supportedDeviceSoftwareDetails addObject:softwareDetailsArray];
            }
        }
    }
    supportedDeviceSoftwareDetails = [supportedDeviceSoftwareDetails valueForKeyPath:@"distinctUnionOfArrays"];
    return supportedDeviceSoftwareDetails;
}

#pragma mark - Save

+ (BOOL)saveSoftwareDetails: (SoftwareDetails *)softwareDetails {
    bool fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[SoftwareDetails filePath]];
    
    NSMutableArray *softwareDetailsArray;
    softwareDetailsArray = fileExists ? [[SoftwareDetails fetchAll] mutableCopy] : [[NSMutableArray alloc] init];
    [softwareDetailsArray addObject:softwareDetails];
    
    [SoftwareDetails saveSoftwareDetailsArrayToDatabase:softwareDetailsArray];
    return YES;
}

+ (BOOL)saveSoftwareDetailsArrayToDatabase: (NSArray *)softwareDetailsArray {
    BOOL saved = [NSKeyedArchiver archiveRootObject:softwareDetailsArray toFile:[SoftwareDetails filePath]];
    return YES;
}

#pragma mark - Update

+ (SoftwareDetails *)updateSoftwareDetailsUsingDictionary: (NSDictionary *)softwareDetailsDictionary {
    SoftwareDetails *softwareDetails;
    
    if ([SoftwareDetails softwareDetailsExistForDictionary:softwareDetailsDictionary]) {
        SoftwareDetails *softwareDetails = [SoftwareDetails createUsingDictionary:softwareDetailsDictionary];
        NSMutableArray *mutableSoftwareDetailsArray = [[SoftwareDetails fetchAll] mutableCopy];
        SoftwareDetails *softwareDetailsToBeReplaced = [SoftwareDetails fetchDetailsWithDictionary:softwareDetailsDictionary];
        NSInteger index = [mutableSoftwareDetailsArray indexOfObject:softwareDetailsToBeReplaced];
        [mutableSoftwareDetailsArray replaceObjectAtIndex:index withObject:softwareDetails];
        [SoftwareDetails saveSoftwareDetailsArrayToDatabase:mutableSoftwareDetailsArray];
    }
    
    return softwareDetails;
}

#pragma mark - Delete

+ (BOOL)deleteSoftwareDetails: (SoftwareDetails *)softwareDetails {
    NSDictionary *softwareDetailsDictionary = [SoftwareDetails convertSoftwareDetailsToDictionary:softwareDetails];
    
    if ([SoftwareDetails softwareDetailsExistForDictionary:softwareDetailsDictionary]) {
        NSMutableArray *mutableSoftwareDetailsArray = [[SoftwareDetails fetchAll] mutableCopy];
        NSInteger index = [SoftwareDetails indexOfSoftware:softwareDetails];
        [mutableSoftwareDetailsArray removeObjectAtIndex:index];
        [SoftwareDetails saveSoftwareDetailsArrayToDatabase:mutableSoftwareDetailsArray];
    }
    
    return YES;
}

#pragma mark - Mutate

+ (NSDictionary *)convertSoftwareDetailsToDictionary: (SoftwareDetails *)softwareDetails {
    NSMutableDictionary *softwareDetailsDictionary = [[NSMutableDictionary alloc] init];
    softwareDetailsDictionary[ITUNES_SOFTWARE_TRACK_ID] = [NSNumber numberWithLong:softwareDetails.softwareID];
    softwareDetailsDictionary[ITUNES_SOFTWARE_TRACK_NAME] = softwareDetails.name;
    softwareDetailsDictionary[ITUNES_SOFTWARE_THUMBNAIL_URL] = softwareDetails.thumbnailURL;
    softwareDetailsDictionary[ITUNES_SOFTWARE_SCREENSHOT_URLS] = softwareDetails.screenshotURLs;
    softwareDetailsDictionary[ITUNES_SOFTWARE_DESCRIPTION] = softwareDetails.softwareDescription;
    softwareDetailsDictionary[ITUNES_SOFTWARE_VERSION] = softwareDetails.version;
    softwareDetailsDictionary[ITUNES_SOFTWARE_FORMATTED_PRICE] = softwareDetails.formattedPrice;
    softwareDetailsDictionary[ITUNES_SOFTWARE_LANGUAGE_CODES] = softwareDetails.languageCodes;
    softwareDetailsDictionary[ITUNES_SOFTWARE_GENRES] = softwareDetails.genres;
    softwareDetailsDictionary[ITUNES_SOFTWARE_SUPPORTED_DEVICES] = softwareDetails.supportedDevices;
    softwareDetailsDictionary[ITUNES_SOFTWARE_PRIMARY_GENRE_NAME] = softwareDetails.mainGenre;
    softwareDetailsDictionary[ITUNES_SOFTWARE_ARTIST_NAME] = softwareDetails.company;
    softwareDetailsDictionary[ITUNES_SOFTWARE_AVERAGE_RATING] = [NSNumber numberWithFloat:softwareDetails.averageUserRating];
    softwareDetailsDictionary[ITUNES_SOFTWARE_RATING_COUNT] = [NSNumber numberWithLong:softwareDetails.ratingCount];
    softwareDetailsDictionary[ITUNES_SOFTWARE_AVERAGE_RATING_CURRENT_VERSION] = [NSNumber numberWithFloat:softwareDetails.averageUserRatingForCurrentVersion];
    softwareDetailsDictionary[ITUNES_SOFTWARE_RATING_COUNT_CURRENT_VERSION] = [NSNumber numberWithLong:softwareDetails.ratingCountForCurrentVersion];
    softwareDetailsDictionary[ITUNES_SOFTWARE_IS_FAVORITE] = [NSNumber numberWithBool:softwareDetails.isFavorite];
    softwareDetailsDictionary[ITUNES_SOFTWARE_CURRENCY] = softwareDetails.currency;
    softwareDetailsDictionary[ITUNES_SOFTWARE_TRACK_CONTENT_RATING] = softwareDetails.contentRating;
    softwareDetailsDictionary[ITUNES_SOFTWARE_FILE_SIZE_BYTES] = [NSNumber numberWithLong:softwareDetails.fileSizeBytes];
    softwareDetailsDictionary[ITUNES_SOFTWARE_TYPE] = softwareDetails.type;
    softwareDetailsDictionary[ITUNES_SOFTWARE_TRACK_VIEW_URL] = softwareDetails.trackViewURL;
    return softwareDetailsDictionary;
}

+ (NSArray *)convertSoftwareDetailsArrayToDictionaryArray: (NSArray *)softwareDetailsArray {
    NSMutableArray *convertedSoftwareDetailsArray = [[NSMutableArray alloc] init];
    for (SoftwareDetails *softwareDetails in softwareDetailsArray) {
        NSDictionary *softwareDetailsDictionary = [SoftwareDetails convertSoftwareDetailsToDictionary:softwareDetails];
        [convertedSoftwareDetailsArray addObject:softwareDetailsDictionary];
    }
    return convertedSoftwareDetailsArray;
}

+ (NSArray *)convertSoftwareDetailsDictionaryArrayToSoftwareDetailsArray: (NSArray *)softwareDetailsDictionaryArray {
    NSMutableArray *convertedSoftwareDetailsDictionary = [[NSMutableArray alloc] init];
    
    for (NSDictionary *softwareDetailsDictionary in softwareDetailsDictionaryArray) {
        SoftwareDetails *softwareDetails = [SoftwareDetails createUsingDictionary:softwareDetailsDictionary];
        [convertedSoftwareDetailsDictionary addObject:softwareDetails];
    }
    
    return convertedSoftwareDetailsDictionary;
}

#pragma mark - Helper Methods

+ (NSString *)filePath {
    return [FilePath filepathWithFilename:FILE_PATH_NAME];
}

+ (NSInteger)indexOfSoftware: (SoftwareDetails *)softwareDetails {
    NSArray *softwareDetailsArray = [SoftwareDetails fetchAll];
    for (int i = 0; i < [softwareDetailsArray count]; i++) {
        if ([softwareDetailsArray[i] softwareID] == softwareDetails.softwareID) {
            return i;
        }
    }
    return -1;
}

@end
