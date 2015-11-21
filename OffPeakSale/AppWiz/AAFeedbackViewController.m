//
//  AAFeedbackViewController.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAFeedbackViewController.h"
#import "NSData+Base64.h"
#import "ImageDownloader.h"
#import "AAHeaderView.h"
#import "UIViewController+AAShakeGestuew.h"
#import "AAAppDelegate.h"
@interface AAFeedbackViewController ()

@end

@implementation AAFeedbackViewController
NSString* const RADIO_BUTTON_GROUP = @"FeedbackGroup";
static NSString* const JSON_RETAILER_ID_KEY = @"retailerId";
@synthesize pickedImage,imageDownloadsInProgress,title;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.heading = self.title;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    isImagePickerShown = FALSE;
    self.isKeyboardShown = NO;
    [self.navigationController setNavigationBarHidden:YES];
	// Do any additional setup after loading the view.
    self.tvFeedbackText.validationDelegate  =self;
    self.tvFeedbackText.fieldName = @"Feedback text";
    self.tvFeedbackText.placeHolderText = @"Your feedback is valuable to us";
    self.tfImageSelectionBG.placeholder = @"Insert Photo (Optional)";
    [self.tfMobileNumber setAllowOnlyNumbers:YES];
    
     NSLog(@"Logo size = %@",NSStringFromCGRect(self.ivFeedbackGift.frame));

    self.selectedRadioButtonString = @"";
    [self setUpReferAFriendsFields];
    [self setUpRadioButtons];
    self.tgrBackgroundView.delegate = self;
//    [AAAppGlobals sharedInstance].feedback.feedbackOption1 = @"Like";
//    [AAAppGlobals sharedInstance].feedback.feedbackOption2 = @"Dislike";
//    [AAAppGlobals sharedInstance].feedback.feedbackOption3 =  @"Reservation";
//    self.lblFeedbackOption1.text = [AAAppGlobals sharedInstance].feedback.feedbackOption1;
//    self.lblFeedbackOption2.text = [AAAppGlobals sharedInstance].feedback.feedbackOption2;
//    self.lblFeedbackOption3.text = [AAAppGlobals sharedInstance].feedback.feedbackOption3;
    self.selectedRadioButtonString =
    [AAAppGlobals sharedInstance].feedback.feedbackOption1;
    
    [self registerForKeyboardNotifications];
    
    AAHeaderView *headerView = [[AAHeaderView alloc] initWithFrame:self.vwHeaderView.frame];
    [self.vwHeaderView addSubview:headerView];
    [headerView setTitle:self.title];
    headerView.showCart = false;
    headerView.showBack = false;
    headerView.delegate = self;
    [headerView setMenuIcons];
    
}


-(void)viewWillAppear:(BOOL)animated
{
//    if (isImagePickerShown) {
//        isImagePickerShown = FALSE;
//        return;
//    }
    [super viewWillAppear:animated];
    [self cat_viewDidAppear:YES];
    self.tfFriendEmail.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.tfFriendName.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.tfMobileNumber.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.lblFeedbackTitle.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:FEEDBACK_REFER_FONTSIZE];
    
    self.tvFeedbackText.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FEEDBACK_TEXTVIEW_FONTSIZE];
    self.tfImageSelectionBG.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PROFILE_TF_FONTSIZE];
    self.lblFeedbackOption1.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FEEDBACK_OPTIONS_FONTSIZE];
    self.lblFeedbackOption2.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FEEDBACK_OPTIONS_FONTSIZE];
    self.lblFeedbackOption3.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:FEEDBACK_OPTIONS_FONTSIZE];
    
    self.btnReferFriend.titleLabel.font =  [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    self.btnSubmitFeedback.titleLabel.font =  [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:BUTTON_FONTSIZE];
    isImagePickerShown = FALSE;
    self.viewScrollViewContent.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    self.scrollViewFeedbackForm.contentSize = CGSizeMake(self.scrollViewFeedbackForm.frame.size.width, self.viewScrollViewContent.frame.size.height);
    id<AAChildNavigationControllerDelegate> nvcEShop = (id<AAChildNavigationControllerDelegate>)   self.navigationController;
    
//    [nvcEShop hideBackButtonView];
    if([[AAAppGlobals sharedInstance].feedback.feedBackGiftUrlString length] >0)
    {
        [self downloadFeedBackGiftImage];
//        [self.ivFeedbackGift setImageWithURL:[NSURL URLWithString:[AAAppGlobals sharedInstance].feedback.feedBackGiftUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            
//        }];
        self.lblFeedbackOption1.text = [AAAppGlobals sharedInstance].feedback.feedbackOption1;
        self.lblFeedbackOption2.text = [AAAppGlobals sharedInstance].feedback.feedbackOption2;
        self.lblFeedbackOption3.text = [AAAppGlobals sharedInstance].feedback.feedbackOption3;
//        [self.btnRdOption1 setTitle: [AAAppGlobals sharedInstance].feedback.feedbackOption1 forState:UIControlStateNormal] ;
//        [self.rbDislike setTitle: [AAAppGlobals sharedInstance].feedback.feedbackOption1 forState:UIControlStateNormal] ;
//        self.rbReservation.selectedValue = [AAAppGlobals sharedInstance].feedback.feedbackOption3;
        self.selectedRadioButtonString =
        [AAAppGlobals sharedInstance].feedback.feedbackOption1;
    }
    [AAFeedbackHelper getFeedbackGiftFromServerWithCompletionBlock:^{
        [self downloadFeedBackGiftImage];
//        [self.ivFeedbackGift setImageWithURL:[NSURL URLWithString:[AAAppGlobals sharedInstance].feedback.feedBackGiftUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            
//        }];
        self.lblFeedbackOption1.text = [AAAppGlobals sharedInstance].feedback.feedbackOption1;
        self.lblFeedbackOption2.text = [AAAppGlobals sharedInstance].feedback.feedbackOption2;
        self.lblFeedbackOption3.text = [AAAppGlobals sharedInstance].feedback.feedbackOption3;
//        self.rbLike.selectedValue = [AAAppGlobals sharedInstance].feedback.feedbackOption1;
//        self.rbDislike.selectedValue = [AAAppGlobals sharedInstance].feedback.feedbackOption2;
//        self.rbReservation.selectedValue = [AAAppGlobals sharedInstance].feedback.feedbackOption3;
        self.selectedRadioButtonString =
        [AAAppGlobals sharedInstance].feedback.feedbackOption1;
    } andFailure:^{
        
    }];
    CGRect frame = self.vwImageBG.frame;
    frame.origin.y = self.tvFeedbackText.frame.origin.y + self.tvFeedbackText.frame.size.height;
    self.vwImageBG.frame = frame;
    [self centralizeReferCustomerTitle];
    
    CGRect screenSize = self.view.frame;
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        CGRect rect = self.vwReferView.frame;
        rect.size.height = 192;
        self.vwReferView.frame = rect;
        
        CGRect feedbackFrame = self.vwFeedback.frame;
        feedbackFrame.size.height = screenSize.size.height - 192;
        self.vwFeedback.frame = feedbackFrame;
    }

   // [self showProfileUpdatePopupView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSArray *allKeys = [self.imageDownloadsInProgress allKeys];
    for (int i= 0; i< [allKeys count]; i++) {
        ImageDownloader *imgDownloader = [self.imageDownloadsInProgress objectForKey:[allKeys objectAtIndex:i]];
        [imgDownloader cancelImageDownload];
    }
}
-(void)downloadFeedBackGiftImage{
    NSString *compLogoName = [[AAAppGlobals sharedInstance].feedback.feedBackGiftUrlString lastPathComponent];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/%@",path,compLogoName];
    NSFileManager* filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:path]) {
        self.ivFeedbackGift.image = [UIImage imageWithContentsOfFile:path];
    }else{
        [self startImageDownload:[AAAppGlobals sharedInstance].feedback.feedBackGiftUrlString forIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
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
			
            NSString *compLogoName = [[AAAppGlobals sharedInstance].feedback.feedBackGiftUrlString lastPathComponent];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            path = [NSString stringWithFormat:@"%@/%@",path,compLogoName];
            NSFileManager* filemanager = [NSFileManager defaultManager];
            if ([filemanager fileExistsAtPath:path]) {
                
            }else{
                NSData *imageData = UIImagePNGRepresentation(prodImage);
                [filemanager createFileAtPath:path contents:imageData attributes:nil];
            }
            self.ivFeedbackGift.image = prodImage;
           
        }
    }
    [imageDownloadsInProgress removeObjectForKey:indexPath];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tgrBackgroundViewTap:(id)sender {
    [self.view endEditing:YES];
}


-(void)sendFeedbackInformation
{
//    NSData *imagdate = [NSData dataWithData:UIImagePNGRepresentation(self.pickedImage)];
//    NSString *strEncoded = [imagdate base64EncodedString];
//    NSDictionary* dictFeedback = [[NSDictionary alloc] initWithObjectsAndKeys:self.tvFeedbackText.text,JSON_FEEDBACK_MSG_KEY,self.selectedRadioButtonString,JSON_FEEDBACK_SUB_KEY,[AAAppGlobals sharedInstance].consumer.email,JSON_FEEDBACK_CONSUMER_EMAIL_KEY, nil];
//    NSDictionary *newDic = [NSDictionary dictionaryWithObjectsAndKeys:strEncoded,@"upFile",dictFeedback,@"data", nil];
//    [AAFeedbackHelper sendFeedbackInformationToServer:newDic withCompletionBlock:^(NSString *successMessage) {
//        self.tvFeedbackText.text = @"";
//        UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Feedback" message:successMessage delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//        [alertViewSuccess show];
//    } andFailure:^(NSString *errorMessage) {
//        UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Feedback" message:errorMessage delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//        [alertViewSuccess show];
//    }];

   [self createMultiPartForm];
}

-(void)createMultiPartForm{
    NSString *baseUrlStr = BASE_URL;
    if ([[AAAppGlobals sharedInstance].isSSL isEqualToString:@"1"]) {
        baseUrlStr = [baseUrlStr stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }else{
        
    }
    NSURL* baseURL = [NSURL URLWithString:baseUrlStr];
    NSString *str=[NSString stringWithFormat:@"%@feedback_mail.php",baseUrlStr];
    NSString *urlString = [NSString stringWithFormat:@"%@",str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    if (self.pickedImage != nil) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"upFile\"; filename=\"feedback.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(self.pickedImage, .95)]];
    }

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *jsString = [NSString stringWithFormat:@"{ \"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",
                          JSON_FEEDBACK_MSG_KEY,self.tvFeedbackText.text,
                          JSON_FEEDBACK_SUB_KEY,self.selectedRadioButtonString,
                          JSON_FEEDBACK_CONSUMER_EMAIL_KEY,[AAAppGlobals sharedInstance].consumer.email,
                          JSON_RETAILER_ID_KEY,RETAILER_ID];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"\r\n\r\n%@", jsString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (returnData == nil) {
        UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Feedback" message:@"Error in sending feedback" delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertViewSuccess show];
        return;
    }
     NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@\n str = %@",dict,returnString);
    if (dict!= nil) {
        if ([[dict objectForKey:@"errorCode"] integerValue]==1) {
            self.tvFeedbackText.text = @"";
            [self btnClearPhotoTapped:nil];
            UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Feedback" message:[dict valueForKey:@"errorMessage"] delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertViewSuccess show];
        }else{
            UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Feedback" message:[dict valueForKey:@"errorMessage"] delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertViewSuccess show];
        }
    }
}
- (IBAction)btnSubmitFeedbackTap:(id)sender {
    [self.view endEditing:YES];
    if([self validateFeedbackFields])
        
    {
        if([AAAppGlobals sharedInstance].consumer)
        {
            [self sendFeedbackInformation];
        }
        else
        {
            [self showProfileUpdatePopupView];
        }
    }
}

- (void)sendReferFriendInformation {
    NSDictionary* dictReferFriend = [[NSDictionary alloc] initWithObjectsAndKeys:self.tfFriendName.text,JSON_FRIEND_NAME_KEY,self.tfFriendEmail.text,JSON_FRIEND_EMAIL_KEY,self.tfMobileNumber.text,JSON_FRIEND_MOBILE_KEY,[AAAppGlobals sharedInstance].consumer.email,JSON_FEEDBACK_CONSUMER_EMAIL_KEY, nil];
    [AAFeedbackHelper sendReferFriendToServer:dictReferFriend withCompletionBlock:^(NSString *successMessage) {
        self.tfFriendEmail.text = @"";
        self.tfFriendName.text = @"";
        self.tfMobileNumber.text = @"";
        UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Refer Customer" message:successMessage delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertViewSuccess show];
    } andFailure:^(NSString *errorMessage) {
        UIAlertView* alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Refer Customer" message:errorMessage delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertViewSuccess show];
    }];
}

- (IBAction)btnReferFriendTap:(id)sender {
     [self.view endEditing:YES];
    if([self validateReferAFriendFields])
        
    {
        if([AAAppGlobals sharedInstance].consumer)
        {
        [self sendReferFriendInformation];
        }
        else
        {
            [self showProfileUpdatePopupView];
        }
    }
}

- (IBAction)btnClearPhotoTapped:(id)sender {
    self.btnClearPhoto.hidden = TRUE;
    self.pickedImage = nil;
    self.tfImageSelectionBG.text = @"";
}

#pragma mark - Helpers
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    self.isKeyboardShown = YES;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height -0, 0.0);
    self.scrollViewFeedbackForm.contentInset = contentInsets;
    self.scrollViewFeedbackForm.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
   CGRect aRect = self.view.frame;
    aRect.size.height = aRect.size.height - kbSize.height;
    CGRect frame = self.vwReferView.frame;
    frame.origin.y+= self.activeField.frame.origin.y+self.activeField.frame.size.height;
    CGRect firstResponderFrame = [self.activeField convertRect:self.vwReferView.bounds toView:self.scrollViewFeedbackForm];
    if (!CGRectContainsRect(aRect, firstResponderFrame) ) {
        [self.scrollViewFeedbackForm scrollRectToVisible:firstResponderFrame animated:YES];
    }
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.isKeyboardShown = NO;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollViewFeedbackForm.contentInset = contentInsets;
    self.scrollViewFeedbackForm.scrollIndicatorInsets = contentInsets;
   
}

-(void)setUpRadioButtons
{
//    RadioButtonControlSelectionBlock selectionBlock = ^(VCRadioButton *radioButton){
//        if(radioButton.selected)
//        {
//            self.selectedRadioButtonString = radioButton.selectedValue;
//        }
//        else
//        {
//            self.selectedRadioButtonString = @"";
//        }
//           
//    };
//    
//    // assign the selection block to each radio button
//    self.rbLike.selectionBlock = selectionBlock;
//    self.rbDislike.selectionBlock = selectionBlock;
//    self.rbReservation.selectionBlock = selectionBlock;
//
//    self.rbDislike.selectedColor = [AAColor sharedInstance].rbSelectedColor;
//    self.rbLike.selectedColor = [AAColor sharedInstance].rbSelectedColor;
//    self.rbReservation.selectedColor = [AAColor sharedInstance].rbSelectedColor;
//    
//    // this code below is used to tell a set of radio buttons they are in the same group
//    // group names
//    self.rbLike.groupName = RADIO_BUTTON_GROUP;
//    self.rbDislike.groupName = RADIO_BUTTON_GROUP;
//     self.rbReservation.groupName = RADIO_BUTTON_GROUP;
//    // this code below gives each radio button a selection value
//    self.rbLike.selectedValue = [AAAppGlobals sharedInstance].feedback.feedbackOption1;
//    self.rbDislike.selectedValue = [AAAppGlobals sharedInstance].feedback.feedbackOption2;
//    self.rbReservation.selectedValue = [AAAppGlobals sharedInstance].feedback.feedbackOption3;
//   
    // this code below is only if you choose to change the colors of the radio buttons
    // group 2 will use various colors
   
}

-(void)showProfileUpdatePopupView
{
    self.updatePopupView = [AAProfileUpdatePopupView createProfileUpdatePopupViewWithBackgroundFrameRect:self.view.bounds];
    self.updatePopupView.profilePopupViewDelegate = self;
    [self.view addSubview:self.updatePopupView];
}

-(BOOL)validateReferAFriendFields
{
    BOOL isValid = YES;
     NSString* errMessage = @"";
    for(AAThemeValidationTextField* validationTextField in self.referFriendFields)
    {
    if(![[[validationTextField isValid] objectForKey:IS_VALID_KEY] boolValue])
    {
        errMessage = [[validationTextField isValid] objectForKey:ERROR_MESSAGE_KEY];
        isValid = NO;
    }
    }
    
    if(!isValid)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Fields" message:errMessage delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
    
    return isValid;
}

-(BOOL)validateFeedbackFields
{
    BOOL isValid = YES;
    NSString* errMessage = @"";
    if(![[[self.tvFeedbackText isValid] objectForKey:IS_VALID_KEY] boolValue])
    {
        errMessage = [[self.tvFeedbackText isValid] objectForKey:ERROR_MESSAGE_KEY];
        isValid = NO;
    }
    
    if([self.selectedRadioButtonString length]==0)
    {
        errMessage = [NSString stringWithFormat:@"Please select from %@, %@ or %@",self.lblFeedbackOption1.text,self.lblFeedbackOption2.text,self.lblFeedbackOption3.text];
        isValid = NO;
    }
//    if (self.pickedImage == nil) {
//        errMessage = @"Please select an image";
//        isValid = NO;
//    }
    
    if(!isValid)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Fields" message:errMessage delegate:Nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alertView show];
    }
    return isValid;
}

-(void)setUpReferAFriendsFields
{
    for(AAThemeValidationTextField* validationTextField in self.referFriendFields)
    {
        validationTextField.validationDelegate = self;
    }
}
#pragma mark - validation text field delegates

-(void)validationTextFieldDidBeginEditing:(UITextField *)validatoinTextField
{
    self.activeField = validatoinTextField;
    
}
-(void)validationTextFieldFocus:(UITextField *)validatoinTextField
{
    
}
-(BOOL)validationTextFieldShouldBeginEditing:(UITextField *)validatoinTextField
{
     self.activeField = validatoinTextField;
    return YES;
}

#pragma mark - validation text view delegates
-(void)validationTextViewDidBeginEditing:(UITextView *)validationTextView
{
    
}
-(BOOL)validationTextViewShouldBeginEditing:(UITextView *)validationTextView
{
    self.activeField = validationTextView;
    if(self.isKeyboardShown)
    {
  [self.scrollViewFeedbackForm scrollRectToVisible:self.activeField.frame animated:YES];
    }
    return YES;
}

#pragma mark - Gesture recognizer callbacks
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIControl class]])
    {
        return NO;
    }
    return YES;
}



#pragma mark - profile update popup view callbacks
-(void)showProfileUpdateScreen
{
    
    AAProfileViewController* profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AAProfileViewController"];
    
    profileViewController.profileDelegate = self;
    profileViewController.showBuyButton = NO;
    [self.navigationController pushViewController:profileViewController animated:YES];
    
     }

#pragma mark - profile view controller callbacks
-(void)closeProfileViewController:(id)viewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnInsertPhotoTapped:(id)sender {
//    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
//    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imgPicker.delegate = self;
//    [self presentViewController:imgPicker animated:YES completion:nil];
    isImagePickerShown = TRUE;
    if (1 || [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library",@"Camera", nil];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        [actionSheet showInView:keyWindow];
        
    }else{
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.delegate = self;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.delegate = self;
        [self presentViewController:imgPicker animated:YES completion:nil];
        isImagePickerShown = TRUE;
    }
    else if (buttonIndex==1){
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.delegate = self;
        [self presentViewController:imgPicker animated:YES completion:nil];
        isImagePickerShown = TRUE;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.pickedImage = image;
    self.btnClearPhoto.hidden = FALSE;
    self.tfImageSelectionBG.text = @"Image selected";
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)centralizeReferCustomerTitle{
    float imagewidth = self.ivFeedbackGift.frame.size.width;
     NSLog(@"imagewidth = %f",imagewidth);
    CGSize lablSize = [self.lblFeedbackTitle.text sizeWithFont:self.lblFeedbackTitle.font constrainedToSize:CGSizeMake(MAXFLOAT, self.lblFeedbackTitle.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect lblFrame = self.lblFeedbackTitle.frame;
    lblFrame.size.width = lablSize.width;
    self.lblFeedbackTitle.frame = lblFrame;
    NSLog(@"lablSize = %@",NSStringFromCGSize(lablSize));
    float totalWidth = imagewidth + 5 + lablSize.width;
    NSLog(@"totalWidth = %f",totalWidth);
    CGRect frame = self.vwReferCustomerHeader.frame;
    NSLog(@"frame = %@",NSStringFromCGRect(frame));
    frame.size.width = totalWidth;
    self.vwReferCustomerHeader.frame = frame;
    NSLog(@"frame = %@",NSStringFromCGRect(frame));
    CGPoint center = self.vwReferCustomerHeader.center;
    center.x = [UIScreen mainScreen].bounds.size.width/2-15;
    NSLog(@"center = %@",NSStringFromCGPoint(center));
    self.vwReferCustomerHeader.center = center;
}
-(void)hideKeyBoard{
    [self.activeField resignFirstResponder];
}
- (IBAction)btnRadioOptionsTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
        case 0:{
            self.selectedRadioButtonString =
            [AAAppGlobals sharedInstance].feedback.feedbackOption1;
            [self.btnRdOption1 setSelected:true];
            [self.btnRdOption2 setSelected:false];
            [self.btnRdOption3 setSelected:false];
        }
            break;
        case 1:
        {
            self.selectedRadioButtonString =
            [AAAppGlobals sharedInstance].feedback.feedbackOption2;
            [self.btnRdOption1 setSelected:false];
            [self.btnRdOption2 setSelected:true];
            [self.btnRdOption3 setSelected:false];
        }
            break;
        case 2:
        {
            self.selectedRadioButtonString =
            [AAAppGlobals sharedInstance].feedback.feedbackOption3;
            [self.btnRdOption1 setSelected:false];
            [self.btnRdOption2 setSelected:false];
            [self.btnRdOption3 setSelected:true];
        }
            break;
            
        default:
            break;
    }
}
@end
