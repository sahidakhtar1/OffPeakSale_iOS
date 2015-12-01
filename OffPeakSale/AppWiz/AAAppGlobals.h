//
//  AAAppGlobals.h
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 16/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AANetworkHandler.h"
#import "AARetailer.h"
#import "AAConsumer.h"
#import "AALocationHandler.h"
#import "AAPaymentHandler.h"
#import "AAEshopCategoryList.h"
#import "AAServerRequestRetryQueue.h"
#import "AALocationHelper.h"
#import "AAFeedback.h"
#import "AAVoucherList.h"
#import "AALoyalty.h"
#import "AAConfig.h"
#import "ItemDetail.h"

@class AAEarliestSchedule;
@interface AAAppGlobals : NSObject

extern NSString* const USER_DEFAULTS_ORDERHISTORY_KEY;
extern NSString* const USER_DEFAULTS_LOOKBOOK_KEY;
extern NSString* const USER_DEFAULTS_CONSUMER_KEY;
extern NSString* const USER_DEFAULTS_RETAILER_KEY;
extern NSString* const USER_DEFAULTS_ESHOP_KEY;
extern NSString* const USER_DEFAULTS_VOUCHERS_KEY;
extern NSString* const USER_DEFAULTS_FEEDBACK_KEY;
extern NSString* const USER_DEFAULTS_LOYALTY_KEY;
extern NSString* const USER_DEFAULTS_ADD_PUBLISHER_ID_KEY;
extern NSString* const GOOGLE_MAPS_API_KEY;

@property (nonatomic,strong) AAEshopCategoryList* categoryList;
@property (nonatomic,strong) AANetworkHandler* networkHandler;
@property (nonatomic,strong) AAServerRequestRetryQueue* retryQueue;
@property (nonatomic,strong) AARetailer* retailer;
@property (nonatomic,strong) AAConsumer* consumer;
@property (nonatomic,strong) NSArray* paymentTypes;
@property (nonatomic,strong) AALocationHandler* locationHandler;
@property (nonatomic,strong) AAPaymentHandler* paymentHandler;
@property (nonatomic,strong) dispatch_queue_t backgroundQueue;
@property (nonatomic,strong) NSString* deviceToken;
@property (nonatomic,strong) AALocationHelper* locationHelper;
@property (nonatomic,strong) AAVoucherList* voucherList;
@property (nonatomic,strong) AALoyalty* loyalty;
@property (nonatomic,strong) AAFeedback* feedback;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic,strong) NSString* addPublisherId;
@property (nonatomic, strong) NSString *customerEmailID;
@property (nonatomic, strong) NSString *customerPassword;
@property (nonatomic) BOOL isPasswordChanged;
@property (nonatomic) CGFloat cartTotal;
@property NSInteger cartTotalItemCount;
@property (nonatomic, strong) NSString *credit_terms;
@property (nonatomic, strong) NSString *currency_code;
@property (nonatomic) BOOL disablePayment;
@property (nonatomic) BOOL cod;
@property (nonatomic) BOOL enableShoppingCart;
@property (nonatomic) BOOL enableCreditCode;
@property (nonatomic) BOOL enableRating;
@property (nonatomic, strong) NSString *currency_symbol;
@property (nonatomic) BOOL isPayByCredits;
@property (nonatomic) BOOL isCommercialUI;
@property (nonatomic) BOOL isDecimalAllowed;
@property (nonatomic, strong) NSString* normalFont;
@property (nonatomic, strong) NSString* boldFont;
@property  (nonatomic, strong) NSString *isSSL;
@property  (nonatomic, strong) NSString *discountPercent;
@property  (nonatomic, strong) NSString *discountType;
@property  (nonatomic, strong) NSString *discountCode;
@property  (nonatomic, strong) NSString *cartTotalAfterDiscount;
@property  (nonatomic, strong) NSString *termsConditions;
@property  (nonatomic, strong) NSString *shippingCharge;
@property  (nonatomic, strong) NSString *reward_points;
@property  (nonatomic, strong) NSString *rewardPointsRedeemed;
@property (nonatomic, strong) NSString *enableDelivery;
@property (nonatomic, strong) NSString *deliveryDays;
@property (nonatomic, strong) NSString *deliveryTimeSlots;
@property  (nonatomic) CGFloat freeAmount;
@property  (nonatomic) BOOL showLocationOffalert;
@property  (nonatomic, strong) NSMutableArray *arrCartItems;
@property  (nonatomic, strong) NSMutableDictionary *currecyDict;
@property (nonatomic, strong) NSDate *scheduledDate;
@property (nonatomic, strong) NSArray *deliverySlotsArray;
@property (nonatomic, strong) NSArray *collectionSlotsArray;
@property (nonatomic, strong) NSArray *collectionAddressArray;
@property (nonatomic, strong) NSString *selectedTime;
@property (nonatomic, strong) NSString *selectedCollectionAddress;
@property (nonatomic, strong) NSMutableArray *arrCategory;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSString *rewardsPointEarned;
@property (nonatomic, strong) NSString *discountApplied;
@property (nonatomic, strong) NSString *appStoreUrl;
@property (nonatomic) BOOL appUpdateAlertShown;
@property (nonatomic) int deliveryOptonSelectedIndex;
@property (nonatomic) double currentLat;
@property (nonatomic) double currentLong;
@property (nonatomic) double targetLat;
@property (nonatomic) double targetLong;
@property (nonatomic,strong) NSString *tagetedAddress;
@property (nonatomic, strong) NSString *currentAddress;

@property (nonatomic, strong) AAEarliestSchedule *earlieastSchedule;


//core data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(AAAppGlobals*)sharedInstance;
-(void)getCurrencySymbol;
-(NSString*)getCurrencySymbolWithCode:(NSString*)code;
-(void)loadDataFromUserDefaults;
-(BOOL)addProductToCart:(AAEShopProduct*)product witnQuantity:(NSString*)qty;
-(void)calculateCartTotal;
-(NSMutableArray*)getAllProducts;
-(void)deletePoduct:(ItemDetail*)product;
-(void)deleteAllProducts;
-(ItemDetail*)getProductWithProductId:(NSString*)productId;
-(void)calculateCartTotalItemCount;
-(AAEShopProduct*)cartItemWithId:(NSInteger)productId;

-(void)getNormalFont:(NSString*)fontName;
-(NSString*)allProductsID;
-(float)getImageHeight;
-(float)getImageHeightWithPadding:(CGFloat)padding;
-(BOOL)isHavingDecimal:(NSString*)string;

-(void)getDateByAddingDays:(int)days;
-(AAEarliestSchedule*)getDateByAddingDays:(int)hours andHours:(int)mins andTimeSlots:(NSArray*)timeSlots isStandardLimeLapse:(BOOL)timeLapse;
-(NSMutableArray*)possibleTimeSlotes:(NSArray*)timeSlots hours:(int)hours mins:(int)mins;
-(NSString*)convertDateToString:(NSDate*)date;
-(NSString*)getPriceStrfromFromPrice:(float)price;
-(NSMutableArray*)conver12HourFormat:(NSArray*)timeSlots;
-(NSString*)getDisctanceFrom:(double)startLat
                     andLong:(double)startLong
                       toLat:(double)endLat
                     andLong:(double)endLong;
@end
