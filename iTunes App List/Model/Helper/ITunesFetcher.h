//
//  ITunesFetcher.h
//  iTunes App List
//
//  Created by RJ Lacanlale on 1/30/21.
//

#import <Foundation/Foundation.h>

#pragma mark - Dictionary Keys
// Main software details
#define ITUNES_SOFTWARE_ARTIST_ID @"artistId"
#define ITUNES_SOFTWARE_ARTIST_NAME @"artistName"
#define ITUNES_SOFTWARE_DESCRIPTION @"description"
#define ITUNES_SOFTWARE_GENRE_IDS @"genreIds"
#define ITUNES_SOFTWARE_GENRES @"genres"
#define ITUNES_SOFTWARE_PRIMARY_GENRE_ID @"primaryGenreId"
#define ITUNES_SOFTWARE_PRIMARY_GENRE_NAME @"primaryGenreName"
#define ITUNES_SOFTWARE_SCREENSHOT_URLS @"screenshotUrls"
#define ITUNES_SOFTWARE_PRICE @"price"
#define ITUNES_SOFTWARE_SUPPORTED_DEVICES @"supportedDevices"
#define ITUNES_SOFTWARE_TRACK_ID @"trackId"
#define ITUNES_SOFTWARE_TRACK_NAME @"trackName"
#define ITUNES_SOFTWARE_LANGUAGE_CODES @"languageCodesISO2A"
#define ITUNES_SOFTWARE_VERSION @"version"
#define ITUNES_SOFTWARE_RATING_COUNT @"userRatingCount"
#define ITUNES_SOFTWARE_RATING_COUNT_CURRENT_VERSION @"userRatingCountForCurrentVersion"
#define ITUNES_SOFTWARE_AVERAGE_RATING @"averageUserRating"
#define ITUNES_SOFTWARE_AVERAGE_RATING_CURRENT_VERSION @"averageUserRatingForCurrentVersion"
#define ITUNES_SOFTWARE_TRACK_VIEW_URL @"trackViewUrl"
#define ITUNES_SOFTWARE_IPAD_SCREENSHOT_URLS @"ipadScreenshotUrls"
#define ITUNES_SOFTWARE_FORMATTED_PRICE @"formattedPrice"
#define ITUNES_SOFTWARE_THUMBNAIL_URL @"artworkUrl100"
#define ITUNES_SOFTWARE_IS_FAVORITE @"isFavorite"
#define ITUNES_SOFTWARE_TRACK_CONTENT_RATING @"trackContentRating"
#define ITUNES_SOFTWARE_FILE_SIZE_BYTES @"fileSizeBytes"
#define ITUNES_SOFTWARE_CURRENCY @"currency"
#define ITUNES_SOFTWARE_TYPE @"kind"

// Notification and download task description
#define SOFTWARE_TASK_TYPE_SEARCH @"ITunesSearchList"
#define SOFTWARE_TASK_TYPE_THUMBNAIL @"TunesThumbnailDownload"
#define SOFTWARE_TASK_TYPE_DETAILS @"ITunesSoftwareDetails"

// Results
#define RESULTS @"results"
#define RESULTS_COUNT @"resultCount"

@interface ITunesFetcher : NSObject

// Returns the full URL that can be used to fetch data from iTunes
// with the given keyword and category
- (NSURL *)URLForSearchResultsWithKeyword: (NSString *)keyword forCategory: (NSString *)category;

// Returns the full URL that can be used to fetch data from iTudes
// with the given lookup ID
- (NSURL *)URLForDetailsWithID: (NSString *)lookupID;

// Fetches all the search results with the corresponding keyword then posts
// a notification on notification name "ITunesSearchResults" with
// an NSDictionary containing the actual search result
- (void)downloadSoftwareDataWithKeyword: (NSString *)keyword;

// Fetches the data of a specific software then posts a notification
// on notification name "ITunesSoftwareDetailResult" with an NSDictionary
// containing the actual software details result
- (void)downloadSoftwareDataWithID: (NSString *)softwareID;
@end

