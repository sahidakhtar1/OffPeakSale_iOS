//
//  AAFeedbackViewController.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAChildBaseViewController.h"
#import "AAThemeValidationTextField.h"
#import "AAThemeValidationTextView.h"
#import "AAThemeGlossyButton.h"
#import "VCRadioButton.h"
#import "AAProfileUpdatePopupView.h"
#import "AAFeedbackHelper.h"
#import "UIImageView+WebCache.h"
#import "AAProfileViewController.h"
@interface AAFeedbackViewController : AAChildBaseViewController <AAValidationTextFieldDelegate,AAValidationTextViewDelegate,UIGestureRecognizerDelegate,AAProfileUpdatePopupViewDelegate,AAProfileViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    BOOL isImagePickerShown;
}
@property (nonatomic, strong) NSString *title;
@property (weak, nonatomic) IBOutlet UIView *vwReferView;
@property (weak, nonatomic) IBOutlet UIView *vwFeedback;

@property (strong, nonatomic) IBOutlet UIView *vwReferCustomerHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblFeedbackTitle;
- (IBAction)tgrBackgroundViewTap:(id)sender;
- (IBAction)btnSubmitFeedbackTap:(id)sender;
- (IBAction)btnReferFriendTap:(id)sender;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (strong, nonatomic) IBOutlet AAThemeGlossyButton *btnClearPhoto;

@property (strong, nonatomic) IBOutlet AAThemeValidationTextField *tfImageSelectionBG;
- (IBAction)btnClearPhotoTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *vwImageBG;
@property (strong, nonatomic) IBOutlet UILabel *lblFeedbackOption1;
@property (strong, nonatomic) IBOutlet UILabel *lblFeedbackOption2;
@property (strong, nonatomic) IBOutlet UILabel *lblFeedbackOption3;
@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic) BOOL isKeyboardShown;
@property (weak, nonatomic) IBOutlet UIView *viewScrollViewContent;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnReferFriend;
@property (weak, nonatomic) IBOutlet AAThemeGlossyButton *btnSubmitFeedback;
@property (strong, nonatomic) IBOutlet UIButton *btnInsetPhoto;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewFeedbackForm;
@property (nonatomic,strong) UIView* activeField;
//@property (weak, nonatomic) IBOutlet VCRadioButton *rbLike;
//@property (weak, nonatomic) IBOutlet VCRadioButton *rbDislike;
//@property (weak, nonatomic) IBOutlet VCRadioButton *rbReservation;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextView *tvFeedbackText;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfFriendName;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfFriendEmail;
@property (weak, nonatomic) IBOutlet AAThemeValidationTextField *tfMobileNumber;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tgrBackgroundView;
@property (strong,nonatomic) NSString* selectedRadioButtonString;
@property (weak, nonatomic) IBOutlet UIImageView *ivFeedbackGift;
@property (nonatomic,strong) AAProfileUpdatePopupView* updatePopupView;
@property (strong, nonatomic) IBOutletCollection(AAThemeValidationTextField) NSArray *referFriendFields;
- (IBAction)btnInsertPhotoTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vwHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *btnRdOption1;
@property (weak, nonatomic) IBOutlet UIButton *btnRdOption2;
@property (weak, nonatomic) IBOutlet UIButton *btnRdOption3;
- (IBAction)btnRadioOptionsTapped:(id)sender;
@end
