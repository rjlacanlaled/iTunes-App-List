//
//  ITunesFetcher.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 1/30/21.
//

#import "ITunesFetcher.h"
#import "SoftwareDetails+CRUD.h"

@interface ITunesFetcher() <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation ITunesFetcher

#pragma mark - Download Delegates
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData *downloadData = [NSData dataWithContentsOfURL:location];
    NSError *error;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:downloadData
                                                                  options:0
                                                                    error:&error];

    if (!error) {
        
        if ([downloadTask.taskDescription isEqualToString:SOFTWARE_TASK_TYPE_SEARCH]) {
            if ([[dataDictionary valueForKey:RESULTS_COUNT] intValue] < 1) {
                [self sendNoResultsNotification];
                return;
            }
        }
        NSMutableArray *softwares = [[dataDictionary valueForKey: RESULTS] mutableCopy];
        for (int i = 0; i < [softwares count]; i++) {
            SoftwareDetails *softwareDetails = [SoftwareDetails fetchDetailsWithDictionary:softwares[i]];
            if (softwareDetails != nil) {
                NSDictionary *dictionary = [SoftwareDetails convertSoftwareDetailsToDictionary:softwareDetails];
                [softwares replaceObjectAtIndex:i
                                     withObject:dictionary];
            }
        }
        
        NSDictionary *softwaresToBeDisplayed = [softwares mutableCopy];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:downloadTask.taskDescription object:nil userInfo:softwaresToBeDisplayed];
    } else {
        [self sendNoResultsNotification];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"%@", error.description);
    }
}

#pragma mark - Properties

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.kooapps.itunes.fetcher"];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];
    }
    return _session;
}

#pragma mark - Fetch methods

#define DEFAULT_COUNTRY @"us"
#define DEFAULT_LIMIT 25

#define ITUNES_LINK @"https://itunes.apple.com"

- (NSURL *)URLForSearchResultsWithKeyword: (NSString *)keyword forCategory: (NSString *)category {

    NSString *stringURL = [NSString stringWithFormat:
                              @"%@/search?entity=%@&term=%@&country=%@&limit=%d",
                              ITUNES_LINK,
                              category,
                              keyword,
                              DEFAULT_COUNTRY,
                              DEFAULT_LIMIT];
    
    return [self fixURL:stringURL];
}

- (NSURL *)URLForDetailsWithID: (NSString *)lookupID {
    
    NSString *stringURL = [NSString stringWithFormat:
                           @"%@/lookup?id=%@",
                           ITUNES_LINK,
                           lookupID
                           ];
    
    return [self fixURL:stringURL];
}

- (NSURL *)fixURL: (NSString *)stringURL {
    stringURL = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:stringURL];
}

#define SOFTWARE_CATEGORY @"software"

- (void)downloadSoftwareDataWithKeyword: (NSString *)keyword {
    NSURLRequest *request = [NSURLRequest requestWithURL:[self URLForSearchResultsWithKeyword:keyword forCategory:SOFTWARE_CATEGORY]];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request];
    task.taskDescription = SOFTWARE_TASK_TYPE_SEARCH;
    [task resume];
}

- (void)downloadSoftwareDataWithID: (NSString *)softwareID {
    NSURLRequest *request = [NSURLRequest requestWithURL:[self URLForDetailsWithID:softwareID]];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request];
    task.taskDescription = SOFTWARE_TASK_TYPE_DETAILS;
    [task resume];
}

- (void)sendNoResultsNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoResultsFound" object:nil];
}

@end
