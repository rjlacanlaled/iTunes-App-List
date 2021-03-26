//
//  SoftwareSearchVC.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/1/21.
//

#import "SoftwareSearchVC.h"
#import "SoftwareTVC.h"
#import "ITunesFetcher.h"

@interface SoftwareSearchVC () <UISearchBarDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *noResultsFoundLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchingActivityIndicator;

// Other properties
@property (strong, nonatomic) NSString *recentlyFetchedKeyword;
@property (strong, nonatomic) ITunesFetcher *fetcher;
@property (strong, nonatomic) NSTimer *apiCalltimer;

@end

@implementation SoftwareSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

#pragma mark - Properties

- (NSTimer *)apiCalltimer {
    if (!_apiCalltimer) {
        _apiCalltimer = [[NSTimer alloc] init];
    }
    return _apiCalltimer;
}

- (ITunesFetcher *)fetcher {
    if (!_fetcher) {
        _fetcher = [[ITunesFetcher alloc] init];
    }
    return _fetcher;
}

#pragma mark - Initial Setup

- (void)setup {
    [self setupDelegates];
    [self setupUI];
    [self setupNotifications];
}

- (void)setupDelegates {
    self.searchBar.delegate = self;
}

#define NO_RESULT_LABEL @"No Results Found!"
#define DEFAULT_RESULT_LABEL @"Search for your favorite apps!"

- (void)setupUI {
    self.noResultsFoundLabel.text = DEFAULT_RESULT_LABEL;
    self.noResultsFoundLabel.hidden = NO;
    self.searchingActivityIndicator.hidden = YES;
}

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNoResultsFoundLabel) name:@"NoResultsFound"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSoftwareTVC)
                                                 name:SOFTWARE_TASK_TYPE_SEARCH
                                               object:nil];
}

#pragma mark - Searchbar Delegate

#define SEARCH_DELAY 0.75f

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.apiCalltimer invalidate];
        if ([[self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [self postNotificationWithName: @"NoResultsFound"];
            [self showNoResultsFoundLabelWithText:DEFAULT_RESULT_LABEL];
        } else {
            self.apiCalltimer = [NSTimer scheduledTimerWithTimeInterval:SEARCH_DELAY repeats:NO block:^(NSTimer * _Nonnull timer) {
                self.recentlyFetchedKeyword = searchText;
                [self beginFetchingSoftwareForKeyword:searchText];
            }];
        }
    });
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![searchBar.text isEqualToString:self.recentlyFetchedKeyword] &&
            ![self stringIsEmpty:searchBar.text]) {
            self.recentlyFetchedKeyword = searchBar.text;
            [self beginFetchingSoftwareForKeyword:searchBar.text];
        }
        [searchBar resignFirstResponder];
    });
    
}


#pragma mark - Helper Methods

- (void)showNoResultsFoundLabel {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self deactivateUIForSearching];
        [self showNoResultsFoundLabelWithText: [self stringIsEmpty:self.searchBar.text] ?
                        DEFAULT_RESULT_LABEL : NO_RESULT_LABEL];
    });
}

- (void)showSoftwareTVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noResultsFoundLabel.hidden = YES;
        [self deactivateUIForSearching];
    });
}

- (void)beginFetchingSoftwareForKeyword: (NSString *)keyword {
    [self activateUIForSearching];
    [self.fetcher downloadSoftwareDataWithKeyword:keyword];
    self.noResultsFoundLabel.hidden = YES;
}

- (void)postNotificationWithName: (NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

- (BOOL)stringIsEmpty: (NSString *)string {
    return [[string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]
     isEqualToString:@""] ? YES : NO;
}

#pragma mark - UI Methods

- (void)activateUIForSearching {
    self.searchingActivityIndicator.hidden = NO;
    [self.searchingActivityIndicator startAnimating];
}

- (void)deactivateUIForSearching {
    [self.searchingActivityIndicator stopAnimating];
    self.searchingActivityIndicator.hidden = YES;
}

- (void)showNoResultsFoundLabelWithText: (NSString *)text {
    self.noResultsFoundLabel.text = text;
    self.noResultsFoundLabel.hidden = NO;
}


@end
