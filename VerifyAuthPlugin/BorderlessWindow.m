//
//  BorderlessWindow.m
//  VerifyAuthPlugin
//
//  Created by Pushpraj Singh on 11/06/23.
//

#import "BorderlessWindow.h"

@implementation BorderlessWindow

- (id) initWithContentRect:(NSRect)contentRect
                 styleMask:(unsigned int)aStyle
                   backing:(NSBackingStoreType)bufferingType
                     defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect
                            styleMask:NSWindowStyleMaskBorderless
                              backing:bufferingType
                                defer:flag];
    return self;
}


@end
