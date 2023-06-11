//
//  PromptWindowController.h
//  VerifyAuthPlugin
//
//  Created by Pushpraj Singh on 11/06/23.
//

#import <Cocoa/Cocoa.h>
#include <Security/AuthorizationPlugin.h>


NS_ASSUME_NONNULL_BEGIN

@interface PromptWindowController : NSWindowController <NSWindowDelegate> {
    void *mMechanismRef;
}

- (void)setRef:(void *)ref;

/**
 *  Default window method
 */
- (void) awakeFromNib;

@property (nonatomic, strong) NSSound *tts;
@property (nonatomic) BOOL isWarned;
@property (weak) IBOutlet NSTextField *textTitle;
@property (weak) IBOutlet NSTextField *textSubTitle;
@property (weak) IBOutlet NSTextField *textInstructions;
@property (weak) IBOutlet NSTextField *textHelpDesk;
@property (weak) IBOutlet NSTextField *textAction;
@property (weak) IBOutlet NSWindow *backdropWindow;
@property (weak) IBOutlet NSButton *okayButtonOutlet;

- (IBAction)okayButton:(id)sender;


@end

NS_ASSUME_NONNULL_END
