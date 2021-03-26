//
//  SupportedDeviceSoftwareTVC.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import "SupportedDeviceSoftwareTVC.h"
#import "FavoriteSoftwareTVC.h"
#import "ArraySorter.h"
#import "ITunesFetcher.h"
#import "SoftwareDetails+CRUD.h"

@interface SupportedDeviceSoftwareTVC ()

@end

@implementation SupportedDeviceSoftwareTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self updateSupportedDevices];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"ShowFavoriteApps"]) {
        if ([segue.destinationViewController isKindOfClass:[FavoriteSoftwareTVC class]]) {
            [self prepareFavoriteSoftwareTVC: segue.destinationViewController forIndexPath: indexPath];
        }
    }
}

#pragma mark - Segue Helper Methods
- (void)prepareFavoriteSoftwareTVC: (FavoriteSoftwareTVC *) favoriteSoftwareTVC forIndexPath: (NSIndexPath *) indexPath {
    favoriteSoftwareTVC.title = self.supportedDevices[indexPath.row];
    favoriteSoftwareTVC.dataMode = Selected;
    favoriteSoftwareTVC.softwares = [ArraySorter sortArray:self.supportedDeviceSoftwares[self.supportedDevices[indexPath.row]]
                                                forKeyPath:ITUNES_SOFTWARE_TRACK_NAME
                                               isAscending:YES];
}

#pragma mark - Properties
- (void)setSupportedDevices:(NSArray *)supportedDevices {
    _supportedDevices = supportedDevices;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.supportedDevices count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupportedDeviceDetails" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *deviceName = self.supportedDevices[indexPath.row];
    
    cell.textLabel.text = [[deviceName componentsSeparatedByString:@"-"] firstObject];
    cell.detailTextLabel.text = [NSString stringWithFormat:
                                  @"%ld app(s)", [self.supportedDeviceSoftwares[deviceName] count]];
    return cell;
}


#pragma mark - Helper Methods

#define SUPPORTED_DEVICE_NAME_KEY @"supportedDevice.name"
- (void)updateSupportedDevices {
    self.supportedDeviceSoftwares = [SoftwareDetails fetchAllSupportedDeviceWithSoftware];
    self.supportedDevices = [ArraySorter sortArray:[self.supportedDeviceSoftwares allKeys]
                              forKeyPath:nil
                             isAscending:YES];
}

@end
