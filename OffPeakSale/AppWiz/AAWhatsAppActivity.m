//
//  AAWhatsAppActivity.m
//  AppWiz
//
//  Created by Shaikh Shahid Akhtar on 14/12/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAWhatsAppActivity.h"

@implementation AAWhatsAppActivity
@synthesize shareImage,shareString,documentController,includeURL,presentFromButton,presentFromView;
- (NSString *)activityType {
    return @"UIActivityTypePostToWhatsApp";
}

- (NSString *)activityTitle {
    return @"WhatsApp";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"whatsapp"];
}
//+ (UIActivityCategory)activityCategory
+(UIActivityCategory)activityCategory{
    return UIActivityCategoryShare;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    
    NSURL *instagramURL = [NSURL URLWithString:@"whatsapp://app"];
    if (![[UIApplication sharedApplication] canOpenURL:instagramURL]) return YES; // no instagram.
    
//    for (UIActivityItemProvider *item in activityItems) {
//        if ([item isKindOfClass:[UIImage class]]) {
//            if ([self imageIsLargeEnough:(UIImage *)item]) return YES; // has image, of sufficient size.
//            else NSLog(@"DMActivityInstagam: image too small %@",item);
//        }
//    }
    return YES;
}
- (void)prepareWithActivityItems:(NSArray *)activityItems {
//    for (id item in activityItems) {
//        if ([item isKindOfClass:[UIImage class]]) self.shareImage = item;
//        else if ([item isKindOfClass:[NSString class]]) {
//            self.shareString = [(self.shareString ? self.shareString : @"") stringByAppendingFormat:@"%@%@",(self.shareString ? @" " : @""),item]; // concat, with space if already exists.
//        }
//        else if ([item isKindOfClass:[NSURL class]]) {
//            if (self.includeURL) {
//                self.shareString = [(self.shareString ? self.shareString : @"") stringByAppendingFormat:@"%@%@",(self.shareString ? @" " : @""),[(NSURL *)item absoluteString]]; // concat, with space if already exists.
//            }
//        }
//        else NSLog(@"Unknown item type %@", item);
//    }
}
- (void)performActivity {
    
    CFStringRef originalURLString = (__bridge CFStringRef)[NSString stringWithFormat:@"%@", self.shareString];
    CFStringRef preprocessedURLString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, originalURLString, CFSTR(""), kCFStringEncodingUTF8);
    NSString *urlString = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, preprocessedURLString, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    NSString *whatsAppURLString = [NSString stringWithFormat:@"whatsapp://send?text=%@", urlString];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:whatsAppURLString]];

    
//    NSString    * savePath  = [NSTemporaryDirectory() stringByAppendingPathComponent:@"whatsAppTmp.wai"];
//    
//    [UIImageJPEGRepresentation(self.shareImage, 1.0) writeToFile:savePath atomically:YES];
//    
//    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
//    self.documentController.UTI = @"net.whatsapp.image";
//    self.documentController.delegate = self;
//    if (self.shareString) [self.documentController setAnnotation:@{@"message" : self.shareString}];
//    
//    [self.documentController presentOptionsMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.presentFromView animated:YES];
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    [self activityDidFinish:YES];
}

@end
