//
//  AASplashScreenViewController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 22/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AASplashScreenViewController.h"

@interface AASplashScreenViewController ()

@end
#import "ImageDownloader.h"
@implementation AASplashScreenViewController
@synthesize imageDownloadsInProgress;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad splash screen");
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    [self.view setBackgroundColor:[UIColor blackColor]];
   if(self.splashScreenImageURL)
    {
        [self adjustLabels];
        NSString *compLogoName = [self.splashScreenImageURL lastPathComponent];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        path = [NSString stringWithFormat:@"%@/%@",path,compLogoName];
        NSFileManager* filemanager = [NSFileManager defaultManager];
        UIImage *logoImage;
        if ([filemanager fileExistsAtPath:path]) {
            logoImage = [UIImage imageWithContentsOfFile:path];
            [self.lblRetailerPoweredBy setHidden:NO];
            [self.lblPoweredBy setHidden:NO];
            [self setUpTimer];
        }else{
            [self startImageDownload:self.splashScreenImageURL forIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            
        }
        self.imgViewSplashScreenImage.image = logoImage;
//       [self.imgViewSplashScreenImage setImageWithURL:[NSURL URLWithString:self.splashScreenImageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//           [self.lblRetailerPoweredBy setHidden:NO];
//           [self.lblPoweredBy setHidden:NO];
//           [self setUpTimer];
//       }];
   // }
    }
    else
    {
    [self setUpTimer];
    }
	// Do any additional setup after loading the view.
}
//initiate download of image for a row
- (void)startImageDownload:(NSString *)imageUrl forIndexPath:(NSIndexPath *)indexPath {
    ImageDownloader *imageLoader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageLoader == nil) {
        imageLoader = [[ImageDownloader alloc] init];
        imageLoader.indexPathCurrentRow = indexPath;
        imageLoader.delegate = self;
        [imageDownloadsInProgress setObject:imageLoader forKey:indexPath];
		[imageLoader startImageDownload:imageUrl];
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)imageDownloadComplete:(UIImage*)prodImage forIndex:(NSIndexPath*)indexPath{
    NSLog(@"imageDownloadComplete");
	ImageDownloader *imageLoader = [imageDownloadsInProgress objectForKey:indexPath];
	
	if (imageLoader != nil) {
        if(indexPath.row == 1){
			
            NSString *compLogoName = [self.splashScreenImageURL lastPathComponent];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            path = [NSString stringWithFormat:@"%@/%@",path,compLogoName];
            NSFileManager* filemanager = [NSFileManager defaultManager];
            if ([filemanager fileExistsAtPath:path]) {
                
            }else{
                NSData *imageData = UIImagePNGRepresentation(prodImage);
                [filemanager createFileAtPath:path contents:imageData attributes:nil];
            }
            self.imgViewSplashScreenImage.image = prodImage;
            [self.lblRetailerPoweredBy setHidden:NO];
            [self.lblPoweredBy setHidden:NO];
            [self setUpTimer];
        }
    }
    [imageDownloadsInProgress removeObjectForKey:indexPath];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpTimer
{
    NSLog(@"setUpTimer splash screen");
    [NSTimer scheduledTimerWithTimeInterval:self.splashScreenInterval
                                     target:self
                                   selector:@selector(closeSplashScreen:)
                                   userInfo:nil
                                    repeats:NO];}

-(void)closeSplashScreen:(NSTimer*)timer
{
    NSLog(@"closeSplashScreen splash screen");
    NSArray *allKeys = [self.imageDownloadsInProgress allKeys];
    for (int i= 0; i< [allKeys count]; i++) {
        ImageDownloader *imgDownloader = [self.imageDownloadsInProgress objectForKey:[allKeys objectAtIndex:i]];
        [imgDownloader cancelImageDownload];
    }
    if(self
       .splashScreenDelegate)
    {
       [self.splashScreenDelegate onSplashScreenDisplayCompleted];
    }
}
-(void)adjustLabels
{
    CGFloat labelWidth = self.lblPoweredBy.frame.size.width;
    
    CGSize lblRetailerPoweredBySize = [AAUtils getTextSizeWithFont:self.lblRetailerPoweredBy.font andText:[AAAppGlobals sharedInstance].retailer.retailerPoweredBy andMaxWidth:self.view.frame.size.width];
    CGFloat totalWidth = labelWidth + lblRetailerPoweredBySize.width;
    
    CGFloat originX = ceilf((self.view.frame.size.width - totalWidth)/2);
    
    CGRect framePoweredBy = self.lblPoweredBy.frame;
    framePoweredBy.origin.x = originX;
    self.lblPoweredBy.frame = framePoweredBy;
    CGRect frameRetailerPoweredBy = self.lblRetailerPoweredBy.frame;
    frameRetailerPoweredBy.size.width = lblRetailerPoweredBySize.width;
    frameRetailerPoweredBy.origin.x = framePoweredBy.origin.x + framePoweredBy.size.width;
    self.lblRetailerPoweredBy.frame = frameRetailerPoweredBy;
    [self.lblRetailerPoweredBy setText:[AAAppGlobals sharedInstance].retailer.retailerPoweredBy];
}
@end
