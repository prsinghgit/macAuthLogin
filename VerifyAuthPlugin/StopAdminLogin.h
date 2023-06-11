//
//  StopAdminLogin.h
//  VerifyAuthPlugin
//
//  Created by Pushpraj Singh on 11/06/23.
//

#import <Foundation/Foundation.h>
#import "Mechanism.h"
#import "AuthorizationPlugin.h"
//#import "PromptWindowController.h"


NS_ASSUME_NONNULL_BEGIN

OSStatus initializePromptWindowController(AuthorizationMechanismRef inMechanism, BOOL isWarning);


@interface StopAdminLogin : NSObject

+ (OSStatus) runMechanism:(AuthorizationMechanismRef)inMechanism;


@end

NS_ASSUME_NONNULL_END
