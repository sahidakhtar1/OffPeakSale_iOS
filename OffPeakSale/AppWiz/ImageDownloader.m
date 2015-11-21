
#import "ImageDownloader.h"



@implementation ImageDownloader

@synthesize imgurl;
@synthesize prodImage;
@synthesize indexPathCurrentRow;
@synthesize delegate;
@synthesize imageData;
@synthesize urlConn;

//dealloc: to deallocate the memory

//startImageDownload : Method initiates the image download using the NSURLConnection class object
//Parameters: (NSString*)imageUrl - url for the image
- (void)startImageDownload:(NSString*)imageUrl {	
	UIImage * savedImage = nil;
//	if (IMAGE_CACHE_ENABLE) {
//		savedImage = [[ImageStore  sharedImageStore] getImageForKey:imageUrl];
//	}
	if (savedImage != nil) {
		self.prodImage = savedImage;
		[delegate imageDownloadComplete:self.prodImage forIndex:self.indexPathCurrentRow];
		return;
	} else {
		self.imageData = [NSMutableData data];
        self.imgurl = [imageUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //self.imgurl = [imageUrl stringByReplacingOccurrencesOfString:@"?$thb$" withString:kemptyString];
#ifdef DEBUG
		NSLog(@"Image Url:%@", self.imgurl);
#endif
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:
                                                                          [NSURL URLWithString:self.imgurl]] delegate:self];
		self.urlConn = conn;
	}    
}

- (void)startImageDownload:(NSString*)imageUrl registerForFailureResponse:(BOOL) flag {	
    needtosendFailureNotification = flag;
    [self startImageDownload:imageUrl];
}


//cancelImageDownload : Method to cancel and cleanup in progress download
- (void)cancelImageDownload {
    [self.urlConn cancel];
    if(self.urlConn!=nil) self.urlConn = nil;
    if(self.imageData!=nil) self.imageData = nil;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse* resp = (NSHTTPURLResponse*)response;
    if([resp statusCode] == 200) {
        if(![[response MIMEType] hasPrefix:@"image"]) {
#ifdef DEBUG
            NSLog(@"Response Status: %d, MIMEType: %@", [resp statusCode], [resp MIMEType]);
#endif
            if(self.imageData!=nil) self.imageData = nil;
            if(self.urlConn!=nil) self.urlConn = nil;
            if(needtosendFailureNotification){
                if(delegate != nil && [delegate respondsToSelector:@selector(imageDownloadFailedForIndex:)]){
                    [delegate imageDownloadFailedForIndex:self.indexPathCurrentRow];	
                }
            }
            else{
                [delegate imageDownloadComplete:[UIImage imageNamed:@"noImagesmall.png"] forIndex:self.indexPathCurrentRow];
            }
        }
    }
}

//NSURLConnection delegate to collect the data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.imageData appendData:data];
}

//NSURLConnection delegate to handle if ther is a error in establishing the connection
//here we willcleaning up the objects and not throwing any error.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(self.imageData!=nil) self.imageData = nil;
    if(self.urlConn!=nil) self.urlConn = nil;
	if(needtosendFailureNotification){
        if(delegate != nil && [delegate respondsToSelector:@selector(imageDownloadFailedForIndex:)]){
            [delegate imageDownloadFailedForIndex:self.indexPathCurrentRow];	
        }
    }
    else{
        [delegate imageDownloadComplete:[UIImage imageNamed:@"noImagesmall.png"] forIndex:self.indexPathCurrentRow];
    }
}

//NSURLConnection delegate to use collected data and create a UIImage object and then
//notify caller class about the downloaded image
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//Handle special case when the server gives error while fetching the data
//	NSString* aStr;
//	aStr = [[NSString alloc] initWithData:self.imageData encoding:NSASCIIStringEncoding];
//	NSRange range = [aStr rangeOfString:@"<HTML>"];
//	if(range.location != NSNotFound)
//	{
//		self.prodImage = [UIImage imageNamed:@"noImagesmall.png"];
//		if(self.imageData!=nil) self.imageData = nil;
//		if(self.urlConn!=nil) self.urlConn = nil;
//		[delegate imageDownloadComplete:[UIImage imageNamed:@"noImagesmall.png"] forIndex:self.indexPathCurrentRow];
//		
//		if (IMAGE_CACHE_ENABLE) {//Adding default image to Image Store
//			[[ImageStore  sharedImageStore] addToImageStore:[UIImage imageNamed:@"noImagesmall.png"] forKey:self.imgurl];
//		}		
//		[aStr release];
//		return;
//	}	
//	[aStr release];
	
	
	UIImage *image = [[UIImage alloc] initWithData:self.imageData];
	self.prodImage = image;
    
    if(self.imageData!=nil) self.imageData = nil;
	
    
    if(self.urlConn!=nil) self.urlConn = nil;
    if(delegate != nil && [delegate respondsToSelector:@selector(imageDownloadComplete:forIndex:)]){
        [delegate imageDownloadComplete:self.prodImage forIndex:self.indexPathCurrentRow];	
    }
	
}

@end


