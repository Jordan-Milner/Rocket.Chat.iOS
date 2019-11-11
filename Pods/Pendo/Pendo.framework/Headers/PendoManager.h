//
//  PendoManager.h
//  Pendo
//

#import <Foundation/Foundation.h>

@class PendoInitParams;

NS_ASSUME_NONNULL_BEGIN

/**
 *  The SDK will post the following notifications on initialization.
 *  The notifications are posted to the main thread
 *
 *  This notification is sent out after the SDK has successfully initialized
 */
extern NSString *const kIIODidSuccessfullyInitializeSDKNotification;

/**
 *  This notification is sent out when an error occurs during initialization of the SDK
 */
extern NSString *const kIIOErrorInitializeSDKNotification;

/**
 *  PendoManager. Handles initialization of the Pendo Mobile SDK.
 */
@interface PendoManager : NSObject

/**
 * The app key used when initializing the SDK.
 */
@property(nonatomic, readonly) NSString *appKey;

/**
 *  Provide visitor data to the Pendo Mobile SDK.
 */
@property(nonatomic, strong, readonly, nullable) NSMutableDictionary *visitorData;

/**
 *  Provide account data to the Pendo Mobile SDK.
 */
@property(nonatomic, strong, readonly, nullable) NSMutableDictionary *accountData;

/**
 *  Provide a visitor id to the Pendo Mobile SDK.
 */
@property(nonatomic, strong, readonly, nullable) NSString *visitorId;

/**
 *  Provide a account id to the Pendo Mobile SDK.
 */
@property(nonatomic, strong, readonly, nullable) NSString *accountId;

/**
 *  The internal device ID used by the Pendo Mobile SDK. This value will not change if setting a visitor id.
 */
@property(nonatomic, readonly) NSString *pendoDeviceUserId;


#pragma mark - Initializer

/**
 *  Use [PendoManager sharedManager] instead
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  The shared instance of the PendoManager
 */
+ (instancetype)sharedManager;

/**
 *  Call this method on the sharedManger with your application key.
 *
 *  @param appKey The app key for your account
 *  @param initParams @code(nullable)@endcode Extra initialize parameters (e.g. account id, visitor id...).
 */
- (void)initSDK:(nonnull NSString *)appKey initParams:(nullable PendoInitParams *)initParams;

/**
 *  Called from your app delegate when launched from a deep link containing an Pendo Mobile pairing URL
 *  @warning This method should always be called after initSDK: with your application key
 *  @param url The pairing URL
 */
- (void)initWithUrl:(nonnull NSURL *)url;

#pragma mark - Visitor

/**
 * Must be called <b>after</b> the SDK was initialized.
 * @brief Clears the current visitor.
 */
- (void)clearVisitor;

/**
 * Must be called <b>after</b> the SDK was initialized.
 *
 * @brief Switch to a new visitor.
 *
 * @param visitorId The visitor's ID.
 * @param accountId The account's ID.
 * @param visitorData The visitor's data.
 * @param accountData The account's data.
 */
- (void)switchVisitor:(nullable NSString *)visitorId
            accountId:(nullable NSString *)accountId
          visitorData:(nullable NSDictionary *)visitorData
          accountData:(nullable NSDictionary *)accountData;

/**
 * Set a visitor data value for a given data name.
 * This data is used by Pendo Mobile for creating audiences or reporting analytics.
 * For instance you might want to provide data on the visitor's age or if the visitor is logged into a service.
 * @code
 * [[PendoManager sharedManager] setVisitorData:@(YES) forKey:@"LoggedIn"]
 * @endcode
 * You can provide multiple visitor data to the initSDK method call or supply a dictionary of data.
 * @code
 * [PendoManager sharedManager].visitorData = @{@"key1" :@"value1", ...};
 * @endcode
 *
 * @param dataValue The data value.
 * @param dataKey The data key.
 */
- (void)setVisitorDataValue:(nonnull NSString *)dataValue forKey:(nonnull NSString *)dataKey;

/**
 * Set a account data value for a given data name.
 * This data is used by Pendo Mobile for creating audiences or reporting analytics.
 * For instance you might want to provide data on the account's subscription or if the account is active or not.
 * @code
 * [[PendoManager sharedManager] setAccountData:@(YES) forKey:@"isPro"]
 * @endcode
 * You can provide multiple account data to the initSDK method call or supply a dictionary of data.
 * @code
 * [PendoManager sharedManager].accountData = @{@"key1" :@"value1", ...};
 * @endcode
 *
 * @param dataValue The data value.
 * @param dataKey The data key.
 */
- (void)setAccountDataValue:(nonnull NSString *)dataValue forKey:(nonnull NSString *)dataKey;

/**
 * Returns the visitor data value for a given key.
 *
 * @param dataKey The data key.
 * @return The data value for the given key.
 */
- (nullable NSString *)visitorDataValueForKey:(nonnull NSString *)dataKey;

/**
 * Returns the account data value for a given key.
 *
 * @param dataKey The data key.
 * @return The data value for the given key.
 */
- (nullable NSString *)accountDataValueForKey:(nonnull NSString *)dataKey;

#pragma mark - Track

/**
 * When your application needs to send additional events about actions your users perform.
 *
 * @param event The event name describing the user’s action.
 * @param properties dictionary of event properties (optional).
 * @brief Queue a track eventsfor transmission, optionally including properties as the payload of the event.
 */
- (void)track:(nonnull NSString *)event properties:(nullable NSDictionary *)properties;

@end

NS_ASSUME_NONNULL_END


