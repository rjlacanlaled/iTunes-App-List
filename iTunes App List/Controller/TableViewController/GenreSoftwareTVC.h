//
//  GenreSoftwareTVC.h
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import <UIKit/UIKit.h>
#import "FavoriteSoftwareTVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface GenreSoftwareTVC : UITableViewController
@property (strong, nonatomic) NSArray *genres;
@property (strong, nonatomic) NSDictionary *genreSoftwares;
@property (nonatomic) DataMode dataMode;
@end

NS_ASSUME_NONNULL_END
