//
//  SoftwareDetailsVC.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/2/21.
//

#import "SoftwareDetailsVC.h"
#import "GenreSoftwareTVC.h"
#import "FavoriteSoftwareTVC.h"
#import "ITunesCaching.h"
#import "ITunesFetcher.h"
#import "SoftwareDetails+CRUD.h"
#import "ArraySorter.h"


@interface SoftwareDetailsVC ()

@property (strong, nonatomic) ITunesCaching *itunesCaching;

#pragma mark - UIView
@property (weak, nonatomic) IBOutlet UIView *screenshotContentView;

#pragma mark - UIScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *screenshotScrollView;

#pragma mark - UIImageView

@property (weak, nonatomic) IBOutlet UIImageView *mainSoftwareImage;
#pragma mark - TextView

@property (weak, nonatomic) IBOutlet UITextView *softwareDescriptionTextView;

#pragma mark - UILabel First Part
@property (weak, nonatomic) IBOutlet UILabel *softwareNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *softwareTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;

#pragma mark - UILabel Second Part
// Overall
@property (weak, nonatomic) IBOutlet UILabel *overallRatingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *overallAverageRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *overallStarRatingLabel;
// Current version
@property (weak, nonatomic) IBOutlet UILabel *currentVersionLabel;

// Content Rating
@property (weak, nonatomic) IBOutlet UILabel *contentRatingLabel;

// Currency
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

// File Size
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

// Genre
@property (weak, nonatomic) IBOutlet UILabel *mainGenreLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionalGenreLabel;
// Language
@property (weak, nonatomic) IBOutlet UILabel *mainLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionalLanguageLabel;

// More Company Apps
@property (weak, nonatomic) IBOutlet UILabel *moreAppsByCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *noAdditionalCompanyAppsLabel;

// All Genre
@property (weak, nonatomic) IBOutlet UILabel *allGenreForAppLabel;

// Ignore
@property (weak, nonatomic) IBOutlet UIButton *ignoreThisButton;

#pragma mark - UIButton
@property (weak, nonatomic) IBOutlet UIButton *formattedPriceButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation SoftwareDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self textForStarRatings];
    [self setup];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DisplayCompanySoftware"]) {
        if ([segue.destinationViewController isKindOfClass:[FavoriteSoftwareTVC class]]) {
            [self prepareFavoriteSoftwareTVC: segue.destinationViewController];
        }
    }
    
    if ([segue.identifier isEqualToString:@"DisplaySoftwareGenres"]) {
        if ([segue.destinationViewController isKindOfClass:[GenreSoftwareTVC class]]) {
            [self prepareGenreSoftwareTVC: segue.destinationViewController];
        }
    }
}

#define DEFAULT_OTHER_APPS_LABEL @"No other app by %@ is saved on your favorites."

#pragma mark - Segue Methods

- (void)prepareFavoriteSoftwareTVC: (FavoriteSoftwareTVC *)favoriteSoftwareTVC {
    favoriteSoftwareTVC.dataMode = Selected;
    NSArray *companySoftwareDetails = [SoftwareDetails fetchAllCompanySoftwareForSoftwareDetailsDictionary:self.softwareDetails];
    if ([companySoftwareDetails count] > 0) {
        self.noAdditionalCompanyAppsLabel.hidden = YES;
        favoriteSoftwareTVC.softwares = [ArraySorter sortArray:companySoftwareDetails
                                                    forKeyPath:ITUNES_SOFTWARE_TRACK_NAME
                                                   isAscending:YES];
    } else {
        favoriteSoftwareTVC.tableView.hidden = YES;
        self.noAdditionalCompanyAppsLabel.text = [NSString stringWithFormat:
                                                  DEFAULT_OTHER_APPS_LABEL,
                                                  [self.softwareDetails valueForKey:ITUNES_SOFTWARE_ARTIST_NAME]];
    }
}

#define DEFAULT_GENRE_BY_APP_LABEL @"No other genre related to %@'s genre is saved on your favorites."

- (void)prepareGenreSoftwareTVC: (GenreSoftwareTVC *)genreSoftwareTVC {
    genreSoftwareTVC.dataMode = Selected;
    NSDictionary *genreSoftwares = [SoftwareDetails fetchAllGenreSoftwareForSoftwareDetailsDictionary:self.softwareDetails];
    if ([genreSoftwares count] > 0) {
        self.allGenreForAppLabel.hidden = YES;
        genreSoftwareTVC.genreSoftwares = genreSoftwares;
    } else {
        genreSoftwareTVC.tableView.hidden = YES;
        self.allGenreForAppLabel.text = [NSString stringWithFormat:
                                                  DEFAULT_GENRE_BY_APP_LABEL,
                                                  [self.softwareDetails valueForKey:ITUNES_SOFTWARE_TRACK_NAME]];
    }
    
}

#pragma mark - UIButton Actions

- (IBAction)favoriteButtonClicked:(UIButton *)sender {
    BOOL isFavorite = [[self.softwareDetails valueForKey:ITUNES_SOFTWARE_IS_FAVORITE] boolValue];
    SoftwareDetails *software;
    if (isFavorite) {
        software = [SoftwareDetails fetchDetailsWithDictionary:self.softwareDetails];
        software.isFavorite = NO;
        isFavorite = NO;
        self.softwareDetails = [SoftwareDetails convertSoftwareDetailsToDictionary:software];
        [SoftwareDetails deleteSoftwareDetails:software];
    } else {
        isFavorite = YES;
        software = [SoftwareDetails createUsingDictionary:self.softwareDetails];
        [SoftwareDetails saveSoftwareDetails:software];
        self.softwareDetails = [SoftwareDetails convertSoftwareDetailsToDictionary:software];
    }
    [self.favoriteButton setBackgroundImage:[self imageForButtonWithShade:isFavorite]
                                   forState:UIControlStateNormal];
}

#define WARNING_MESSAGE @"Warning, you are about to leave this app!"
#define CONFIRMATION_MESSAGE @"Are you sure you want to visit"
#define YES_ACTION_MESSAGE @"It's aight, right?"
#define NO_ACTION_MESSAGE @"Abort! Abort!"
#define FAILED_TITLE_MESSAGE @"Failed to visit link!"
#define FAILED_MESSAGE @"There was an error opening the link, please try again later."

- (IBAction)formattedPriceButtonClicked:(id)sender {
    NSString *stringURL = [self.softwareDetails valueForKey:ITUNES_SOFTWARE_TRACK_VIEW_URL];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:WARNING_MESSAGE
                               message:[NSString stringWithFormat:@"%@ %@?",
                                        CONFIRMATION_MESSAGE,
                                        stringURL]
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:YES_ACTION_MESSAGE style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:stringURL]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL] options:@{} completionHandler:nil];
        } else {
            UIAlertController* failedAlert = [UIAlertController alertControllerWithTitle:FAILED_TITLE_MESSAGE
                                       message:FAILED_MESSAGE
                                       preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {}];
            [failedAlert addAction:okayAction];
            [self presentViewController:failedAlert animated:YES completion:nil];
        }
    }];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:NO_ACTION_MESSAGE style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];

    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)whyYouTapThisButton:(UIButton *)sender {
    UIAlertController* nothingHappeningHere = [UIAlertController alertControllerWithTitle:@"Aren't you a curious fella?"
                               message:@"I'm only gonna ask once. DO NOT TAP PROCEED!"
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* proceedAction = [UIAlertAction actionWithTitle:@"PROCEED AT YOUR OWN RISK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
        UIAlertController* didntIWarnYouAlert = [UIAlertController alertControllerWithTitle:@"TSK TSK TSK"
                                   message:@"I moved down here in case you didn't see my previous warning... This is your last chance, go back now or you will regret what's gonna happen next."
                                   preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* goBack = [UIAlertAction actionWithTitle:@"Ok ok, I wanna go back now..." style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}];
        UIAlertAction* proceedAnyway = [UIAlertAction actionWithTitle:@"PROCEED ANYWAY, NOT A WISE CHOICE *SMH*" style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
            UIAlertController* aboutToEnter = [UIAlertController alertControllerWithTitle:@"WARNING!!!"
                                       message:@"You are about to enter a NSFW(maybe) site, don't tell me I didn't warn ya."
                                       preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* backOutAction = [UIAlertAction actionWithTitle:@"F*K DIS SH*T I'M OUT!!!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
}];
            UIAlertAction* enterAction = [UIAlertAction actionWithTitle:@"I WANNA ENTER! LET ME IN, PAPI! (please don't report me to HR)" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://matias.ma/nsfw/"] options:@{} completionHandler:nil];
            }];
            [aboutToEnter addAction:backOutAction];
            [aboutToEnter addAction:enterAction];
            [self presentViewController:aboutToEnter animated:YES completion:nil];
        }];
        [didntIWarnYouAlert addAction:goBack];
        [didntIWarnYouAlert addAction:proceedAnyway];
        [self presentViewController:didntIWarnYouAlert animated:YES completion:nil];
        
    }];
    UIAlertAction* aightAction = [UIAlertAction actionWithTitle:@"Tap this to cancel and never look back. " style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];
    
    [nothingHappeningHere addAction:proceedAction];
    [nothingHappeningHere addAction:aightAction];
    [self presentViewController:nothingHappeningHere animated:YES completion:nil];
}

#pragma mark - Properties

- (void)setSoftwareDetails:(NSDictionary *)softwareDetails {
    _softwareDetails = softwareDetails;
}

- (ITunesCaching *)itunesCaching {
    if (!_itunesCaching) {
        _itunesCaching = [[ITunesCaching alloc] init];
    }
    return _itunesCaching;
}


#pragma mark - UI Update

- (void)setup {
    [self setupNotifications];
    [self updateUI];
}

- (void)updateUI {
    [self updateMainDetailsUI];
    [self updateSubDetailsUI];
    [self updateScreenshotView];
    [self updateImages];
}

- (void)updateMainDetailsUI {
    // Image
    self.mainSoftwareImage.image = [self getImageForSoftwareDetail:self.softwareDetails];
    // Software name
    self.softwareNameLabel.text = [self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_TRACK_NAME];
    self.softwareTypeLabel.text = [self.softwareDetails valueForKey:ITUNES_SOFTWARE_TYPE];
    // Company name
    self.companyNameLabel.text = [self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_ARTIST_NAME];
    // Formatted Price
    [self.formattedPriceButton setTitle:[self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_FORMATTED_PRICE]
                               forState:UIControlStateNormal] ;
    // Favorite Button
    [self.favoriteButton setBackgroundImage:[self imageForButtonWithShade: [[self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_IS_FAVORITE] boolValue]]
                                   forState:UIControlStateNormal];
}

- (void)updateSubDetailsUI {
    // Overall rating
    self.overallRatingCountLabel.text = [self textForRatingCountWithKey: ITUNES_SOFTWARE_RATING_COUNT];
    self.overallAverageRatingLabel.text = [self textForAverageRatingWithKey:ITUNES_SOFTWARE_AVERAGE_RATING];
    self.overallStarRatingLabel.text = [self textForStarRatings];
    // Current version
    self.currentVersionLabel.text = [NSString stringWithFormat:
                                     @"Ver %@",
                                     [self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_VERSION]];
    // Genre
    self.mainGenreLabel.text = [self.softwareDetails valueForKey:ITUNES_SOFTWARE_PRIMARY_GENRE_NAME];
    self.additionalGenreLabel.text = [self textForAdditionalDetailsForKey: ITUNES_SOFTWARE_GENRES];
    // Language
    self.mainLanguageLabel.text = [self getMainLanguageLabel];
    self.additionalLanguageLabel.text = [self textForAdditionalDetailsForKey:ITUNES_SOFTWARE_LANGUAGE_CODES];
    self.softwareDescriptionTextView.text = [self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_DESCRIPTION];
    // Currency
    self.currencyLabel.text = [self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_CURRENCY];
    // Size
    NSInteger fileByteSize = [[self.softwareDetails valueForKey:ITUNES_SOFTWARE_FILE_SIZE_BYTES] longLongValue];
    float fileMBSize = fileByteSize / 1000000.0;
    self.fileSizeLabel.text = fileMBSize > 0 ? [NSString stringWithFormat:@"%.2f MB", fileMBSize] : @"N/A";
    // Content Rating
    self.contentRatingLabel.text = [self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_TRACK_CONTENT_RATING];
    // Company Label
    self.moreAppsByCompanyLabel.text = [NSString stringWithFormat:
                                        @"More apps by %@",
                                        [self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_ARTIST_NAME]];
}

#pragma mark - Initial Setup

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateImages)
                                                 name:THUMBNAIL_DOWNLOAD
                                               object:nil];
}

#pragma mark - Helper Methods

#define IMAGE_VIEW_BORDER_WIDTH 0.90f
#define DEFAULT_THUMBNAIL_PLACEHOLDER_IMAGE_NAME @"default-placeholder-image"
- (UIImage *)getImageForURL:(NSString *)stringURL withIdentifier:(NSString *)imageIdentifier {
    NSData *imageData = [self.itunesCaching getImageForStringURL: stringURL
                                                  withIdentifier:imageIdentifier];
    
    return imageData ?
    [UIImage imageWithData:imageData] :
    NULL;

}

#define IMAGE_FOR_SHADED_ICON @"star.fill"
#define IMAGE_FOR_NORMAL_ICON @"star"

- (UIImage *)imageForButtonWithShade:(BOOL)withShade   {
    return [UIImage systemImageNamed:withShade ? IMAGE_FOR_SHADED_ICON : IMAGE_FOR_NORMAL_ICON];
}

#define DEFAULT_RATING_LABEL @"NO RATINGS YET"

- (NSString *)textForRatingCountWithKey: (NSString *)key {
    
    NSInteger ratingCount = [[self.softwareDetails valueForKeyPath:key] longValue];
    NSString *ratingCountString;
    float ratingCountFloat;
    if (ratingCount > 1000 && ratingCount < 999999) {
        ratingCountFloat = ratingCount / 1000.0;
        if (ratingCountFloat == floorf(ratingCountFloat)) {
            ratingCountString = [NSString stringWithFormat:@"%dK RATINGS", (int)ratingCountFloat];
        } else {
            ratingCountString = [NSString stringWithFormat:@"%.1fK RATINGS", ratingCountFloat];
        }
    } else if (ratingCount > 999999) {
        ratingCountFloat = ratingCount / 1000000;
        if (ratingCountFloat == floorf(ratingCountFloat)) {
            ratingCountString = [NSString stringWithFormat:@"%dM RATINGS", (int)ratingCountFloat];
        } else {
            ratingCountString = [NSString stringWithFormat:@"%.1fM RATINGS", ratingCountFloat];
        }
    } else {
        ratingCountString = [NSString stringWithFormat:@"%ld RATINGS", ratingCount];
    }
    return ratingCount > 0 ? ratingCountString : DEFAULT_RATING_LABEL;
}

- (NSString *)textForAverageRatingWithKey: (NSString *)key {
    float averageRating = [[self.softwareDetails valueForKey:key] floatValue];
    return [NSString stringWithFormat:@"%.1f", averageRating];
}

#define DEFAULT_ADDITIONAL_DETAILS_LABEL @"No additional"

- (NSString *)textForAdditionalDetailsForKey: (NSString *)key {
    NSArray *detailsArray = [self.softwareDetails valueForKey:key];
    NSInteger count = [detailsArray count] - 1;
    return count > 0 ? [NSString stringWithFormat:@"+%ld More", count] : DEFAULT_ADDITIONAL_DETAILS_LABEL;
}

- (NSString *)getMainLanguageLabel {
    return [[self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_LANGUAGE_CODES]  containsObject:@"EN"] ? @"EN" :
    [[self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_LANGUAGE_CODES] firstObject];
}

#define DEFAULT_HEIGHT 400.0
#define WIDTH_SCALE_FACTOR 0.45
- (void)updateScreenshotView {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *screenshots = [self getScreenshots];
        UIImage *image = (UIImage *)screenshots.firstObject;
        float imageWidth = (image.size.width * WIDTH_SCALE_FACTOR);
        float height = DEFAULT_HEIGHT;
        [self.screenshotContentView setFrame:CGRectMake(0, 0, (imageWidth * [screenshots count]), height)];
        [self.screenshotScrollView setFrame:CGRectMake(self.screenshotScrollView.frame.origin.x,
                                                       self.screenshotScrollView.frame.origin.y,
                                                       self.screenshotContentView.frame.size.width,
                                                        height)];
        [self.screenshotScrollView setContentSize:CGSizeMake(self.screenshotContentView.frame.size.width, self.screenshotContentView.frame.size.height)];
        float x = 0;
        
        for (UIImage *screenshot in screenshots) {
            UIImageView *screenshotView = [[UIImageView alloc] initWithImage:screenshot];
            screenshotView.frame = CGRectMake(x, 0, imageWidth, height);
            screenshotView.layer.cornerRadius = 16.0;
            screenshotView.clipsToBounds = YES;
            screenshotView.image = screenshot;
            [self.screenshotContentView addSubview:screenshotView];
            x += CGRectGetMaxX(screenshotView.bounds) + 1.0;
        }
    });
}

- (void)updateImages {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateScreenshotView];
    });
}

- (NSArray *)getScreenshots {
    NSArray *screenshotURLS = [self.softwareDetails valueForKey:ITUNES_SOFTWARE_SCREENSHOT_URLS];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < [screenshotURLS count]; i++) {
        UIImage *image = [self getImageForURL:screenshotURLS[i]
                               withIdentifier:[NSString stringWithFormat:@"%ld%d",
                                               [[self.softwareDetails valueForKey:ITUNES_SOFTWARE_TRACK_ID] longValue],i]];
        if (image) {
            [images addObject:image];
        }
    }
    return images;
}

- (UIImage *)getImageForSoftwareDetail: (NSDictionary *)softwareDetail {
    NSData *imageData = [self.itunesCaching getImageForStringURL:
                         [self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_THUMBNAIL_URL]
                         withIdentifier:[NSString stringWithFormat:@"%ld", [[self.softwareDetails valueForKeyPath:ITUNES_SOFTWARE_TRACK_ID] longValue]]];
    return imageData ?
    [UIImage imageWithData:imageData] :
    [UIImage imageNamed:DEFAULT_THUMBNAIL_PLACEHOLDER_IMAGE_NAME];
}

- (NSString *)textForStarRatings {
    
    // Get rounded rating
    float averageRating = [[self.softwareDetails valueForKey:ITUNES_SOFTWARE_AVERAGE_RATING] floatValue];
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
