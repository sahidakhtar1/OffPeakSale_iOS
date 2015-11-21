//
//  AAShareActivityItemProvider.m
//  AppWiz
//
//  Created by Shahid Akhtar Shaikh on 7/1/14.
//  Copyright (c) 2014 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAShareActivityItemProvider.h"

@implementation AAShareActivityItemProvider
-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    NSString *shareString = self.eshopProduct.productShortDescription;
    
    
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        shareString = [NSString stringWithFormat:@"%@\nProduct Price : %@%@ \nDownload app here : %@", shareString,[AAAppGlobals sharedInstance].currency_symbol,self.eshopProduct.currentProductPrice,ITUNES_URL];
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        shareString = [NSString stringWithFormat:@"%@\nProduct Price : %@%@ \nDownload app here : %@", shareString,[AAAppGlobals sharedInstance].currency_symbol,self.eshopProduct.currentProductPrice,ITUNES_URL];
    } else if ([activityType isEqualToString:UIActivityTypeMail]) {
        shareString = [NSString stringWithFormat:@"%@\n\nProduct Price : %@%@\n%@ \n\nDownload app here : %@", shareString,[AAAppGlobals sharedInstance].currency_symbol,self.eshopProduct.currentProductPrice, self.eshopProduct.productDescription,ITUNES_URL];
    }else if ([activityType isEqualToString:@"UIActivityTypePostToInstagram"])
    {
        shareString = [NSString stringWithFormat:@"%@\n\nProduct Price : %@%@\n%@ \n\nDownload app here : %@", shareString,[AAAppGlobals sharedInstance].currency_symbol,self.eshopProduct.currentProductPrice, self.eshopProduct.productDescription,ITUNES_URL];
        
    }
    
    return shareString;
}

-(NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType
{
    if ([activityType isEqualToString:UIActivityTypeMail]) {
        return @"I think you should get this deal";
        
    }
    return @"";
}

-(id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"";
}
@end
