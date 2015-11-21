//
//  AAAppGlobals.m
//  Swensens
//
//  Created by Shahid Akhtar Shaikh on 16/12/13.
//  Copyright (c) 2013 Shahid Akhtar Shaikh. All rights reserved.
//

#import "AAAppGlobals.h"
#import "AAEarliestSchedule.h"

#define DEFAULT_ASPECT_RATIO 1.675

@implementation AAAppGlobals

static AAAppGlobals* singleInstance;

NSString* const USER_DEFAULTS_ORDERHISTORY_KEY = @"orderHistory";
NSString* const USER_DEFAULTS_LOOKBOOK_KEY = @"lookbook";
NSString* const USER_DEFAULTS_CONSUMER_KEY = @"consumer";
NSString* const USER_DEFAULTS_RETAILER_KEY = @"retailer";
NSString* const USER_DEFAULTS_VOUCHERS_KEY = @"vouchers";
NSString* const USER_DEFAULTS_FEEDBACK_KEY = @"feedback";
NSString* const USER_DEFAULTS_LOYALTY_KEY = @"loyalty";
NSString* const USER_DEFAULTS_ESHOP_KEY = @"eshop";
NSString* const USER_DEFAULTS_ADD_PUBLISHER_ID_KEY = @"publisherId";
NSString* const GOOGLE_MAPS_API_KEY = @"AIzaSyAI11LvYDPIRY3rbVIlk-hGG8WwWYiUaLI";//@"AIzaSyDAcq2Tr9Q1EkqZ0LiRPqdVYnTQLychiFI";



@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (AAAppGlobals *)sharedInstance
{
    static dispatch_once_t dispatchOnceToken;
    
    dispatch_once(&dispatchOnceToken, ^{
        singleInstance = [[AAAppGlobals alloc] init];
        singleInstance.networkHandler = [[AANetworkHandler alloc] init];
        singleInstance.categoryList = [[AAEshopCategoryList alloc]init];
        singleInstance.retailer = [[AARetailer alloc]init];
        singleInstance.consumer = nil;
        singleInstance.latitude = 1.3;
        singleInstance.longitude = 103.8;
       // singleInstance.locationHandler = [[AALocationHandler alloc] init];
        singleInstance.paymentTypes = [NSArray arrayWithObjects:@"MasterCard",@"Visa",@"American Express",@"Paypal", nil];
        singleInstance.paymentHandler = [[AAPaymentHandler alloc] init];
        singleInstance.retryQueue = [[AAServerRequestRetryQueue alloc]init];
        
        singleInstance.backgroundQueue = dispatch_queue_create("com.appsauthority.backgroundQueue", NULL);
        singleInstance.addPublisherId = nil;
        singleInstance.deviceToken = @"";
        singleInstance.locationHelper = [[AALocationHelper alloc]init];
        singleInstance.voucherList = [[AAVoucherList alloc] init];
        singleInstance.feedback = [[AAFeedback alloc] init];
        singleInstance.loyalty = [[AALoyalty alloc] init];
        singleInstance.arrCartItems = [[NSMutableArray alloc] init];
        singleInstance.customerEmailID = @"";
        singleInstance.customerPassword = @"";
        singleInstance.isPasswordChanged = YES;
        singleInstance.credit_terms = nil;
        singleInstance.isPayByCredits = NO;
        singleInstance.isCommercialUI = YES;
        singleInstance.currency_code = @"SGD";
        singleInstance.currency_symbol = @"$";
        singleInstance.enableShoppingCart = FALSE;
        singleInstance.enableRating = FALSE;
        singleInstance.enableCreditCode = FALSE;
        singleInstance.isDecimalAllowed = FALSE;
        singleInstance.normalFont = @"ArialMT";
        singleInstance.boldFont = @"Arial-BoldMT";
        singleInstance.disablePayment = FALSE;
        singleInstance.isSSL = @"0";
        singleInstance.discountPercent = @"0.0";
        singleInstance.discountCode = nil;
        singleInstance.cartTotalAfterDiscount = @"0";
        singleInstance.termsConditions = @"";
        singleInstance.discountType = @"Percentage";
        singleInstance.shippingCharge = @"0";
        singleInstance.freeAmount = 0;
        singleInstance.showLocationOffalert = false;
        singleInstance.reward_points = @"0";
        singleInstance.rewardPointsRedeemed = @"0";
        singleInstance.deliveryDays = @"0";
        singleInstance.enableDelivery = @"0";
        singleInstance.appStoreUrl = @"";
        singleInstance.appUpdateAlertShown = false;
        singleInstance.arrCategory = [[NSMutableArray alloc] init];
        //[singleInstance getCurrencySymbol];
        singleInstance.currecyDict = [[NSMutableDictionary alloc] init];
        singleInstance.cod = false;
        singleInstance.products = nil;
        singleInstance.deliveryOptonSelectedIndex = 0;
        
        
        [singleInstance deleteAllProducts];
    });
    
    return singleInstance;
}
-(void)getCurrencySymbol{
    
    singleInstance.currency_symbol =[singleInstance getCurrencySymbolWithCode:singleInstance.currency_code];
    if (singleInstance.currency_symbol == nil) {
        singleInstance.currency_symbol = @"$";
    }
}
-(NSString*)getCurrencySymbolWithCode:(NSString*)code{
    NSDictionary*  CURRRENCY_DICT = [NSDictionary dictionaryWithObjectsAndKeys:@"$",@"AUD",
                                     @"R$",@"BRL",
                                     @"$",@"CAD",
                                     @"Kc",@"CZK",
                                     @"kr",@"DKK",
                                     @"€",@"EUR",
                                     @"$",@"HKD",
                                     @"Ft",@"HUF",
                                     @"~",@"ILS",
                                     @"Y",@"JPY",
                                     @"RM",@"MYR",
                                     @"$",@"MXN",
                                     @"kr",@"NOK",
                                     @"$",@"NZD",
                                     @"P",@"PHP",
                                     @"zl",@"PLN",
                                     @"£",@"GBP",
                                     @"ру6",@"RUB",
                                     @"$",@"SGD",
                                     @"kr",@"SEK",
                                     @"CHF",@"CHF",
                                     @"NT$",@"TWD",
                                     @"B",@"THB",
                                     @"Tr",@"TRY",
                                     @"₹",@"INR",
                                     @"$", @"USD", nil];
    NSString *symbol = [CURRRENCY_DICT valueForKey:code];
    if (symbol == nil) {
        symbol = code;
    }
    return symbol;
}
-(void)getNormalFont:(NSString*)fontName{
    NSLog(@"fontname  = %@",fontName);
    NSDictionary*  normalFontDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"ArialMT",@"Arial",
                                      @"OpenSans",@"Opensans",
                                      @"Georgia",@"Georgia",
                                      @"TimesNewRomanPSMT",@"Times",
                                      @"TrebuchetMS",@"Trebuchet",
                                     @"Folks-Normal",@"Folks",
                                     @"Aleo-Regular",@"Aleo",
                                      nil];
    NSDictionary*  boldFontDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"Arial-BoldMT",@"Arial",
                                     @"OpenSans-Semibold",@"Opensans",
                                     @"Georgia-Bold",@"Georgia",
                                     @"TimesNewRomanPS-BoldMT",@"Times",
                                     @"TrebuchetMS-Bold",@"Trebuchet",
                                    @"Aleo-Bold",@"Aleo",
                                    @"Folks-Bold",@"Folks",
                                     nil];
    if ([normalFontDict objectForKey:fontName]) {
        singleInstance.normalFont = [normalFontDict objectForKey:fontName];
    }
    if ([boldFontDict objectForKey:fontName]) {
        singleInstance.boldFont = [boldFontDict objectForKey:fontName];
    }
}
-(void)loadDataFromUserDefaults
{
    @try {
   
            if([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_CONSUMER_KEY])
            {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_CONSUMER_KEY];
                self.consumer = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_RETAILER_KEY])
            {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_RETAILER_KEY];
                self.retailer = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_ESHOP_KEY])
            {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_ESHOP_KEY];
                self.arrCategory = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_VOUCHERS_KEY])
            {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_VOUCHERS_KEY];
                self.voucherList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_FEEDBACK_KEY])
            {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_FEEDBACK_KEY];
                self.feedback = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            if([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_LOYALTY_KEY])
            {
                NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_LOYALTY_KEY];
                self.loyalty = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            if([[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_ADD_PUBLISHER_ID_KEY])
            {
               self.addPublisherId = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_ADD_PUBLISHER_ID_KEY];
                
            }
            }
    @catch (NSException *exception) {
        
    }
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AppWiz" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AppWiz.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

-(BOOL)addProductToCart:(AAEShopProduct*)product witnQuantity:(NSString*)qty{
    for (int i = 0; i< [singleInstance.arrCartItems count]; i++) {
        AAEShopProduct *cartItem = [singleInstance.arrCartItems objectAtIndex:i];
        if (product.productId == cartItem.productId) {
            BOOL isFistOptionSame = false;
            if (cartItem.selectedOptionOne == nil || [cartItem.selectedOptionOne length]==0) {
                isFistOptionSame = false;
            }else{
                if ([cartItem.selectedOptionOne compare:product.selectedOptionOne options:NSCaseInsensitiveSearch]== NSOrderedSame) {
                    isFistOptionSame = true;
                }else{
                    isFistOptionSame = false;
                }
            }
            BOOL isSecondOptionSame = false;
            if (isFistOptionSame) {
                if (cartItem.selectedOptionTwo == nil || [cartItem.selectedOptionTwo length]==0) {
                    isSecondOptionSame = true;
                }else{
                    if ([cartItem.selectedOptionTwo compare:product.selectedOptionTwo options:NSCaseInsensitiveSearch]== NSOrderedSame) {
                        isSecondOptionSame = true;
                    }else{
                        isSecondOptionSame = false;
                    }
                }
            }
            if (isSecondOptionSame || [product.product_options count] == 0) {
                NSInteger totalQty = [qty integerValue] + [cartItem.qty integerValue];
                if (totalQty>9 ) {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Maximum 9 quantity allowed." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
                    return false;
                }
                cartItem.qty = [NSString stringWithFormat:@"%ld",(long)totalQty];
                return true;
            }
            
        }
    }
    AAEShopProduct *newProduct = [product createCopy];
    newProduct.selectedOptionOne = product.selectedOptionOne;
    newProduct.selectedOptionTwo = product.selectedOptionTwo;
    newProduct.qty = qty;
    [singleInstance.arrCartItems addObject:newProduct];
    singleInstance.discountPercent = 0;
    return true;
    
    ItemDetail *pm = [self getProductWithProductId:[NSString stringWithFormat:@"%d",product.productId]];
    if (pm != nil) {
        NSInteger totalQty = [qty integerValue] + [pm.qty integerValue];
        if (totalQty>9) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Maximum 9 quantity allowed." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
            return false;
        }
        pm.qty = [NSString stringWithFormat:@"%ld",(long)totalQty];
    }else{
        pm = (ItemDetail *)[NSEntityDescription insertNewObjectForEntityForName:@"ItemDetail"
                                                         inManagedObjectContext:self.managedObjectContext];
        pm.qty = qty;
        singleInstance.discountPercent = 0;
    }
    
    pm.productId = [NSString stringWithFormat:@"%d",product.productId];
    pm.previousProductPrice = [NSString stringWithFormat:@"%@",product.previousProductPrice];
    pm.productDescription = [NSString stringWithFormat:@"%@",product.productRating];
    pm.productShortDescription = product.productShortDescription;
    if ([product.currentProductPrice isKindOfClass:[NSString class]]) {
        pm.currentProductPrice = product.currentProductPrice;
    }else{
        pm.currentProductPrice = [NSString stringWithFormat:@"%@",product.currentProductPrice];
    }
    
    pm.productImageURLString= product.productImageURLString;
    pm.productWorkingInformation = product.productWorkingInformation;
    
    NSError *error;
    [self.managedObjectContext save:&error];
    if (error != nil) {
        return FALSE;
    }else{
        [ self calculateCartTotal];
        [self calculateCartTotalItemCount];
        return TRUE;
    }
}
-(void)calculateCartTotal{
    NSArray *allProducts = singleInstance.arrCartItems;
    float total =0.0;
    BOOL isDecimalAllowed = false;
    for (AAEShopProduct *item in allProducts){
        float unitPrice = [item.currentProductPrice floatValue];
        if (item.giftWrapOpted) {
            unitPrice += [singleInstance.retailer.gift_price floatValue];
        }
        total = total + unitPrice*[item.qty integerValue];
        if ([[AAAppGlobals sharedInstance] isHavingDecimal:item.currentProductPrice]) {
            isDecimalAllowed = true;
        }
    }
    [AAAppGlobals sharedInstance].isDecimalAllowed = isDecimalAllowed;
    float percent =  [singleInstance.discountPercent floatValue];
    if (![[AAAppGlobals sharedInstance].discountType isEqualToString:DESFAULT_DISCOUNT_TYPE]) {
        singleInstance.discountApplied = singleInstance.discountPercent;
        total =total- [[AAAppGlobals sharedInstance].discountPercent floatValue];
        if (total<0) {
            total = 0;
        }
        self.cartTotal = total;
    }else{
        
        float totalDiscount = ((float)total * percent) / 100.0;
        self.cartTotal = total-totalDiscount;
        [AAAppGlobals sharedInstance].isDecimalAllowed = true;
        singleInstance.discountApplied = [NSString stringWithFormat:@"%.2f",totalDiscount];
        }
    //self.calculateCartTotalItemCount = [NSString str] ;
    
}
-(void)calculateCartTotalItemCount{
    NSArray *allProducts = singleInstance.arrCartItems;
    NSInteger total =0;
    NSInteger totalrewards = 0;
    for (AAEShopProduct *item in allProducts){
        total = total + [item.qty integerValue];
        totalrewards += ([item.reward_points integerValue] * [item.qty integerValue]);
    }
    self.rewardsPointEarned = [NSString stringWithFormat:@"%d",totalrewards];
    self.cartTotalItemCount = total;
}
-(void)deletePoduct:(AAEShopProduct*)product{
    [singleInstance.arrCartItems removeObject:product];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
//    path = [NSString stringWithFormat:@"%@/%@.png",path,product.productId];
//    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//    [self.managedObjectContext deleteObject:product];
//    [self.managedObjectContext save:nil];
    singleInstance.discountPercent = 0;
    [ self calculateCartTotal];
    [self calculateCartTotalItemCount];
}
-(NSString*)allProductsID{
    NSArray *allProducts = [self getAllProducts];
    NSMutableString   *productsIds = nil;
    for (AAEShopProduct *item in allProducts){
        if (productsIds == nil) {
            productsIds = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%d",item.productId]];
        }else{
            [productsIds appendString:@","];
            [productsIds appendString:[NSString stringWithFormat:@"%d",item.productId]];
        }
    }
    return productsIds;
}
-(void)deleteAllProducts{
//    NSArray *allProducts = [self getAllProducts];
//    for (ItemDetail *item in allProducts){
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *path = [paths objectAtIndex:0];
//        path = [NSString stringWithFormat:@"%@/%@.png",path,item.productId];
//        [self.managedObjectContext deleteObject:item];
//    }
//    [self.managedObjectContext save:nil];
    [singleInstance.arrCartItems removeAllObjects];
    singleInstance.discountPercent = 0;
    singleInstance.rewardsPointEarned = @"0";
}
-(NSMutableArray*)getAllProducts{
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ItemDetail" inManagedObjectContext:self.managedObjectContext];
//	
//	// Setup the fetch request
//	NSFetchRequest *request = [[NSFetchRequest alloc] init];
//	[request setEntity:entity];
//	
//	// Fetch the records and handle an error
//	NSError *error;
//	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    return singleInstance.arrCartItems;
}
-(ItemDetail*)getProductWithProductId:(NSString*)productId{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ItemDetail" inManagedObjectContext:self.managedObjectContext];
	
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
    NSString *format=[NSString stringWithFormat:@"productId='%@'",productId];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
    [request setPredicate:predicate];
    
	[request setEntity:entity];
	// Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if ([mutableFetchResults count]> 0) {
        return [mutableFetchResults objectAtIndex:0];
    }
    else{
        return nil;
    }
}

-(AAEShopProduct*)cartItemWithId:(NSInteger)productId{
    AAEShopProduct *product = nil;
    for (AAEShopProduct *item in singleInstance.arrCartItems){
        if (item.productId == productId) {
            product = item;
            break;
        }
    }
    return product;
}
-(float)getImageHeight{
    float height = 200;
    CGRect frame = [UIScreen mainScreen].bounds;
    float scale = [UIScreen mainScreen].scale;
    if (frame.size.width> 320) {
        height = (frame.size.width)/DEFAULT_ASPECT_RATIO;
    }else{
        height = 200;
    }
//    NSLog(@"new height = %fx%f",frame.size.width,height);
    return height;
//    NSString *resolution = [NSString stringWithFormat:@"resolution %.0f x %.0f",frame.size.width*scale,frame.size.height*scale];
//    [[[UIAlertView alloc] initWithTitle:@"Device info" message:[NSString stringWithFormat:@"Model = %@",resolution] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
}
-(float)getImageHeightWithPadding:(CGFloat)padding{
    float height = 200;
    CGRect frame = [UIScreen mainScreen].bounds;
    float scale = [UIScreen mainScreen].scale;
    if (frame.size.width> 320) {
        height = (frame.size.width-2*padding)/DEFAULT_ASPECT_RATIO;
    }else{
        height = 200;
    }
    NSLog(@"new height = %fx%f",frame.size.width-2*padding,height);
    return height;
    //    NSString *resolution = [NSString stringWithFormat:@"resolution %.0f x %.0f",frame.size.width*scale,frame.size.height*scale];
    //    [[[UIAlertView alloc] initWithTitle:@"Device info" message:[NSString stringWithFormat:@"Model = %@",resolution] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
}
-(BOOL)isHavingDecimal:(NSString*)string{
    if (![string isKindOfClass:[NSString class]]) {
        string = [NSString stringWithFormat:@"%@",string];
    }
    BOOL isDecimalAllowed = false;
    NSRange range;
    @try {
        range = [string rangeOfString:@"."];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    if (range.location == NSNotFound){
        //[AAAppGlobals sharedInstance].isDecimalAllowed = false;
    }else{
        isDecimalAllowed = true;
    }
    return isDecimalAllowed;
}

-(void)getDateByAddingDays:(int)days{
    NSDate *today = [NSDate date];
    int onday = 24*60*60;
    NSDate *requiredDate = [today dateByAddingTimeInterval:days*onday];
    singleInstance.scheduledDate = requiredDate;
}
-(AAEarliestSchedule*)getDateByAddingDays:(int)hours andHours:(int)mins andTimeSlots:(NSArray*)timeSlots isStandardLimeLapse:(BOOL)timeLapse{
    NSDate *today = [NSDate date];
    int onday = 60*60;
    NSDate *requiredDate = [today dateByAddingTimeInterval:hours*onday];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"hh a";
    NSString *hourString = [formater stringFromDate:today];
    NSArray *compArr = [hourString componentsSeparatedByString:@" "];
    NSString *lastComp = [compArr lastObject];
    int currentHour = [[formater stringFromDate:today] intValue];
    if ([lastComp isEqualToString:@"PM"]) {
        currentHour+=12;
    }
    
    int earliestHour = currentHour+hours;
    if (earliestHour>24) {
        hours++;
        earliestHour = earliestHour - 24;
        
    }
    formater.dateFormat = @"mm";
    int earliestMin= [[formater stringFromDate:today] intValue]+mins;
    if (earliestMin>60) {
        earliestMin -= 60;
        earliestHour++;
    }
    NSMutableArray *possibleTimeSlots;
    if (!timeLapse) {
        possibleTimeSlots = [self possibleTimeSlotes:timeSlots hours:earliestHour mins:earliestMin];
        
        if (possibleTimeSlots.count ==0) {
            [possibleTimeSlots addObjectsFromArray:timeSlots];
            hours++;
        }
    }
    
    requiredDate = [today dateByAddingTimeInterval:hours*onday];
    AAEarliestSchedule *earlieastSchedule = [[AAEarliestSchedule alloc] init];
    earlieastSchedule.earliestDate = [self convertDateToString:requiredDate];
    earlieastSchedule.possibleTimeSlots = [self conver12HourFormat:possibleTimeSlots];
    
    singleInstance.scheduledDate = requiredDate;
    
    return earlieastSchedule;
}

-(NSMutableArray*)possibleTimeSlotes:(NSArray*)timeSlots hours:(int)hours mins:(int)mins{
    NSMutableArray *possibleTimeSlots = [[NSMutableArray alloc] init];
    for (NSString *timeSlot in timeSlots) {
        NSArray *slotComp = [timeSlot componentsSeparatedByString:@"-"];
        if (slotComp.count>1) {
            NSString *endComp = [slotComp objectAtIndex:1];
            NSArray *hourAndTimeComp = [endComp componentsSeparatedByString:@":"];
            if (hourAndTimeComp.count>1) {
                int hourComp = [[hourAndTimeComp objectAtIndex:0] intValue];
                if (hourComp>hours) {
                    [possibleTimeSlots addObject:timeSlot];
                }else if(hourComp == hours){
                    int minComp = [[hourAndTimeComp objectAtIndex:1] intValue];
                    if (minComp>=mins) {
                      [possibleTimeSlots addObject:timeSlot];
                    }
                }
            }
        }
    }
    return  possibleTimeSlots;
}
-(NSMutableArray*)conver12HourFormat:(NSArray*)timeSlots{
    NSMutableArray *possibleTimeSlots = [[NSMutableArray alloc] init];
    @try {
        for (NSString *timeSlot in timeSlots) {
            NSString *formatedSlot = @"";
            NSArray *slotComp = [timeSlot componentsSeparatedByString:@"-"];
            for (int i = 0;i<[slotComp count];i++) {
                NSString *slot = [slotComp objectAtIndex:i];
                NSArray *hourAndTimeComp = [slot componentsSeparatedByString:@":"];
                int hourComp = [[hourAndTimeComp objectAtIndex:0] intValue];
                NSString *meridian = @"AM";
                if (hourComp>12) {
                    hourComp -=12;
                    meridian = @"PM";
                }else if(hourComp == 12){
                    meridian = @"PM";
                }
                NSString *hourPrefix = @"";
                if (hourComp<10) {
                    hourPrefix = @"0";
                }
                if (i == 0) {
                   formatedSlot = [NSString stringWithFormat:@"%@%d:%@%@-",hourPrefix,hourComp,[hourAndTimeComp objectAtIndex:1],meridian];
                }else{
                    formatedSlot = [formatedSlot stringByAppendingString:[NSString stringWithFormat:@"%@%d:%@%@",hourPrefix,hourComp,[hourAndTimeComp objectAtIndex:1],meridian]];
                }
                
            }
            [possibleTimeSlots addObject:formatedSlot];
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return  possibleTimeSlots;
}
-(NSString*)convertDateToString:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-YYYY"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
-(NSString*)getPriceStrfromFromPrice:(float)price{
    NSString* pricestr = [NSString stringWithFormat:@"%.0f",price];
    if ([pricestr length]<7) {
        return [NSString stringWithFormat:@"%.2f",price];
    }else{
        return [NSString stringWithFormat:@"%.0f",price];
    }
}
@end
