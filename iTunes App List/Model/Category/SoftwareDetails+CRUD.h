//
//  SoftwareDetails+CRUD.h
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import "SoftwareDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface SoftwareDetails (CRUD)

#pragma mark - KEY PATHS

// For fetching Genre and Software in GenreSoftware Method
#define GENRE_SOFTWARE @"genreSoftware"
#define GENRE_KEY @"genre"
#define SOFTWARE_KEY @"software"
#define GENRE_SOFTWARE_GENRE_KEY @"genreSoftware.genre"
#define GENRE_SOFTWARE_SOFTWARE_KEY @"genreSoftware.software"
#define SEGREGATED_SOFTWARES @"segregatedSoftwares"

#pragma mark - Create
// Converts an NSDictionary software into a Software Details object (does not alter the database)
+ (SoftwareDetails *)createUsingDictionary: (NSDictionary *)softwareDetailsDictionary;

#pragma mark - Read
// Checks whether a software already exists
+ (BOOL)softwareDetailsExistForDictionary: (NSDictionary *)softwareDictionary;
// Fetches the software using a dictionary and returns a software object
+ (SoftwareDetails *)fetchDetailsWithDictionary: (NSDictionary *)softwareDictionary;
// Fetches all the software in the database
+ (NSArray *)fetchAll;
// Fetches all genre together with their corresponding software
+ (NSDictionary *)fetchAllGenreWithSoftware;
// Fetches all company together with their corresponding software
+ (NSDictionary *)fetchAllCompanyWithSoftware;
// Fetches all supported devices together with their corresponding software
+ (NSDictionary *)fetchAllSupportedDeviceWithSoftware;
// Fetches all Genre for a specific software using software dictionary
+ (NSDictionary *)fetchAllGenreSoftwareForSoftwareDetailsDictionary: (NSDictionary *)softwareDetailsDictionary;
// Fetches all software details for a speicfic genre
+ (NSArray *)fetchAllSoftwareDetailsForGenre: (NSString *)genre;
// Fetches all company software using software dictionary as basis
+ (NSArray *)fetchAllCompanySoftwareForSoftwareDetailsDictionary: (NSDictionary *)softwareDetailsDictionary;
// Fetches all supported devices software using software dictionary as basis
+ (NSArray *)fetchAllSoftwareDetailsForSupportedDevice: (NSString *)supportedDevice ;

#pragma mark - Update
// Updates the software in the database using the updated dictionary
+ (SoftwareDetails *)updateSoftwareDetailsUsingDictionary: (NSDictionary *)softwareDetailsDictionary;

#pragma mark - Delete
// Deletes a software object in the database
+ (BOOL)deleteSoftwareDetails: (SoftwareDetails *)softwareDetails;

#pragma mark - Save
// Saves a software object to the database
+ (BOOL)saveSoftwareDetails: (SoftwareDetails *)softwareDetails;
// Saves a software object array to the database
+ (BOOL)saveSoftwareDetailsArrayToDatabase: (NSArray *)softwareDetailsArray;

#pragma mark - Mutate
// Converts software object to dictionary
+ (NSDictionary *)convertSoftwareDetailsToDictionary: (SoftwareDetails *)softwareDetails;
// Converts software object array to dictionary array
+ (NSArray *)convertSoftwareDetailsArrayToDictionaryArray: (NSArray *)softwareDetailsArray;
// Converts dictionary array to software object array
+ (NSArray *)convertSoftwareDetailsDictionaryArrayToSoftwareDetailsArray: (NSArray *)softwareDetailsDictionaryArray;

@end

NS_ASSUME_NONNULL_END
