//
//  SoftwareDetails.h
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import <Foundation/Foundation.h>

@interface SoftwareDetails : NSObject <NSCoding>
@property (nonatomic) BOOL isFavorite;
@property (nonatomic) float averageUserRating;
@property (nonatomic) float averageUserRatingForCurrentVersion;
@property (nonatomic) NSInteger fileSizeBytes;
@property (nonatomic) NSInteger softwareID;
@property (nonatomic) NSInteger ratingCount;
@property (nonatomic) NSInteger ratingCountForCurrentVersion;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *thumbnailURL;
@property (strong, nonatomic) NSString *trackViewURL;
@property (strong, nonatomic) NSArray<NSString *>* screenshotURLs;
@property (strong, nonatomic) NSString *softwareDescription;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *formattedPrice;
@property (strong, nonatomic) NSArray<NSString *>* languageCodes;
@property (strong, nonatomic) NSArray<NSString *>* genres;
@property (strong, nonatomic) NSArray<NSString *>* supportedDevices;
@property (strong, nonatomic) NSString *mainGenre;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *contentRating;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSString *type;

@end
