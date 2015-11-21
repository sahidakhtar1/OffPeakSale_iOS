//
//  AAConsumer.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAConsumerPayment.h"
@interface AAConsumer : NSObject
@property (nonatomic,copy) NSString* firstName;
@property (nonatomic,copy) NSString* lastName;
@property (nonatomic,copy) NSString* gender;
@property (nonatomic) NSInteger age;
@property (nonatomic,copy) NSString* dateOfBirth;
@property (nonatomic,copy) NSString* email;
@property (nonatomic) NSInteger mobileNumber;
@property (nonatomic,copy) NSString* address;
@property (nonatomic,copy) NSString* city;
@property (nonatomic,copy) NSString* rewardPoints;

@property (nonatomic,copy) NSString* country;
@property (nonatomic) NSInteger zip;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic,strong) NSString* deviceToken;
@property (nonatomic) NSInteger device;
@property (nonatomic,strong) NSMutableArray*
arrConsmerPaymentInformation;

@property (nonatomic,copy) NSString* commercialFirstName;
@property (nonatomic,copy) NSString* commercialLastName;
@property (nonatomic,copy) NSString* commercialCompany;
@property (nonatomic,copy) NSString* commercialIndustry;
@property (nonatomic,copy) NSString* commercialCustomerID;
@property (nonatomic,copy) NSString* commercialAddress;
@property (nonatomic,copy) NSString* commercialCity;
@property (nonatomic,copy) NSString* commercialDesigniation;
@property (nonatomic,copy) NSString* commercialCountry;
@property (nonatomic,copy) NSString* commercialEmailID;
@property (nonatomic,copy) NSString* commercialPassword;
@property (nonatomic,copy) NSString* commercialMobileNo;
@property (nonatomic,copy) NSString* commercialFaxNo;
@property (nonatomic,copy) NSString* commercialPostalCode;

-(NSDictionary*)JSONDictionaryRepresentation;
-(NSDictionary*)JSONDictionaryProfileRepresentation;
-(void)addConsmerPaymentInformation:(AAConsumerPayment *)paymentInformation atIndex : (NSInteger) index;
-(void)removeAllConsumerPaymentInformation;
-(NSDictionary*)JSONDictionaryLocationRepresentation;
-(NSDictionary*)JSONDictionaryCommercialProfileRepresentation;
@end
