//
//  AAWechatActivity.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 14/12/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAWechatActivity.h"

@implementation AAWechatActivity
@synthesize  shareString,shareImage;
- (NSString *)activityType {
    return @"UIActivityTypePostToWeChat";
}

- (NSString *)activityTitle {
    return @"WeChat";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"wechat"];
}
//+ (UIActivityCategory)activityCategory
+(UIActivityCategory)activityCategory{
    return UIActivityCategoryShare;
}
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    
//    NSURL *instagramURL = [NSURL URLWithString:@"whatsapp://app"];
//    if (![[UIApplication sharedApplication] canOpenURL:instagramURL]) return YES; // no instagram.
//    
//    //    for (UIActivityItemProvider *item in activityItems) {
//    //        if ([item isKindOfClass:[UIImage class]]) {
//    //            if ([self imageIsLargeEnough:(UIImage *)item]) return YES; // has image, of sufficient size.
//    //            else NSLog(@"DMActivityInstagam: image too small %@",item);
//    //        }
//    //    }
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
//    for (id item in activityItems) {
//        if ([item isKindOfClass:[UIImage class]]) self.shareImage = item;
//        else if ([item isKindOfClass:[NSString class]]) {
//            self.shareString = [(self.shareString ? self.shareString : @"") stringByAppendingFormat:@"%@%@",(self.shareString ? @" " : @""),item]; // concat, with space if already exists.
//        }
//        else if ([item isKindOfClass:[NSURL class]]) {
////            if (self.includeURL) {
////                self.shareString = [(self.shareString ? self.shareString : @"") stringByAppendingFormat:@"%@%@",(self.shareString ? @" " : @""),[(NSURL *)item absoluteString]]; // concat, with space if already exists.
////            }
//        }
//        else NSLog(@"Unknown item type %@", item);
//    }
}
- (void)performActivity {
    
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"Some Title";
//    //message.
//    message.description = @"sample desc";
//   // [message setThumbImage:self.shareImage];
//    NSData *imageData = UIImageJPEGRepresentation(self.shareImage, 1.0);
//    WXImageObject *ext = [WXImageObject object];
//    
//    ext.imageData = imageData;
//    message.mediaObject = ext;
//    
//    self.req = [[SendMessageToWXReq alloc] init];
//    self.req.bText = NO;
//    self.req.message = message;
//    self.req.scene = WXSceneTimeline;
//    [WXApi sendReq:self.req];
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    NSLog(@"Text = %@", self.shareString);
    req.text = self.shareString;
    req.bText = YES;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
    
    
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    [self activityDidFinish:YES];
}
@end
