//
//  main.m
//  Send via Outlook
//
//  Created by Martin Løbger on 14/05/2018.
//  Copyright © 2018 ML-Consulting. All rights reserved.
//

@import Foundation;
@import AppKit;
#include "MainApplication.h"
#include "MainApplicationDelegate.h"


#ifndef kASAppleScriptSuite
#define kASAppleScriptSuite 'ascr'
#endif

#ifndef kASSubroutineEvent
#define kASSubroutineEvent  'psbr'
#endif

#ifndef keyASSubroutineName
#define keyASSubroutineName 'snam'
#endif

NSModalResponse show_alert(NSString* title, NSString* message, NSAlertStyle alertStyle)
{
    NSAlert* alert = [[NSAlert alloc] init];
    alert.messageText = title;
    alert.informativeText = message;
    alert.alertStyle = alertStyle;
    NSLog(@"%@", alert.icon);
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

NSModalResponse show_config()
{
    // As we are running as a command line tool,
    // we need to do everything our selfs.
    MainApplicationDelegate* delegate = [[MainApplicationDelegate alloc] init];
    MainApplication* app = [MainApplication sharedApplication];
    app.delegate = delegate;
    
    NSStoryboard* storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSWindowController* initial = [storyBoard instantiateInitialController];
    [initial.window center];
    [initial.window makeKeyAndOrderFront:nil];
    
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    [NSApp activateIgnoringOtherApps:YES];
    
    [app run];
    
    return NSModalResponseOK; // NSModalResponseCancel
}

int main(int argc, const char* argv[])
{
    if (argc <= 3)
    {
        show_error(NSLocalizedString(@"alert.title", -), NSLocalizedString(@"alert.message.parameters", -));
        return 1;
    }
    
    NSString* paramTitle = [NSString stringWithUTF8String:argv[1]];
    // NOTE: Not using options (yet): NSString* paramOptions = [NSString stringWithUTF8String:argv[2]];
    NSString* paramFilePath = [NSString stringWithUTF8String:argv[3]];
    
    char resolved[PATH_MAX] = {0};
    char* result = realpath([[paramFilePath stringByStandardizingPath] UTF8String], resolved); // TODO: Check result (e.g. errno == ENOENT)
    if (strlen(resolved) > 0)
    {
        paramFilePath = [NSString stringWithUTF8String:resolved];
    }
    if (result == NULL)
    {
        if (errno == ENOENT)
        {
            show_error(NSLocalizedString(@"alert.title", -),  [NSString stringWithFormat:NSLocalizedString(@"alert.message.filenotfound", -), paramFilePath]);
            return 2;
        }
        return 3;
    }
    
    NSDictionary* errorDict;
    NSURL* sendScriptUrl = [[NSBundle mainBundle] URLForResource:@"Send" withExtension:@"scpt" subdirectory:@"Scripts"];
    NSAppleScript* appleScript = [[NSAppleScript alloc] initWithContentsOfURL:sendScriptUrl error:&errorDict];
    if (appleScript != nil)
    {
        // Create and populate the list of parameters
        NSAppleEventDescriptor* parameters = [NSAppleEventDescriptor listDescriptor];
        [parameters insertDescriptor:[NSAppleEventDescriptor descriptorWithString:paramTitle] atIndex:1];
        [parameters insertDescriptor:[NSAppleEventDescriptor descriptorWithString:paramFilePath] atIndex:2];
        
        // Create the AppleEvent target
        ProcessSerialNumber psn = {0, kCurrentProcess};
        NSAppleEventDescriptor* target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber
                                                                                        bytes:&psn
                                                                                       length:sizeof(ProcessSerialNumber)];
        
        // Create an NSAppleEventDescriptor with the script's method name to call,
        // this is used for the script statement: "on send_pdf(subjectText, filePath)".
        // Note that the routine name must be in lower case.
        NSAppleEventDescriptor* handler = [NSAppleEventDescriptor descriptorWithString:[@"send_pdf" lowercaseString]];
        
        // create the event for an AppleScript subroutine,
        // set the method name and the list of parameters
        NSAppleEventDescriptor* event = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
                                                                                 eventID:kASSubroutineEvent
                                                                        targetDescriptor:target
                                                                                returnID:kAutoGenerateReturnID
                                                                           transactionID:kAnyTransactionID];
        [event setParamDescriptor:handler forKeyword:keyASSubroutineName];
        [event setParamDescriptor:parameters forKeyword:keyDirectObject];
        
        // call the event in AppleScript
        if (![appleScript executeAppleEvent:event error:&errorDict])
        {
            NSLog(@"ERROR: %@", errorDict);
            // report any errors from 'errors'
            NSString* errorMessage = errorDict[NSAppleScriptErrorMessage];
            if (errorMessage != nil)
            {
                show_error(NSLocalizedString(@"alert.title", -), errorMessage);
                return 5;
            }
        }
    }
    
    return 0;
}
