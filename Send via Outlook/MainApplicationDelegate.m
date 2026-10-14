//
//  MainApplicationDelegate.m
//  Test
//
//  Created by Martin Løbger on 04/06/2018.
//  Copyright © 2018 ML-Consulting. All rights reserved.
//

@import os.log;
#import "MainApplicationDelegate.h"
#import "alert.h"

#ifndef kASAppleScriptSuite
#define kASAppleScriptSuite 'ascr'
#endif

#ifndef kASSubroutineEvent
#define kASSubroutineEvent  'psbr'
#endif

#ifndef keyASSubroutineName
#define keyASSubroutineName 'snam'
#endif

@interface MainApplicationDelegate ()

@end

@implementation MainApplicationDelegate

- (int)sendToOutlook:(NSString*)file withTitle:(NSString*)title andOptions:(NSString*)options
{
    os_log_debug(OS_LOG_DEFAULT, "SVO: %{public}@", file);

    char resolved[PATH_MAX] = {0};
    char* result = realpath([[file stringByStandardizingPath] UTF8String], resolved); // TODO: Check result (e.g. errno == ENOENT)
    if (strlen(resolved) > 0)
    {
        file = [NSString stringWithUTF8String:resolved];
    }
    if (result == NULL)
    {
        if (errno == ENOENT)
        {
            show_error(NSLocalizedString(@"alert.title", -),  [NSString stringWithFormat:NSLocalizedString(@"alert.message.filenotfound", -), file]);
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
        [parameters insertDescriptor:[NSAppleEventDescriptor descriptorWithString:title] atIndex:1];
        [parameters insertDescriptor:[NSAppleEventDescriptor descriptorWithString:file] atIndex:2];
        
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
            os_log(OS_LOG_DEFAULT, "SEND VIA OUTLOOK: %{public}@", errorDict);
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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    os_log_debug(OS_LOG_DEFAULT, "SVO: filePath: %{public}@", self.fileURL);

    if (self.fileURL != nil) {
        NSURL *paramsURL = [self.fileURL URLByAppendingPathExtension:@"plist"];
        NSDictionary *parameters = [NSDictionary dictionaryWithContentsOfURL:paramsURL error:nil];
        os_log_debug(OS_LOG_DEFAULT, "SVO: parameters: %{public}@", parameters);
        
        [NSFileManager.defaultManager removeItemAtURL:paramsURL error:nil];

        [self sendToOutlook:self.fileURL.path withTitle:@"" andOptions:@""];
    }
    
    [NSApp terminate:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

- (void)application:(NSApplication *)sender openURLs:(NSArray<NSURL *> *)urls
{
    for (NSURL *url in urls) {
        os_log_debug(OS_LOG_DEFAULT, "SVO: PDF File: %{public}@", url.absoluteString);
        if (url.isFileURL) {
            self.fileURL = url;
        }
    }
}

@end
