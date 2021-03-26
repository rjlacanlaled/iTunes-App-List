//
//  ITunesCaching.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/2/21.
//

#import "ITunesCaching.h"
#import "ITunesFetcher.h"

@interface ITunesCaching()
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSString *lastTaskToDownload;
@end

@implementation ITunesCaching  
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.kooapps.itunes.caching"];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];
    }
    return _session;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData *downloadData = [NSData dataWithContentsOfURL:location];
    [self cachePhotoData: downloadData toPath: downloadTask.taskDescription];
    [[NSNotificationCenter defaultCenter] postNotificationName:THUMBNAIL_DOWNLOAD object:nil];
}

- (NSData *)getImageForStringURL:(NSString *)stringURL withIdentifier: (NSString *)identifier {
    NSString *imagePath = [self createCachePathForPhotoURL:identifier];
    bool exists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
            
    if (exists) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:imagePath];
    } else {
        [self downloadImageWithURL: [NSURL URLWithString:stringURL] withTaskDescription: imagePath];
        return nil;
    }
}

- (NSString *)getCachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}


- (NSString *)createCachePathForPhotoURL: (NSString *)stringURL {
    return [[self getCachesDirectory] stringByAppendingPathComponent:stringURL];
}

- (void)downloadImageWithURL: (NSURL *)url withTaskDescription: (NSString *)taskDescription {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request];
    task.taskDescription = taskDescription;
    [task resume];
}

- (void)cachePhotoData: (NSData *)downloadData toPath: (NSString *)path {
    [NSKeyedArchiver archiveRootObject:downloadData toFile:path];
}

@end
