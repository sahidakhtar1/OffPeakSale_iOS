

@protocol ImageDownloaderDelegate <NSObject>

- (void) imageDownloadComplete:(UIImage*)prodImage
					  forIndex:(NSIndexPath*)indexPath;
@optional
- (void) imageDownloadFailedForIndex:(NSIndexPath*)indexPath;

@end

@interface ImageDownloader : NSObject {
    id <ImageDownloaderDelegate> delegate;
	UIImage *prodImage;
    NSIndexPath *indexPathCurrentRow;
    NSMutableData *imageData;
    NSURLConnection *urlConn;
	CGSize imageSize;
	NSString *imgurl;
    BOOL needtosendFailureNotification;
}

@property (nonatomic, retain) NSString *imgurl;
@property (nonatomic) id <ImageDownloaderDelegate> delegate;
@property (nonatomic, retain) UIImage *prodImage;
@property (nonatomic, retain) NSIndexPath *indexPathCurrentRow;
@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, retain) NSURLConnection *urlConn;

- (void)startImageDownload:(NSString*)imageUrl;
- (void)cancelImageDownload;
- (void)startImageDownload:(NSString*)imageUrl registerForFailureResponse:(BOOL) flag;

@end



