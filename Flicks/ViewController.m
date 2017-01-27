//
//  ViewController.m
//  Flicks
//
//  Created by Yi Chen on 1/23/17.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
#import "MovieModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MovieDetailViewController.h"
#import <MBProgressHUD.h>

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (strong, nonatomic) NSArray<MovieModel *> *movies;
@property (strong, nonatomic) NSString *apiKey;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib./Users/yic/Downloads/movie.jpg
    
    self.movieTableView.backgroundColor = [UIColor yellowColor];
    
    self.movieTableView.dataSource = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor purpleColor];
    refreshControl.tintColor = [UIColor whiteColor];
    
    self.apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    if ([self.restorationIdentifier isEqualToString:@"now_playing"]) {
        [self fetchMovies:[@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:self.apiKey]];
        [refreshControl addTarget:self action:@selector(fetchMoviesNowPlaying) forControlEvents:UIControlEventValueChanged];

    } else if ([self.restorationIdentifier isEqualToString:@"top_rated"]){
        [self fetchMovies:[@"https://api.themoviedb.org/3/movie/top_rated?api_key=" stringByAppendingString:self.apiKey]];
        [refreshControl addTarget:self action:@selector(fetchMoviesTopRated) forControlEvents:UIControlEventValueChanged];

    }
    
    [self.movieTableView setRefreshControl:refreshControl];
}


- (void)fetchMoviesNowPlaying {
    [self fetchMovies:[@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:self.apiKey]];
}

- (void)fetchMoviesTopRated {
    [self fetchMovies:[@"https://api.themoviedb.org/3/movie/top_rated?api_key=" stringByAppendingString:self.apiKey]];
}


- (void)fetchMovies:(NSString *)urlString {
    //NSString *urlString =
    //[@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                [MBProgressHUD hideHUDForView:self.view animated:true];
                                                if (!error) {
                                                    NSLog(@"No network error. All good.");
                                                    
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    //NSLog(@"Response: %@", responseDictionary);
                                                    NSArray *results = responseDictionary[@"results"];
                                                    NSMutableArray *models = [NSMutableArray array];
                                                    
                                                    for (NSDictionary *result in results) {
                                                        MovieModel *model = [[MovieModel alloc] initWithDictionary:result];
                                                        NSLog(@"Model - %@", model.title);
                                                        [models addObject:model];
                                                    }
                                                    self.movies = models;
                                                    [self.movieTableView reloadData];
                                                    
                                                } else {
                                                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Network Error!"
                                                                                                                   message:@"Please check WIFI or LTE settings."
                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                          handler:^(UIAlertAction * action) {}];
                                                    [alert addAction:defaultAction];
                                                    [self presentViewController:alert animated:YES completion:nil];
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                                if (self.movieTableView.refreshControl) {
                                                    [self.movieTableView.refreshControl endRefreshing];
                                                }
                                            }];
    [task resume];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath:indexPath];
    MovieModel *model = self.movies[indexPath.row];
    
    cell.backgroundColor = [UIColor yellowColor];
    [cell.titleLabel setText:model.title];
    [cell.overviewLabel setText:model.movieDescription];
    [cell.posterImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@", model.posterURLString]]];
    
    NSLog(@"row number = %ld", indexPath.row);
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"movieDetailControllerSegue"]){
        NSIndexPath *indexPath = [self.movieTableView indexPathForCell:(UITableViewCell *)sender];
        MovieDetailViewController *movieDetailViewController = [segue destinationViewController];
        movieDetailViewController.movieModel = self.movies[indexPath.row];
    }
}


@end
