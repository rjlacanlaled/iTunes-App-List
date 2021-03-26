//
//  SoftwareTVC.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/1/21.
//

#import "SoftwareTVC.h"
#import "ITunesFetcher.h"
#import "ITunesCaching.h"
#import "SoftwareDetailsVC.h"
#import "SoftwareDetails+CRUD.h"


@interface SoftwareTVC ()
@property (strong, nonatomic) ITunesCaching *itunesCaching;
@end

@implementation SoftwareTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"ShowSoftwareDetails"]) {
        if ([segue.destinationViewController isKindOfClass:[SoftwareDetailsVC class]]) {
            [self prepareSoftwareDetailsVC: segue.destinationViewController forIndexPath: indexPath];
        }
    }
}


#pragma mark - Properties

@synthesize softwares = _softwares;

- (ITunesCaching *)itunesCaching {
    if (!_itunesCaching) {
        _itunesCaching = [[ITunesCaching alloc] init];
    }
    return _itunesCaching;
}

- (NSArray *)softwares {
    if (!_softwares) {
        _softwares = [[NSArray alloc] init];
    }
    return _softwares;
}

- (void)setSoftwares:(NSArray *)softwares {
    _softwares = softwares;
    [self reloadTableDataOnMainQueue];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.softwares count];
}

#define IMAGE_VIEW_BORDER_WIDTH 0.90f
#define DEFAULT_THUMBNAIL_PLACEHOLDER_IMAGE_NAME @"default-placeholder-image"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoftwareDetail" forIndexPath:indexPath];

    NSDictionary *softwareDetail = self.softwares[indexPath.row];
    cell.textLabel.text = [softwareDetail valueForKey:ITUNES_SOFTWARE_TRACK_NAME];
    cell.detailTextLabel.text = [NSString stringWithFormat:
                                 @"%@ | %@ | %@",
                                 [self textForStarRatingsForSoftwareDetails:softwareDetail],
                                 [softwareDetail valueForKey:ITUNES_SOFTWARE_ARTIST_NAME],
                                 [softwareDetail valueForKey:ITUNES_SOFTWARE_PRIMARY_GENRE_NAME]];
    [self createFavoriteButtonForCell:cell withIndexPath: indexPath withShade:
     [[softwareDetail valueForKeyPath:ITUNES_SOFTWARE_IS_FAVORITE] boolValue]];
    
    // Configure the cell...
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.imageView.layer.borderWidth = IMAGE_VIEW_BORDER_WIDTH;
        cell.imageView.layer.borderColor = [UIColor redColor].CGColor;
        cell.imageView.image = [self getImageForSoftwareDetail: softwareDetail];
    });
    
    return cell;
}

#pragma mark - Helper Methods

#define IMAGE_FOR_SHADED_ICON @"star.fill"
#define IMAGE_FOR_NORMAL_ICON @"star"
#define FAVORITE_BUTTON_WIDTH 30.0
#define FAVORITE_BUTTON_HEIGHT 30.0

- (void)createFavoriteButtonForCell: (UITableViewCell *)cell withIndexPath: (NSIndexPath *)indexPath withShade: (BOOL)withShade {
    UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [favoriteButton setTitle:@"" forState:UIControlStateNormal];
    [favoriteButton setBackgroundImage:[UIImage systemImageNamed:withShade ? IMAGE_FOR_SHADED_ICON : IMAGE_FOR_NORMAL_ICON]
                              forState:UIControlStateNormal];
    [favoriteButton setFrame:CGRectMake(0, 0, FAVORITE_BUTTON_WIDTH, FAVORITE_BUTTON_HEIGHT)];
    [favoriteButton setTintColor:[UIColor redColor]];
    [favoriteButton setTag:indexPath.row];
    [favoriteButton addTarget:self action:@selector(addOrRemoveToFavorites:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = favoriteButton;
}

- (void)addOrRemoveToFavorites: (id)sender {
    // Abstract method
}

- (void)reloadTableDataOnMainQueue {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)prepareSoftwareDetailsVC:(SoftwareDetailsVC *)softwareDetailsVC
                    forIndexPath: (NSIndexPath *)indexPath {
    softwareDetailsVC.title = @"App Details";
    softwareDetailsVC.softwareDetails = self.softwares[indexPath.row];
}

- (UIImage *)getImageForSoftwareDetail: (NSDictionary *)softwareDetail {
    NSData *imageData = [self.itunesCaching getImageForStringURL:
                         [softwareDetail valueForKeyPath:ITUNES_SOFTWARE_THUMBNAIL_URL]
                         withIdentifier:[NSString stringWithFormat:@"%ld", [[softwareDetail valueForKeyPath:ITUNES_SOFTWARE_TRACK_ID] longValue]]];
    return imageData ?
    [UIImage imageWithData:imageData] :
    [UIImage imageNamed:DEFAULT_THUMBNAIL_PLACEHOLDER_IMAGE_NAME];
}

- (NSString *)textForStarRatingsForSoftwareDetails: (NSDictionary *)softwareDetails {
    
    // Get rounded rating
    float averageRating = [[softwareDetails valueForKey:ITUNES_SOFTWARE_AVERAGE_RATING] floatValue];
    NSString *roundedRatings = [NSString stringWithFormat:@"%.1f", averageRating];
    float roundedAverageRatings = [roundedRatings floatValue];
    NSInteger wholeNumber = roundedAverageRatings;
    float floatingNumber = roundedAverageRatings - wholeNumber;
    NSString *starRating = @"";
    for (int i = 1; i <= 5; i++) {
        if (wholeNumber > 0) {
            starRating = [starRating stringByAppendingString:@"★"];
            wholeNumber--;
        } else if (floatingNumber > 0) {
            if (floatingNumber >= 0.5) {
                starRating = [starRating stringByAppendingString:@"★"];
            } else {
                starRating = [starRating stringByAppendingString:@"☆"];
            }
            floatingNumber = 0.0;
        } else {
            starRating = [starRating stringByAppendingString:@"☆"];
        }
    }

    return starRating;
}

@end
