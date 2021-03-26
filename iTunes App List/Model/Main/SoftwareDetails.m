//
//  SoftwareDetails.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import "SoftwareDetails.h"

@implementation SoftwareDetails

#define SOFTWARE_ID @"softwareID"
#define SOFTWARE_NAME @"softwareName"
#define SOFTWARE_COMPANY @"company"
#define SOFTWARE_THUMBNAIL_URL @"thumbnailURL"
#define SOFTWARE_SCREENSHOT_URLS @"screenshotURLs"
#define SOFTWARE_DESCRIPTION @"softwareDescription"
#define SOFTWARE_VERSION @"version"
#define SOFTWARE_FORMATTED_PRICE @"formattedPrice"
#define SOFTWARE_AVERAGE_USER_RATING @"averageUserRating"
#define SOFTWARE_RATING_COUNT @"ratingCount"
#define SOFTWARE_AVERAGE_USER_RATING_FOR_CURRENT_VERSION @"averageUserRatingForCurrentVersion"
#define SOFTWARE_RATING_COUNT_FOR_CURRENT_VERSION @"ratingCountForCurrentVersion"
#define SOFTWARE_LANGUAGE_CODES @"languageCodes"
#define SOFTWARE_GENRES @"genres"
#define SOFTWARE_MAIN_GENRE @"mainGenre"
#define SOFTWARE_IS_FAVORITE @"isFavorite"
#define SOFTWARE_SUPPORTED_DEVICES @"supportedDevices"
#define SOFTWARE_TRACK_CONTENT_RATING @"trackContentRating"
#define SOFTWARE_FILE_SIZE_BYTES @"fileSizeBytes"
#define SOFTWARE_CURRENCY @"currency"
#define SOFTWARE_TYPE @"kind"
#define SOFTWARE_TRACK_VIEW_URL @"trackViewURL"

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:self.isFavorite forKey:                           SOFTWARE_IS_FAVORITE];
    [coder encodeFloat:self.averageUserRating forKey:                   SOFTWARE_AVERAGE_USER_RATING];
    [coder encodeFloat:self.averageUserRatingForCurrentVersion forKey:  SOFTWARE_AVERAGE_USER_RATING_FOR_CURRENT_VERSION];
    [coder encodeInt64:self.softwareID forKey:                          SOFTWARE_ID];
    [coder encodeInt64:self.ratingCount forKey:                         SOFTWARE_RATING_COUNT];
    [coder encodeInt64:self.ratingCountForCurrentVersion forKey:        SOFTWARE_RATING_COUNT_FOR_CURRENT_VERSION];
    [coder encodeInt64:self.fileSizeBytes forKey:                       SOFTWARE_FILE_SIZE_BYTES];
    [coder encodeObject:self.name forKey:                               SOFTWARE_NAME];
    [coder encodeObject:self.thumbnailURL forKey:                       SOFTWARE_THUMBNAIL_URL];
    [coder encodeObject:self.screenshotURLs forKey:                     SOFTWARE_SCREENSHOT_URLS];
    [coder encodeObject:self.softwareDescription forKey:                SOFTWARE_DESCRIPTION];
    [coder encodeObject:self.version forKey:                            SOFTWARE_VERSION];
    [coder encodeObject:self.formattedPrice forKey:                     SOFTWARE_FORMATTED_PRICE];
    [coder encodeObject:self.languageCodes forKey:                      SOFTWARE_LANGUAGE_CODES];
    [coder encodeObject:self.genres forKey:                             SOFTWARE_GENRES];
    [coder encodeObject:self.mainGenre forKey:                          SOFTWARE_MAIN_GENRE];
    [coder encodeObject:self.company forKey:                            SOFTWARE_COMPANY];
    [coder encodeObject:self.supportedDevices forKey:                   SOFTWARE_SUPPORTED_DEVICES];
    [coder encodeObject:self.contentRating forKey:                      SOFTWARE_TRACK_CONTENT_RATING];
    [coder encodeObject:self.currency forKey:                           SOFTWARE_CURRENCY];
    [coder encodeObject:self.trackViewURL forKey:                       SOFTWARE_TRACK_VIEW_URL];
    [coder encodeObject:self.type forKey:                               SOFTWARE_TYPE];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.isFavorite                         = [coder decodeBoolForKey:SOFTWARE_IS_FAVORITE];
        self.averageUserRating                  = [coder decodeFloatForKey:SOFTWARE_AVERAGE_USER_RATING];
        self.averageUserRatingForCurrentVersion = [coder decodeFloatForKey:SOFTWARE_AVERAGE_USER_RATING_FOR_CURRENT_VERSION];
        self.ratingCount                        = [coder decodeInt64ForKey:SOFTWARE_RATING_COUNT];
        self.ratingCountForCurrentVersion       = [coder decodeInt64ForKey:SOFTWARE_RATING_COUNT_FOR_CURRENT_VERSION];
        self.fileSizeBytes                      = [coder decodeInt64ForKey:SOFTWARE_FILE_SIZE_BYTES];
        self.softwareID                         = [coder decodeInt64ForKey:SOFTWARE_ID];
        self.name                               = [coder decodeObjectForKey:SOFTWARE_NAME];
        self.thumbnailURL                       = [coder decodeObjectForKey:SOFTWARE_THUMBNAIL_URL];
        self.screenshotURLs                     = [coder decodeObjectForKey:SOFTWARE_SCREENSHOT_URLS];
        self.softwareDescription                = [coder decodeObjectForKey:SOFTWARE_DESCRIPTION];
        self.version                            = [coder decodeObjectForKey:SOFTWARE_VERSION];
        self.formattedPrice                     = [coder decodeObjectForKey:SOFTWARE_FORMATTED_PRICE];
        self.languageCodes                      = [coder decodeObjectForKey:SOFTWARE_LANGUAGE_CODES];
        self.genres                             = [coder decodeObjectForKey:SOFTWARE_GENRES];
        self.mainGenre                          = [coder decodeObjectForKey:SOFTWARE_MAIN_GENRE];
        self.company                            = [coder decodeObjectForKey:SOFTWARE_COMPANY];
        self.supportedDevices                   = [coder decodeObjectForKey:SOFTWARE_SUPPORTED_DEVICES];
        self.type                               = [coder decodeObjectForKey:SOFTWARE_TYPE];
        self.trackViewURL                       = [coder decodeObjectForKey:SOFTWARE_TRACK_VIEW_URL];
        self.currency                           = [coder decodeObjectForKey:SOFTWARE_CURRENCY];
        self.contentRating                      = [coder decodeObjectForKey:SOFTWARE_TRACK_CONTENT_RATING];
    }
    return self;
}

@end
