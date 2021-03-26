//
//  GenreSoftwareTVC.m
//  iTunes App List
//
//  Created by RJ Lacanlale on 2/4/21.
//

#import "GenreSoftwareTVC.h"
#import "ArraySorter.h"
#import "ITunesFetcher.h"
#import "SoftwareDetails+CRUD.h"

@interface GenreSoftwareTVC ()

@end

@implementation GenreSoftwareTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.dataMode != Selected) {
        [self updateGenres];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"ShowFavoriteApps"]) {
        if ([segue.destinationViewController isKindOfClass:[FavoriteSoftwareTVC class]]) {
            [self prepareFavoriteSoftwareTVC: segue.destinationViewController forIndexPath: indexPath];
        }
    }
}

#pragma mark - Properties

- (void)setGenres:(NSArray *)genres {
    _genres = genres;
    [self.tableView reloadData];
}

- (void)setGenreSoftwares:(NSDictionary *)genreSoftwares {
    _genreSoftwares = genreSoftwares;
    self.genres = [ArraySorter sortArray:[self.genreSoftwares allKeys]
                              forKeyPath:nil
                             isAscending:YES];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.genres count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenreDetails" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.genres[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:
                                  @"%ld app(s)", [self.genreSoftwares[self.genres[indexPath.row]] count]];
    return cell;
}

#pragma mark - Helper Methods

#define GENRE_NAME_KEY @"genre.name"
- (void)updateGenres {
    self.genreSoftwares = [SoftwareDetails fetchAllGenreWithSoftware];
}

- (void)prepareFavoriteSoftwareTVC: (FavoriteSoftwareTVC *) favoriteSoftwareTVC forIndexPath: (NSIndexPath *) indexPath {
    favoriteSoftwareTVC.title = self.genres[indexPath.row];
    favoriteSoftwareTVC.dataMode = Selected;
    favoriteSoftwareTVC.softwares = [ArraySorter sortArray:self.genreSoftwares[self.genres[indexPath.row]]
                                                forKeyPath:ITUNES_SOFTWARE_TRACK_NAME
                                               isAscending:YES];
}

@end
