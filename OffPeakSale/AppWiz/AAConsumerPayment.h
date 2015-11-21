//
//  AAConsumerPayment.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAConsumerPayment : NSObject
{
    NSString* expiryDate_;
}
@property (nonatomic) long long cardNumber;

@property (nonatomic) NSInteger cvv;

@property (nonatomic,strong) NSString*  expiryYear;

@property (nonatomic,strong) NSString* expiryMonth;

@property (nonatomic,strong) NSString* paymentType;
-(NSDictionary*)JSONDictionaryRepresentation;
/*@!
month format should be - mm
 year format should be - yyyy
-(void)setExpiryDateWithMonth : (NSString*)month andYear:(NSString*)year;
 */
@end
