//
//  BorderlessWindow.h
//  VerifyAuthPlugin
//
//  Created by Pushpraj Singh on 11/06/23.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface BorderlessWindow : NSWindow

- (id) initWithContentRect:(NSRect)contentRect
                 styleMask:(unsigned int)aStyle
                   backing:(NSBackingStoreType)bufferingType
                     defer:(BOOL)flag;


@end

NS_ASSUME_NONNULL_END
