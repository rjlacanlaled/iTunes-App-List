//
//  CompanySoftwareTVC.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import "CompanySoftwareTVC.h"
#import "FavoriteSoftwareTVC.h"
#import "ArraySorter.h"
#import "ITunesFetcher.h"
#import "SoftwareDetails+CRUD.h"

@interface CompanySoftwareTVC ()

@end

@implementation CompanySoftwareTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self updateCompanies];
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
    favoriteSoftwareTVC.title = self.companies[indexPath.row];
    favoriteSoftwareTVC.dataMode = Selected;
    favoriteSoftwareTVC.softwares = [ArraySorter sortArray:self.companySoftwares[self.companies[indexPath.row]]
                                                forKeyPath:ITUNES_SOFTWARE_TRACK_NAME
                                               isAscending:YES];
}

#pragma mark - Properties

- (void)setCompanies:(NSArray *)companies {
    _companies = companies;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.companies count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyDetails" forIndexPath:indexPath];
    
    // Configure the cell...

    cell.textLabel.text = self.companies[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:
                                  @"%ld app(s)", [self.companySoftwares[self.companies[indexPath.row]] count]];
    return cell;
}


#pragma mark - Helper Methods

#define COMPANY_NAME_KEY @"company.name"
- (void)updateCompanies {
    self.companySoftwares = [SoftwareDetails fetchAllCompanyWithSoftware];
    self.companies = [ArraySorter sortArray:[self.companySoftwares allKeys]
                              forKeyPath:nil
                             isAscending:YES];
}


@end
