//
//  AAProductReview.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 5/5/15.
//  Copyright (c) 2015 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAProductReview.h"

@implementation AAProductReview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [self initialize];
        [self setFont];
        self.frame = frame;
        
    }
    return self;
}

- (UIView*)initialize{
    UIView *childView= [[[NSBundle mainBundle] loadNibNamed:@"AAProductReview" owner:self options:nil] objectAtIndex:0];
    
    return childView;
}
-(void)setFont{
    self.lblAddReviewHeading.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:PRODUCTDETAIL_HEADING_FONTSIZE];
    self.lblReadReviewHeading.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].boldFont size:PRODUCTDETAIL_HEADING_FONTSIZE];
    
    self.lblReviews.font = [UIFont fontWithName:[AAAppGlobals sharedInstance].normalFont size:PRODUCTDETAIL_BODY_FONTSIZE];
    self.tvComment.placeHolderText = @"Comments (200 characters)";
    self.tvComment.validationDelegate  = self;
//    [self setReviews];
    
    
}
-(void)showProductReview{
  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setReviews) userInfo:nil repeats:NO];
}
#pragma mark - validation text view delegates
-(void)validationTextViewDidBeginEditing:(UITextView *)validationTextView
{
//    validationTextView.text = [NSString stringWithFormat:@"%@ ",self.tvComment.text];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length==0) {
        return true;
    }
    if (textView.text.length<=200) {
        return true;
    }
    return false;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.tvComment resignFirstResponder];
    [self.tfEmailId resignFirstResponder];
    [self.tfName resignFirstResponder];
}
- (IBAction)btnSubmitTapped:(id)sender {
    NSString *msg = nil;
    if ([self.tvComment.text length] == 0) {
        msg = @"Please enter comment";
    }else if([self.tfName.text length] == 0){
        msg = @"Please enter name";
    }else if (![self validateEmailId:self.tfEmailId.text]){
        msg = @"Please enter a valid email id";
    }
    if (msg == nil) {
        [self submiteReview];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }
}
-(BOOL)validateEmailId:(NSString*)emailid{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
    
    return myStringMatchesRegEx;
    if (myStringMatchesRegEx) {
        
        return NO;
    }else{
        return YES;
    }
    
}
-(void)setReviews{
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if ([self.productReviews length] == 0) {
        self.lblReviews.text = @"No reviews for this product";
    }else{
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.productReviews dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.lblReviews.attributedText = attributedString;
        [self performSelectorOnMainThread:@selector(calculateLblSize) withObject:nil waitUntilDone:NO];
    }
//    });
    
}
-(void)calculateLblSize{
    NSAttributedString *attributedText = self.lblReviews.attributedText;
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.lblReviews.frame.size.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                               context:nil];
    CGRect frame = self.lblReviews.frame;
    frame.size.height = rect.size.height;
    self.lblReviews.frame = frame;
    
    CGSize contentSize = self.mScrollView.contentSize;
    contentSize.height = self.lblReviews.frame.origin.y + self.lblReviews.frame.size.height+10;
    self.mScrollView.contentSize  = contentSize;
}
-(void)submiteReview{
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:RETAILER_ID,@"retailerId",
                            /*[AAAppGlobals sharedInstance].customerEmailID,@"email",*/
                            self.productId,@"productId",
                            self.tfName.text,@"name",
                            self.tvComment.text,@"comments",
                            self.tfEmailId.text,@"email",
                            nil];
    [[AAAppGlobals sharedInstance].networkHandler sendJSONRequestToServerWithEndpoint:@"submit_review.php" withParams:params withSuccessBlock:^(NSDictionary *response) {
        NSLog(@"response = %@",response);
        [[[UIAlertView alloc] initWithTitle:@"Product review" message:[response valueForKey:@"errorMessage"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        if ([[response valueForKey:@"errorCode"] isEqualToString:@"1"]) {
            self.tfEmailId.text = @"";
            self.tfName.text = @"";
            self.tvComment.text = @"";
        }else{
            
        }
    } withFailureBlock:^(NSError *error) {
        //NSLog( @"Network failure" );
        NSLog(@"error = %@",error);
    }];
 
}
@end
