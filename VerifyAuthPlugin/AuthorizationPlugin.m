//
//  AuthorizationPlugin.m
//  VerifyAuthPlugin
//
//  Created by Pushpraj Singh on 09/06/23.
//

#import "AuthorizationPlugin.h"

AuthorizationPlugin *authorizationPlugin = nil;

static OSStatus PluginDestroy(AuthorizationPluginRef inPlugin) {
    return [authorizationPlugin PluginDestroy:inPlugin];
}

static OSStatus MechanismCreate(AuthorizationPluginRef inPlugin,
                                AuthorizationEngineRef inEngine,
                                AuthorizationMechanismId mechanismId,
                                AuthorizationMechanismRef *outMechanism) {
    return [authorizationPlugin MechanismCreate:inPlugin
                                      EngineRef:inEngine
                                    MechanismId:mechanismId
                                   MechanismRef:outMechanism];
}

static OSStatus MechanismInvoke(AuthorizationMechanismRef inMechanism) {
    return [authorizationPlugin MechanismInvoke:inMechanism];
}

static OSStatus MechanismDeactivate(AuthorizationMechanismRef inMechanism) {
    return [authorizationPlugin MechanismDeactivate:inMechanism];
}

static OSStatus MechanismDestroy(AuthorizationMechanismRef inMechanism) {
    return [authorizationPlugin MechanismDestroy:inMechanism];
}

static AuthorizationPluginInterface gPluginInterface = {
    kAuthorizationPluginInterfaceVersion,
    &PluginDestroy,
    &MechanismCreate,
    &MechanismInvoke,
    &MechanismDeactivate,
    &MechanismDestroy
};

extern OSStatus AuthorizationPluginCreate(const AuthorizationCallbacks
                                          *callbacks,
                                          AuthorizationPluginRef *outPlugin,
                                          const AuthorizationPluginInterface
                                          **outPluginInterface) {
    
    if (authorizationPlugin == nil) {
        authorizationPlugin = [[AuthorizationPlugin alloc] init];
    }
    
    return [authorizationPlugin AuthorizationPluginCreate:callbacks
                                                PluginRef:outPlugin
                                          PluginInterface:outPluginInterface];
}


@implementation AuthorizationPlugin
- (BOOL)MechanismValid:(const MechanismRecord *)mechanism {
    return (mechanism != NULL)
    && (mechanism->fMagic == kMechanismMagic)
    && (mechanism->fEngine != NULL)
    && (mechanism->fPlugin != NULL);
}

- (OSStatus)MechanismCreate:(AuthorizationPluginRef)inPlugin
                   EngineRef:(AuthorizationEngineRef)inEngine
                 MechanismId:(AuthorizationMechanismId)mechanismId
                MechanismRef:(AuthorizationMechanismRef *)outMechanism {
    
    OSStatus            err;
    PluginRecord *      plugin;
    MechanismRecord *   mechanism;
    
    plugin = (PluginRecord *) inPlugin;
    assert([self PluginValid:plugin]);
    assert(inEngine != NULL);
    assert(mechanismId != NULL);
    assert(outMechanism != NULL);
    
    err = noErr;
    mechanism = (MechanismRecord *) malloc(sizeof(*mechanism));
    if (mechanism == NULL) {
        err = memFullErr;
    }
    
    if (err == noErr) {
        mechanism->fMagic = kMechanismMagic;
        mechanism->fEngine = inEngine;
        mechanism->fPlugin = plugin;
       // mechanism->fAddUsers = (strcmp(mechanismId, "add-users") == 0);
        mechanism->fStopAdminLogin = (strcmp(mechanismId, "StopAdminLogin") == 0);
        mechanism->fLogHappenings = (strcmp(mechanismId, "LogHappenings") == 0);
    }
    
    *outMechanism = mechanism;
    
    assert( (err == noErr) == (*outMechanism != NULL) );
    
    return err;

}

- (OSStatus)MechanismInvoke:(AuthorizationMechanismRef)inMechanism {
    
    OSStatus                    err;
    MechanismRecord *           mechanism;
    
    mechanism = (MechanismRecord *) inMechanism;
    assert([self MechanismValid:mechanism]);

    
#pragma mark
#pragma mark AddUsers Mech
    
//    if (mechanism->fAddUsers) {
//        FV2AuthPluginMechanism *fV2AuthPluginMechanism =
//        [[FV2AuthPluginMechanism alloc]
//         initWithMechanism:mechanism];
//        [fV2AuthPluginMechanism runMechanism];
//    }
    
    err = mechanism->fPlugin->fCallbacks->SetResult(mechanism->fEngine,
                                                    kAuthorizationResultAllow);
    return err;
    
}

- (OSStatus)MechanismDeactivate:(AuthorizationMechanismRef)inMechanism {
    OSStatus            err;
    MechanismRecord *   mechanism;
    
    mechanism = (MechanismRecord *) inMechanism;
    assert([self MechanismValid:mechanism]);
    
    err = mechanism->fPlugin->fCallbacks->DidDeactivate(mechanism->fEngine);
    
    return err;
}

- (OSStatus)MechanismDestroy:(AuthorizationMechanismRef)inMechanism {
    MechanismRecord *   mechanism;
    
    mechanism = (MechanismRecord *) inMechanism;
    assert([self MechanismValid:mechanism]);
    
    free(mechanism);
    
    return noErr;

}

- (OSStatus)PluginDestroy:(AuthorizationPluginRef)inPlugin {
    PluginRecord *  plugin;
    
    plugin = (PluginRecord *) inPlugin;
    assert([self PluginValid:plugin]);
    
    free(plugin);
    
    return noErr;
}


- (BOOL)PluginValid:(const PluginRecord *)plugin {
    return (plugin != NULL)
    && (plugin->fMagic == kPluginMagic)
    && (plugin->fCallbacks != NULL)
    && (plugin->fCallbacks->version >= kAuthorizationCallbacksVersion);
}

- (OSStatus)AuthorizationPluginCreate:(const AuthorizationCallbacks *)callbacks
                             PluginRef:(AuthorizationPluginRef *)outPlugin
                       PluginInterface:(const AuthorizationPluginInterface **)
outPluginInterface {
    
    OSStatus        err;
    PluginRecord *  plugin;
    
    assert(callbacks != NULL);
    assert(callbacks->version >= kAuthorizationCallbacksVersion);
    assert(outPlugin != NULL);
    assert(outPluginInterface != NULL);
    
    // Create the plugin.
    err = noErr;
    plugin = (PluginRecord *) malloc(sizeof(*plugin));
    if (plugin == NULL) {
        err = memFullErr;
    }
    
    // Fill it in.
    if (err == noErr) {
        plugin->fMagic     = kPluginMagic;
        plugin->fCallbacks = callbacks;
    }
    
    *outPlugin = plugin;
    *outPluginInterface = &gPluginInterface;
    
    assert( (err == noErr) == (*outPlugin != NULL) );
    
    return err;
    
}



@end
