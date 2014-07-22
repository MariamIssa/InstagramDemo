//
//  ViewController.m
//  instagramAssignment
//
//  Created by Mariam Issa on 7/21/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "InstagramKit.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController ()
@property(strong,nonatomic)NSMutableArray *photos;//laoded photos
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    //adding gesture recognizer to the enlarged image to make the tap return hit everywhere on the image
    UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [tapGest setNumberOfTapsRequired:1];
    [tapGest setNumberOfTouchesRequired:1];
    [self.image addGestureRecognizer:tapGest];
    self.image.multipleTouchEnabled=YES;
    self.image.userInteractionEnabled=YES;
    
    //initialization
    self.photos=[[NSMutableArray alloc]init];
    
    //fill the array with the images
    [self loadImagesWithTag:@"selfie"];
    
    }

//loading the images
- (void)loadImagesWithTag:(NSString*)Tag
{
    [[InstagramEngine sharedEngine] getMediaWithTagName:Tag withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        
        [self.photos addObjectsFromArray:media];
        [self.collectionView    reloadData];
    }  failure:^(NSError *error) {
        NSLog(@"Request Self Feed Failed");
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imageView=(UIImageView*)[cell viewWithTag:100];
    
    InstagramMedia *media = self.photos[indexPath.row];
    [imageView setImageWithURL:media.thumbnailURL];
    UILabel *title=(UILabel*)[cell viewWithTag:200];
    title.text=media.user.fullName;
    [title sizeToFit];
    
    
    return cell;
}

//enlarge the image on click
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *img=(UIImageView*)[cell viewWithTag:100];
   
    [self.view sendSubviewToBack:self.collectionView];
    self.image.hidden=NO;
    self.image.image = img.image;
    
    //show the large image with animation
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 1.0];
    animation.duration = 0.5f;
    [self.image.layer addAnimation:animation forKey:@"SpinAnimation"];
   
}

//arranging the images Big, Small, Small
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize cellSize;
    
    if (indexPath.row %3==0) {
         cellSize=CGSizeMake(180, 180);
    }
    else
        cellSize=CGSizeMake(100, 100);
    
    return cellSize;
}

//dismiss the large image
- (IBAction)tap:(UITapGestureRecognizer *)recognizer {
        [self.view sendSubviewToBack:self.image];
        self.image.hidden=YES;
}

@end
