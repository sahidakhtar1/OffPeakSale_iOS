

#import "TableViewKeyBoardHandling.h"
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")


@interface TableViewKeyBoardHandling ()

@end

@implementation TableViewKeyBoardHandling
- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self){
        [self setup];
    }
    
    return self;
}

-(void)awakeFromNib {
    [self setup];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification*)notification {
    if ( !CGRectEqualToRect(priorFrame, CGRectZero) ) return;
    
    UIView *firstResponder = [self findFirstResponder:self];
    if ( !firstResponder ) {
        // No child view is the first responder - nothing to do here
        return;
    }
    
    priorFrame = self.frame;
    
    // Use this view's coordinate system
    CGRect keyboardBounds = [self convertRect:[[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    CGRect screenBounds = [self convertRect:[UIScreen mainScreen].bounds fromView:nil];
    if ( keyboardBounds.origin.y == 0 ) keyboardBounds.origin = CGPointMake(0, screenBounds.size.height - keyboardBounds.size.height);
    
    //CGFloat spaceAboveKeyboard = keyboardBounds.origin.y - self.bounds.origin.y;
    //CGFloat offset = -1;
    
    CGRect newFrame = self.frame;
    newFrame.size.height -= keyboardBounds.size.height - 
    ((keyboardBounds.origin.y+keyboardBounds.size.height) 
     - (self.bounds.origin.y+self.bounds.size.height));
    
    CGRect new1Frame = CGRectMake(newFrame.origin.x, newFrame.origin.y+20, newFrame.size.width, newFrame.size.height-40);
    self.frame = new1Frame;
    CGRect firstResponderFrame = [firstResponder convertRect:firstResponder.bounds toView:self];
    
    [UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    //[UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    
        // Shrink view's height by the keyboard's height, and scroll to show the text field/view being edite
    
    
        //self.frame = new1Frame;
    CGRect offset1 = CGRectMake(firstResponderFrame.origin.x, firstResponderFrame.origin.y, firstResponderFrame.size.width, firstResponderFrame.size.height);
    [self scrollRectToVisible:offset1 animated:YES];
    [UIView commitAnimations];
    self.frame = newFrame;
}

- (void)keyboardWillHide:(NSNotification*)notification {
    if ( CGRectEqualToRect(priorFrame, CGRectZero) ) return;
    
    // Restore dimensions to prior size
    [UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    self.frame = priorFrame;
    priorFrame = CGRectZero;
    [UIView commitAnimations];
}

- (UIView*)findFirstResponder:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFirstResponder:childView];
        if ( result ) return result;
    }
    return nil;
}
@end




