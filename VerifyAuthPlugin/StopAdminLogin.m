//
//  StopAdminLogin.m
//  VerifyAuthPlugin
//
//  Created by Pushpraj Singh on 11/06/23.
//

#import "StopAdminLogin.h"

@implementation StopAdminLogin

+ (OSStatus) runMechanism:(AuthorizationMechanismRef)inMechanism {
    NSLog(@"VerifyAuth:StopAdminLogin *************************************");
    
    OSStatus                    err = 0;
    MechanismRecord *           mechanism;
    
    NSLog(@"VerifyAuth:StopAdminLogin: inMechanism=%p", inMechanism);
    
    mechanism = (MechanismRecord *) inMechanism;
    assert([Mechanism MechanismValid:mechanism]);
    
    NSString *userName = NULL;
    
    // Get username
    userName = [Mechanism getUserName:inMechanism];
    if (userName == NULL) {
        NSLog(@"VerifyAuth:StopAdminLogin:UserPrompts [!] Failed to retrieve the User Name. Failing Open.");
        err = mechanism->fPlugin->fCallbacks->SetResult(mechanism->fEngine, kAuthorizationResultAllow);
        NSLog(@"VerifyAuth:StopAdminLogin: err=%ld", (long) err);
        return err;
    }
    
    NSLog(@"VerifyAuth:StopAdminLogin: Checking Username for admin");
    if ([userName rangeOfString:@"admin"].location != NSNotFound) {
        // Launch PromptWindow
        NSLog(@"VerifyAuth:StopAdminLogin:Calling initializePromptWindowController");
        initializePromptWindowController(inMechanism, FALSE);
        
        //Stop the login
        NSLog(@"VerifyAuth:StopAdminLogin: Username did contain admin. Stopping the login.");
        err = mechanism->fPlugin->fCallbacks->SetResult(mechanism->fEngine, kAuthorizationResultDeny);
        NSLog(@"VerifyAuth:StopAdminLogin: err=%ld", (long) err);
        return err;
    }
    
    NSLog(@"VerifyAuth:StopAdminLogin: Username did not contain admin. Allowing the login.");
    return err;
}


@end
