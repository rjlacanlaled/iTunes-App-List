//
//  SoftwareTVC.h
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/1/21.
//

#import <UIKit/UIKit.h>

@interface SoftwareTVC : UITableViewController

// Helper enum to check which data to fetch
typedef NS_ENUM(NSInteger, DataMode) {
  All,
  Selected
};

@property (strong, nonatomic) NSArray *softwares;
@property (nonatomic) DataMode dataMode;

// Adds/removes a software from the database
- (void)addOrRemoveToFavorites: (id)sender;

// Reloads tableview on the main queue
- (void)reloadTableDataOnMainQueue;
@end

