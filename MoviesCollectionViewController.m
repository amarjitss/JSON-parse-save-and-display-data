//
//  MoviesCollectionViewController.m
//  MoviesApp
//
//  Created by amarjit singh on 4/25/16.
//  Copyright © 2016 amarjit singh. All rights reserved.
//

#import "MoviesCollectionViewController.h"
#import "MoviesCollectionViewCell.h"
#import "MBProgressHUD.h"

@interface MoviesCollectionViewController ()
{
    NSArray *moviesArray;
}

@end

@implementation MoviesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchMoviesData:@10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return moviesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MoviesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *movieDict = [moviesArray objectAtIndex:indexPath.row];

    //getting the movie name
    NSDictionary *imName = [movieDict objectForKey:@"im:name"];
    cell.movieNameLabel.text = imName[@"label"];
    
    //getting the movie picture
    NSArray *imImage = [movieDict objectForKey:@"im:image"];
    NSDictionary *moviePic =  [imImage lastObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [moviePic objectForKey:@"label"]]];
        
        UIImage *theImage = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.moviesPosterImageView.image = theImage;
        });
        
    });
    
    return cell;
}


- (IBAction)segmentButt:(id)sender
{
    UISegmentedControl *controller = (UISegmentedControl *)sender;

    if (controller.selectedSegmentIndex == 0)
    {
        [self fetchMoviesData:@10];
    } else if(controller.selectedSegmentIndex == 1)
    {
        [self fetchMoviesData:@20];
    } else if(controller.selectedSegmentIndex == 2)
    {
        [self fetchMoviesData:@50];
    }
    else if(controller.selectedSegmentIndex == 3)
    {
        [self fetchMoviesData:@100];
    }
    
}

-(NSArray *)fetchMoviesData: (NSNumber *)numb
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *moviesURLString = [NSString stringWithFormat:@"https://itunes.apple.com/us/rss/topmovies/limit=%@/json", numb];
    NSURL *moviesURL = [NSURL URLWithString:moviesURLString];
    
    NSData *data = [NSData dataWithContentsOfURL:moviesURL];
    
    NSError *error;
    
    NSDictionary *dict2 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *feed = [dict2 valueForKey:@"feed"];
    
    moviesArray = [feed valueForKey:@"entry"];
    
    dispatch_async(dispatch_get_main_queue(),^ {
        
        [self.collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    });
    
    return moviesArray;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
@end
