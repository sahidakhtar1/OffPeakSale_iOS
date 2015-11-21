//
//  AANetworkHandler.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 15/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AANetworkHandler.h"
#import "AAAppGlobals.h"
@implementation AANetworkHandler
-(void)sendJSONRequestToServerWithEndpoint :(NSString*)endpoint withParams : (NSDictionary*)params withSuccessBlock : (void(^)(id))success withFailureBlock :(void(^)(NSError*)) failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.71 (KHTML, like Gecko) Version/6.1 Safari/537.71" forHTTPHeaderField:@"User-Agent"];
  
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    NSString *baseUrlStr = BASE_URL;
    if ([[AAAppGlobals sharedInstance].isSSL isEqualToString:@"1"]) {
        baseUrlStr = [baseUrlStr stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];//@"https://appwizlive.com/";
    }else{
       //baseUrlStr = @"http://appwizlive.com/";
    }
    NSURL* baseURL = [NSURL URLWithString:baseUrlStr];
    
    NSURL* url = [NSURL URLWithString:endpoint relativeToURL:baseURL];
    NSLog(@"url = %@",[url absoluteString]);
    NSLog(@"input = %@", params);
    
    AFHTTPRequestOperation *operation = [manager POST:[url absoluteString] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response= %@",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [operation start];
    
}


@end
