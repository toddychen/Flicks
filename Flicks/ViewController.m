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
#import "MoviePosterCollectionViewCell.h"

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *movieCollectionView;
@property (strong, nonatomic) NSArray<MovieModel *> *movies;
@property (strong, nonatomic) NSString *apiKey;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation ViewController
- (IBAction)onValueChanged:(UISegmentedControl *)sender {
    switch(sender.selectedSegmentIndex) {
        case 0:
            NSLog(@"list");
            _movieCollectionView.hidden = true;
            _movieTableView.hidden = false;
            break;
        case 1:
            NSLog(@"grid");
            _movieTableView.hidden = true;
            _movieCollectionView.hidden = false;
            break;
        default:
            break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib./Users/yic/Downloads/movie.jpg
    
    [self onValueChanged:_segmentedControl];
    
    [self.view setBackgroundColor:[UIColor yellowColor]];
    
    
    // UITableView
    self.movieTableView.backgroundColor = [UIColor orangeColor];
    self.movieTableView.dataSource = self;
    
    
    // UICollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat itemHeight = 150;
    CGFloat itemWidth = screenWidth / 4;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    [collectionView registerClass:[MoviePosterCollectionViewCell class] forCellWithReuseIdentifier:@"MoviePosterCollectionViewCell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:collectionView];
    self.movieCollectionView = collectionView;
    
    
    // UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor orangeColor];
    refreshControl.tintColor = [UIColor whiteColor];
    UIRefreshControl *refreshControl2 = [[UIRefreshControl alloc] init];
    refreshControl2.backgroundColor = [UIColor orangeColor];
    refreshControl2.tintColor = [UIColor whiteColor];
    
    self.apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSLog(@"restorationIdentifier: %@", self.restorationIdentifier);
    if ([self.restorationIdentifier isEqualToString:@"now_playing"]) {
        [self fetchMovies:[@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:self.apiKey]];
        [refreshControl addTarget:self action:@selector(fetchMoviesNowPlaying) forControlEvents:UIControlEventValueChanged];
        [refreshControl2 addTarget:self action:@selector(fetchMoviesNowPlaying) forControlEvents:UIControlEventValueChanged];

    } else if ([self.restorationIdentifier isEqualToString:@"top_rated"]){
        [self fetchMovies:[@"https://api.themoviedb.org/3/movie/top_rated?api_key=" stringByAppendingString:self.apiKey]];
        [refreshControl addTarget:self action:@selector(fetchMoviesTopRated) forControlEvents:UIControlEventValueChanged];
        [refreshControl2 addTarget:self action:@selector(fetchMoviesTopRated) forControlEvents:UIControlEventValueChanged];
    }
    
    [self.movieTableView setRefreshControl:refreshControl];
    [self.movieCollectionView setRefreshControl:refreshControl2];
    
    
    //[self.movieTableView insertSubview:refreshControl atIndex:0];
    //[self.movieCollectionView insertSubview:refreshControl2 atIndex:0];
    
    // Hide view for default
    self.movieCollectionView.hidden = YES;
    //self.movieTableView.hidden = YES;
    
    
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
                                                    [self.movieCollectionView reloadData];
                                                    
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
                                                if (self.movieTableView.refreshControl.isRefreshing) {
                                                    [self.movieTableView.refreshControl endRefreshing];
                                                }
                                                if (self.movieCollectionView.refreshControl.isRefreshing) {
                                                    [self.movieCollectionView.refreshControl endRefreshing];
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
    
    cell.backgroundColor = [UIColor orangeColor];
    [cell.titleLabel setText:model.title];
    [cell.overviewLabel setText:model.movieDescription];
    [cell.posterImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@", model.posterURLString]]];
    
    NSLog(@"row number = %ld", indexPath.row);
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"movieDetailControllerSegue"]){
        NSLog(@"Here in serge1!");
        NSIndexPath *indexPath = [self.movieTableView indexPathForCell:(UITableViewCell *)sender];
        MovieDetailViewController *movieDetailViewController = [segue destinationViewController];
        movieDetailViewController.movieModel = self.movies[indexPath.row];
    } else if ([segue.identifier isEqualToString:@"movieDetailControllerSegue2"]) {
        NSLog(@"Here in serge2!");
        NSIndexPath *indexPath = [self.movieCollectionView indexPathForCell:(MoviePosterCollectionViewCell *)sender];
        MovieDetailViewController *movieDetailViewController = [segue destinationViewController];
        movieDetailViewController.movieModel = self.movies[indexPath.item];
        NSLog(@"%@", movieDetailViewController.movieModel.title);
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.movies.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoviePosterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoviePosterCollectionViewCell" forIndexPath:indexPath];
    MovieModel *model = [self.movies objectAtIndex:indexPath.item];
    
    NSLog(@"item number = %ld", indexPath.item);
    
    cell.model = model;
    [cell reloadData];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"movieDetailControllerSegue2" sender:[self.movieCollectionView cellForItemAtIndexPath:indexPath]];
}


@end
