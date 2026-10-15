//
//  MainApplicationDelegate.h
//  Test
//
//  Created by Martin Løbger on 04/06/2018.
//  Copyright © 2018 ML-Consulting. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainApplicationDelegate : NSObject <NSApplicationDelegate>

@property (nullable, strong) NSURL* fileURL;

@end


@interface MainApplicationDelegate (Outlook)

/// Sends the given file as an attachment via Microsoft Outlook using the bundled "Send" AppleScript.
/// Returns 0 on success, or a non-zero exit code describing the failure.
- (int)sendToOutlook:(NSString* __nonnull)file withTitle:(NSString* __nullable)title andOptions:(NSDictionary* __nullable)options;

@end
