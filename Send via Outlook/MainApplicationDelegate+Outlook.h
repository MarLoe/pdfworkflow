//
//  MainApplicationDelegate+Outlook.h
//  Send via Outlook
//
//  Created by Martin Løbger on 14/10/2026.
//  Copyright © 2026 ML-Consulting. All rights reserved.
//

#import "MainApplicationDelegate.h"

@interface MainApplicationDelegate (Outlook)

/// Sends the given file as an attachment via Microsoft Outlook using the bundled "Send" AppleScript.
/// Returns 0 on success, or a non-zero exit code describing the failure.
- (int)sendToOutlook:(NSString* __nonnull)file withTitle:(NSString* __nullable)title andOptions:(NSString* __nullable)options;

@end
