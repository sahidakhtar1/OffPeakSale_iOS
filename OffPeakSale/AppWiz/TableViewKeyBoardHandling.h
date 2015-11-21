
#import <Foundation/Foundation.h>


@interface TableViewKeyBoardHandling : UITableView {
    CGRect priorFrame;
}
- (UIView*)findFirstResponder:(UIView*)view;
@end
