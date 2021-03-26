//
//  FavoriteSoftwareTVC.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import "FavoriteSoftwareTVC.h"
#import "ITunesFetcher.h"
#import "ArraySorter.h"
#import "SoftwareDetails+CRUD.h"

@interface FavoriteSoftwareTVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortOrderSegmentedControl;

@end

@implementation FavoriteSoftwareTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.dataMode != Selected) {
        self.dataMode = All;
    }
    [self.sortTypeSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [self.sortOrderSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
}

- (void)viewWillAppear: (BOOL)animated {
    [super viewWillAppear:YES];
    if (self.dataMode == All) {
        [self updateSoftwares];
    }
}

- (void)updateSoftwares {
    NSArray *favoriteSoftwares = [SoftwareDetails fetchAll];
    favoriteSoftwares = [SoftwareDetails convertSoftwareDetailsArrayToDictionaryArray:favoriteSoftwares];
    self.softwares = favoriteSoftwares;
    [self sortSoftwareDetails];
}

#pragma mark - Segmented Control Action
- (IBAction)sortTypeSegmentedControlValueChanged:(UISegmentedControl *)sender {
    [self sortSoftwareDetails];
}

- (IBAction)sortOrderSegmentedControlValueChanged:(UISegmentedControl *)sender {
    [self sortSoftwareDetails];
}


#pragma mark - Method Implementation

- (void)addOrRemoveToFavorites: (id)sender {
    NSDictionary *softwareDetailsDictionary = self.softwares[[sender tag]];
    SoftwareDetails *softwareDetails = [SoftwareDetails createUsingDictionary:softwareDetailsDictionary];
    NSMutableArray *mutableSelfSoftwares = [self.softwares mutableCopy];
    if (![[softwareDetailsDictionary valueForKey:ITUNES_SOFTWARE_IS_FAVORITE] boolValue]) {
        BOOL saved = [SoftwareDetails saveSoftwareDetails:softwareDetails];
    } else {
        [SoftwareDetails deleteSoftwareDetails:softwareDetails];
    }
    [mutableSelfSoftwares removeObjectAtIndex:[sender tag]];
    self.softwares = mutableSelfSoftwares;
}

- (void)sortSoftwareDetails {
    
    BOOL isAscending = !self.sortOrderSegmentedControl.selectedSegmentIndex;
    
    switch (self.sortTypeSegmentedControl.selectedSegmentIndex) {
        case SoftwareName:
            self.softwares = [ArraySorter sortArray:self.softwares
                                         forKeyPath:ITUNES_SOFTWARE_TRACK_NAME
                                        isAscending:isAscending];
            break;
        case CompanyName:
            self.softwares = [ArraySorter sortArray:self.softwares
                                         forKeyPath:ITUNES_SOFTWARE_ARTIST_NAME
                                        isAscending:isAscending];
            break;
        case Rating:
            self.softwares = [ArraySorter sortArrayByNumber:self.softwares
                                         forKeyPath:ITUNES_SOFTWARE_AVERAGE_RATING
                                        isAscending:isAscending];
            break;
        case Genre:
            self.softwares = [ArraySorter sortArray:self.softwares
                                         forKeyPath:ITUNES_SOFTWARE_PRIMARY_GENRE_NAME
                                        isAscending:isAscending];
            break;
    }
}

@end
