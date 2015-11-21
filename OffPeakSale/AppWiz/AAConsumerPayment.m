//
//  AAConsumerPayment.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 19/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAConsumerPayment.h"

@implementation AAConsumerPayment
NSString* const JSON_CARD_NUMBER_KEY = @"cardNum";
NSString* const JSON_EXPIRY_DATE_KEY = @"expiry";
NSString* const JSON_CVV_KEY = @"cvv";

- (id)init
{
    self = [super init];
    if (self) {
        self.cardNumber = 0;
        self.cvv = 0;
        self.expiryMonth = @"";
        self.expiryYear = @"";
        self.paymentType = @"";
    }
    return self;
}

-(void)convertExpiryDateToInteger
{
    expiryDate_ = [NSString stringWithFormat:@"%@%@",self.expiryMonth,self.expiryYear];
    
  
}


-(NSDictionary*)JSONDictionaryRepresentation
{
    [self convertExpiryDateToInteger];
    NSDictionary* dictConsumerPayment = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%lld",self.cardNumber],JSON_CARD_NUMBER_KEY,expiryDate_,JSON_EXPIRY_DATE_KEY,[NSNumber
                                                                                                                                                                                              numberWithInteger:self.cvv],JSON_CVV_KEY, nil ];
    return dictConsumerPayment;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:[NSNumber numberWithLongLong:self.cardNumber] forKey:@"cardNumber"];
    
     [encoder encodeObject:[NSNumber numberWithInteger:self.cvv] forKey:@"cvv"];
    
    [encoder encodeObject:self.expiryYear forKey:@"expiryYear"];
    [encoder encodeObject:self.expiryMonth forKey:@"expiryMonth"];
    [encoder encodeObject:self.paymentType forKey:@"paymentType"];
   
   
   
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.cardNumber = [[decoder decodeObjectForKey:@"cardNumber"] longLongValue];
        self.cvv = [[decoder decodeObjectForKey:@"cvv"] integerValue];
        self.expiryMonth = [decoder decodeObjectForKey:@"expiryMonth"];
        self.expiryYear = [decoder decodeObjectForKey:@"expiryYear"];
        self.paymentType = [decoder decodeObjectForKey:@"paymentType"];
    
    }
    return self;
}
@end
