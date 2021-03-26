//
//  ITunesCaching.h
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/2/21.
//

#import <Foundation/Foundation.h>

// Notification and download task description
#define THUMBNAIL_DOWNLOAD @"thumbnailDownload"
#define REGULAR_IMAGE_DOWNLOAD @"regularImageDownload"

@interface ITunesCaching : NSObject <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
- (NSData *)getImageForStringURL:(NSString *)stringURL withIdentifier: (NSString *)identifier;
@end

