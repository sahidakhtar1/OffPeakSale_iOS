//
//  AAConsumer.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAConsumer.h"

@implementation AAConsumer

static NSString* const JSON_FIRST_NAME_KEY = @"fname";
static NSString* const JSON_LAST_NAME_KEY = @"lname";
static NSString* const JSON_GENDER_KEY = @"gender";
static NSString* const JSON_AGE_KEY = @"age";
static NSString* const JSON_DATE_OF_BIRTH_KEY = @"dob";
static NSString* const JSON_MOBILE_NUMBER_KEY = @"mobile_num";
static NSString* const JSON_EMAIL_KEY = @"email";
static NSString* const JSON_ADDRESS_KEY = @"address";
static NSString* const JSON_CITY_KEY = @"city";
static NSString* const JSON_STATE_KEY = @"state";
static NSString* const JSON_COUNTRY_KEY = @"country";
static NSString* const JSON_ZIP_KEY = @"zip";
static NSString* const JSON_LATITUDE_KEY = @"lat";
static NSString* const JSON_LONGITUDE_KEY = @"long";
static NSString* const JSON_DEVICE_TOKEN_KEY = @"device_token";
static NSString* const JSON_DEVICE_KEY = @"device";

static NSString* const JSON_COMAPANY_NAME_KEY = @"company_name";
static NSString* const JSON_CUSTOMER_ID_KEY = @"customer_id";
static NSString* const JSON_INDUSTRY_KEY = @"industry_id";
static NSString* const JSON_DESIGNATION_KEY = @"designation";
static NSString* const JSON_PASSWORD_KEY = @"password";


- (id)init
{
    self = [super init];
    if (self) {
        self.firstName = @"";
        self.lastName = @"";
        self.gender = @"";
        self.age = 0;
        self.dateOfBirth = @"";
        self.email = @"";
        self.mobileNumber = 0;
        self.address = @"";
        self.city = @"";
       
        self.country = @"";
        self.zip = 0;
        self.latitude = -200;
        self.longitude = -200;
        self.deviceToken = @"";
        self.device = 1;
        
        self.commercialFirstName=@"";
        self.commercialLastName =@"";
        self.commercialIndustry= @"";
        self.commercialCustomerID = @"";
        self.commercialAddress = @"";
        self.commercialCity = @"";
        self.commercialCountry = @"";
        self.commercialEmailID = @"";
        self.commercialPassword = @"";
        self.commercialMobileNo = @"";
        self.commercialFaxNo = @"";
        self.commercialPostalCode = @"";
        self.arrConsmerPaymentInformation = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(NSDictionary *)JSONDictionaryRepresentation
{
    NSMutableDictionary* dictConsumerInformation = [self JSONDictionaryProfileRepresentation].mutableCopy;
    for(AAConsumerPayment* consumerPaymentDetails in self.arrConsmerPaymentInformation)
    {
        [dictConsumerInformation addEntriesFromDictionary:[consumerPaymentDetails JSONDictionaryRepresentation]];
    }
    return dictConsumerInformation;
}



-(NSDictionary*)JSONDictionaryCommercialProfileRepresentation
{
   
    NSDictionary* dictConsumerProfileInformation = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    self.commercialCompany,JSON_COMAPANY_NAME_KEY,
                                                    self.commercialCustomerID, JSON_CUSTOMER_ID_KEY,
                                                    self.commercialIndustry, JSON_INDUSTRY_KEY,
                                                    self.commercialFirstName,JSON_FIRST_NAME_KEY,
                                                    self.commercialLastName,JSON_LAST_NAME_KEY,
                                                    self.commercialDesigniation,JSON_DESIGNATION_KEY,
                                                    self.commercialAddress,JSON_ADDRESS_KEY,
                                                    self.commercialCountry,JSON_COUNTRY_KEY,
                                                    self.commercialCity,JSON_CITY_KEY,
                                                    self.commercialEmailID,JSON_EMAIL_KEY,
                                                    self.commercialPassword,JSON_PASSWORD_KEY,
                                                    self.commercialMobileNo,@"mobile_num",
                                                    self.commercialFaxNo,@"fax_num",
                                                    self.commercialPostalCode,JSON_PASSWORD_KEY,
                                                    [NSNumber numberWithInteger:self.zip],JSON_ZIP_KEY,
                                                    [NSNumber numberWithDouble:self.latitude],JSON_LATITUDE_KEY,
                                                    [NSNumber numberWithDouble:self.longitude],JSON_LONGITUDE_KEY,
                                                    [NSNumber numberWithInteger:self.device],JSON_DEVICE_KEY,
                                                    self.deviceToken,JSON_DEVICE_TOKEN_KEY, nil ];
    
    
    
    return dictConsumerProfileInformation;
}

-(NSDictionary*) JSONDictionaryProfileRepresentation
{
    
    NSDictionary* dictConsumerProfileInformation = [[NSDictionary alloc] initWithObjectsAndKeys:self.firstName,JSON_FIRST_NAME_KEY,self.lastName,JSON_LAST_NAME_KEY,self.gender,JSON_GENDER_KEY,[NSNumber numberWithInteger:self.age],JSON_AGE_KEY,self.dateOfBirth,JSON_DATE_OF_BIRTH_KEY, [NSNumber numberWithInteger:self.mobileNumber],JSON_MOBILE_NUMBER_KEY,self.email,JSON_EMAIL_KEY,self.address,JSON_ADDRESS_KEY,self.city,JSON_CITY_KEY,self.country,JSON_COUNTRY_KEY,   [NSNumber numberWithInteger:self.zip],JSON_ZIP_KEY,[NSNumber numberWithDouble:self.latitude],JSON_LATITUDE_KEY,[NSNumber numberWithDouble:self.longitude],JSON_LONGITUDE_KEY,[NSNumber numberWithInteger:self.device],JSON_DEVICE_KEY,self.deviceToken,JSON_DEVICE_TOKEN_KEY, nil ];
    
    
    
    return dictConsumerProfileInformation;
}


-(NSDictionary*)JSONDictionaryLocationRepresentation
{
    
    NSDictionary* dictConsumerLocationInformation = [[NSDictionary alloc] initWithObjectsAndKeys:self.email,JSON_EMAIL_KEY,[NSNumber numberWithDouble:self.latitude],JSON_LATITUDE_KEY,[NSNumber numberWithDouble:self.longitude],JSON_LONGITUDE_KEY,[NSNumber numberWithInteger:self.device],JSON_DEVICE_KEY,self.deviceToken,JSON_DEVICE_TOKEN_KEY, nil ];
    
    
    
    return dictConsumerLocationInformation;
}

-(void)addConsmerPaymentInformation:(AAConsumerPayment *)paymentInformation atIndex : (NSInteger) index
{
    [self.arrConsmerPaymentInformation insertObject:paymentInformation atIndex:index];
}

-(void)removeAllConsumerPaymentInformation
{
    [self.arrConsmerPaymentInformation removeAllObjects];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.age] forKey:@"age"];
    [encoder encodeObject:self.dateOfBirth forKey:@"dateOfBirth"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.mobileNumber] forKey:@"mobileNumber"];
    
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.city forKey:@"city"];
   
    [encoder encodeObject:self.country forKey:@"country"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.zip] forKey:@"zip"];
    [encoder encodeObject:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    [encoder encodeObject:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.device] forKey:@"device"];
    [encoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    
    [encoder encodeObject:self.commercialFirstName forKey:@"commercialFirstName"];
    [encoder encodeObject:self.commercialLastName forKey:@"commercialLastName"];
    [encoder encodeObject:self.commercialIndustry forKey:@"commercialIndustry"];
    [encoder encodeObject:self.commercialCustomerID forKey:@"commercialCustomerID"];
    [encoder encodeObject:self.commercialAddress forKey:@"commercialAddress"];
    [encoder encodeObject:self.commercialCity forKey:@"commercialCity"];
    [encoder encodeObject:self.commercialCountry forKey:@"commercialCountry"];
    [encoder encodeObject:self.commercialEmailID forKey:@"commercialEmailID"];
    [encoder encodeObject:self.commercialPassword forKey:@"commercialPassword"];
    [encoder encodeObject:self.commercialCompany forKey:@"commercialCompany"];
    [encoder encodeObject:self.commercialDesigniation forKey:@"commercialDesigniation"];
    
    [encoder encodeObject:self.commercialPostalCode forKey:@"commercialPostalCode"];
    [encoder encodeObject:self.commercialMobileNo forKey:@"commercialMobileNo"];
    [encoder encodeObject:self.commercialFaxNo forKey:@"commercialFaxNo"];
    [encoder encodeObject:self.rewardPoints forKey:@"rewardPoints"];


     [encoder encodeObject:self.arrConsmerPaymentInformation forKey:@"consumerPaymentInfo"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.age = [[decoder decodeObjectForKey:@"age"] integerValue];
        self.dateOfBirth = [decoder decodeObjectForKey:@"dateOfBirth"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.mobileNumber = [[decoder decodeObjectForKey:@"mobileNumber"] integerValue];
        self.address = [decoder decodeObjectForKey:@"address"];;
        self.city = [decoder decodeObjectForKey:@"city"];
       
        self.country = [decoder decodeObjectForKey:@"country"];
        self.zip = [[decoder decodeObjectForKey:@"zip"] integerValue];
        self.latitude = [[decoder decodeObjectForKey:@"latitude"] doubleValue];
        self.longitude = [[decoder decodeObjectForKey:@"longitude"] doubleValue];
        self.deviceToken = [decoder decodeObjectForKey:@"deviceToken"];
        self.device = [[decoder decodeObjectForKey:@"device"] integerValue];
        
        self.commercialFirstName=[decoder decodeObjectForKey:@"commercialFirstName"];
        self.commercialLastName =[decoder  decodeObjectForKey:@"commercialLastName"];
        self.commercialIndustry= [decoder  decodeObjectForKey:@"commercialIndustry"];
        self.commercialCustomerID = [decoder  decodeObjectForKey:@"commercialCustomerID"];
        self.commercialAddress = [decoder  decodeObjectForKey:@"commercialAddress"];
        self.commercialCity = [decoder  decodeObjectForKey:@"commercialCity"];
        self.commercialCountry = [decoder  decodeObjectForKey:@"commercialCountry"];
        self.commercialEmailID = [decoder  decodeObjectForKey:@"commercialEmailID"];
        self.commercialPassword = [decoder  decodeObjectForKey:@"commercialPassword"];
        self.commercialCompany = [decoder  decodeObjectForKey:@"commercialCompany"];
        self.commercialDesigniation = [decoder  decodeObjectForKey:@"commercialDesigniation"];
        
        self.commercialFaxNo = [decoder  decodeObjectForKey:@"commercialFaxNo"];
        self.commercialMobileNo = [decoder  decodeObjectForKey:@"commercialMobileNo"];
        self.commercialPostalCode = [decoder  decodeObjectForKey:@"commercialPostalCode"];
        
        self.arrConsmerPaymentInformation = [decoder decodeObjectForKey:@"consumerPaymentInfo"];
        self.rewardPoints = [decoder decodeObjectForKey:@"rewardPoints"];
    }
    return self;
}
@end
