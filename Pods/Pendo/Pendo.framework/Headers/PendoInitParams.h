
#import <Foundation/Foundation.h>

@interface PendoInitParams : NSObject

/** @brief The visitor's id */
@property (nonatomic, copy, nullable) NSString *visitorId;

/** @brief The account's id */
@property (nonatomic, copy, nullable) NSString *accountId;

/** @brief The data that are used by Pendo Mobile visitor level data. */
@property (nonatomic, copy, nullable) NSDictionary *visitorData;

/** @brief the data that are used by Pendo Mobile for account level data. */
@property (nonatomic, copy, nullable) NSDictionary *accountData;

@end
