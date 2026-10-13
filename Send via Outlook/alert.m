//
//  alert.h
//  Send via Outlook
//
//  Created by Martin Løbger on 13/10/2026.
//  Copyright © 2026 ML-Consulting. All rights reserved.
//

@import AppKit;

#import "alert.h"


NSModalResponse show_info(NSString* title, NSString* message)
{
    return show_alert(title, message, NSAlertStyleInformational);
}

NSModalResponse show_warn(NSString* title, NSString* message)
{
    return show_alert(title, message, NSAlertStyleInformational);
}

NSModalResponse show_error(NSString* title, NSString* errorMessage)
{
    return show_alert(title, errorMessage, NSAlertStyleCritical);
}

NSModalResponse show_alert(NSString* title, NSString* message, NSAlertStyle alertStyle)
{
    NSAlert* alert = [[NSAlert alloc] init];
    alert.messageText = title;
    alert.informativeText = message;
    alert.alertStyle = alertStyle;
    NSLog(@"SEND VIA OUTLOOK: %@", alert.icon);
    if ([[NSBundle mainBundle] bundleIdentifier] == nil)
    {
        // We are running as a command line tool - we need to load icon manually
        NSURL* appIconUrl = [[NSBundle mainBundle] URLForResource:@"AppIcon" withExtension:@"icns"];
        alert.icon = [[NSImage alloc] initWithContentsOfURL:appIconUrl];
    }
    
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    [NSApp activateIgnoringOtherApps:YES];
    
    return [alert runModal];
}

