//
//  SHKInstagramResizeViewController.m
//  CatPaint
//
//  Created by Cory Alder on 11-07-22.
//  Copyright 2011 Davander Mobile. All rights reserved.
//

#import "AAZoomViewController.h"


@interface AAZoomViewController () {
    CGFloat rotation;
}
@end


@implementation AAZoomViewController

-(id)initWithImage:(UIImage *)imageObject andDelegate:(id<AAZoomDelegate>)delegate {
    if (!(self = [super initWithNibName:@"AAZoomViewController" bundle:nil])) return nil;
    
    self.delegate = delegate;
    
    UIImage *exportImage = [UIImage imageWithCGImage:imageObject.CGImage scale:imageObject.scale orientation:UIImageOrientationUp];
    
    self.inputImage = exportImage;
    
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSAssert(FALSE, @"Don't call initWithNibName, use initWithImage instead");
    return nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.colorPicker.delegate = self; 
    self.colorPicker.colors = [self.delegate backgroundColors];
    
    
    self.navigationController.navigationBarHidden = YES;
    
    if (self.skipCropping) {
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
    }
    
    self.imageView.image = self.inputImage;
        
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 4;
    self.scrollView.contentSize = self.imageView.frame.size;

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.skipCropping) [self doneButtonAction];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

 
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


-(IBAction)doneButtonAction {
    // draw the image into a new image.
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (void)scrollViewDidZoom:(UIScrollView *)aScrollView {
    // fixed centering when smaller than orig.
    CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width)?
    (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.scrollView.bounds.size.height > self.scrollView.contentSize.height)?
    (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,
                                   self.scrollView.contentSize.height * 0.5 + offsetY);
}

-(IBAction)cancelButtonAction {
//    NSAssert([self.delegate conformsToProtocol:@protocol(DMResizerDelegate)], @"Bad delegate %@", self.delegate);
    [self.delegate resizer:self finishedResizingWithResult:nil]; // nil image == cancel button.
}

-(void)rotateButtonAction {
    //NSLog(@"Rotate image 90 degrees.");
    rotation += M_PI/2;
    self.scrollView.transform = CGAffineTransformRotate(self.scrollView.transform, M_PI/2);
}

-(IBAction)changeColor:(UIButton *)sender {
    if (!sender || ![sender respondsToSelector:@selector(backgroundColor)]) return;
    
    self.imageView.backgroundColor = sender.backgroundColor;
    
}


@end
