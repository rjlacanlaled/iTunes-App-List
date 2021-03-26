//
//  FavoriteSoftwareTVC.h
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import <UIKit/UIKit.h>
#import "SoftwareTVC.h"

NS_ASSUME_NONNULL_BEGIN

// These enums makes the segmented control for sorting more readable
typedef NS_ENUM(NSInteger, SortType) {
    SoftwareName = 0,
    CompanyName,
    Rating,
    Genre
};

typedef NS_ENUM(NSInteger, SortOrder) {
    Ascending = 0,
    Descending
};

// Main content of this TVC
@interface FavoriteSoftwareTVC : SoftwareTVC

@end

NS_ASSUME_NONNULL_END
