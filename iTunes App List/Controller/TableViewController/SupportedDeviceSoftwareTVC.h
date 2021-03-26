//
//  SupportedDeviceSoftwareTVC.h
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SupportedDeviceSoftwareTVC : UITableViewController
@property (strong, nonatomic) NSArray *supportedDevices;
@property (strong, nonatomic) NSDictionary *supportedDeviceSoftwares;
@end

NS_ASSUME_NONNULL_END
