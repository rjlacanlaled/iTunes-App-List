//
//  SearchResultTVC.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import "SearchResultTVC.h"
#import "ITunesFetcher.h"
#import "ITunesCaching.h"
#import "SoftwareDetails+CRUD.h"

@interface SearchResultTVC ()

@end

@implementation SearchResultTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}


#pragma mark - Initial Setup

- (void)setup {
    [self setupUI];
    [self setupNotifications];
    
}

- (void)setupUI {
    self.tableView.hidden = YES;
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSoftwares:) name:SOFTWARE_TASK_TYPE_SEARCH
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideTVC) name:@"NoResultsFound"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateThumbnails)
                                                 name:THUMBNAIL_DOWNLOAD
                                               object:nil];
    
}

#pragma mark - Notification Selectors

#define SEARCH_RESULTS @"results"
#define SEARCH_RESULT_TILE @"Search Results:"
- (void)updateSoftwares: (NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.softwares = (NSArray *)notification.userInfo;
        self.tableView.hidden = NO;
        self.title = SEARCH_RESULT_TILE;
    });
}

- (void)hideTVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *tempArr = [[NSArray alloc] init];
        self.softwares = tempArr;
        [self.tableView reloadData];
        self.tableView.hidden = YES;
    });
}

- (void)updateThumbnails {
    [self reloadTableDataOnMainQueue];
}

#pragma mark - Method Implementation

- (void)addOrRemoveToFavorites: (id)sender {
    NSDictionary *softwareDetailsDictionary = self.softwares[[sender tag]];
    SoftwareDetails *softwareDetails = [SoftwareDetails createUsingDictionary:softwareDetailsDictionary];
    NSMutableArray *mutableSelfSoftwares = [self.softwares mutableCopy];
    NSDictionary *newSoftwareDetails;
    if (![[softwareDetailsDictionary valueForKey:ITUNES_SOFTWARE_IS_FAVORITE] boolValue]) {
        BOOL saved = [SoftwareDetails saveSoftwareDetails:softwareDetails];
    } else {
        softwareDetails.isFavorite = NO;
        [SoftwareDetails deleteSoftwareDetails:softwareDetails];
    }
    newSoftwareDetails = [SoftwareDetails convertSoftwareDetailsToDictionary:softwareDetails];
    [mutableSelfSoftwares replaceObjectAtIndex:[sender tag] withObject:newSoftwareDetails];
    self.softwares = mutableSelfSoftwares;
}


@end
