//
//  Mechanism.h
//  VerifyAuthPlugin
//
//  Created by Pushpraj Singh on 11/06/23.
//

#import <Foundation/Foundation.h>
#import "AuthorizationPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface Mechanism : NSObject

/**
 *  Checks to make sure the Mechanism is valid
 *
 *  @param mechanism MechanismRecord
 *
 *  @return BOOL
 */
+ (BOOL) MechanismValid:(const MechanismRecord *)mechanism;


/**
 *  Gets the authenticating username
 *
 *  @param inMechanism AuthorizationMechanismRef
 *
 *  @return NSString
 */
+ (NSString *)getUserName:(AuthorizationMechanismRef)inMechanism;


@end

NS_ASSUME_NONNULL_END
