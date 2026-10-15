//
//  MainApplicationDelegate.m
//  Test
//
//  Created by Martin Løbger on 04/06/2018.
//  Copyright © 2018 ML-Consulting. All rights reserved.
//

@import os.log;
#import "MainApplicationDelegate.h"


@implementation MainApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    os_log_debug(OS_LOG_DEFAULT, "SVO: filePath: %{public}@", self.fileURL);

    if (self.fileURL != nil) {
        NSURL *paramsURL = [self.fileURL URLByAppendingPathExtension:@"plist"];
        NSDictionary *parameters = [NSDictionary dictionaryWithContentsOfURL:paramsURL error:nil];
        os_log_debug(OS_LOG_DEFAULT, "SVO: parameters: %{public}@", parameters);
        
        [NSFileManager.defaultManager removeItemAtURL:paramsURL error:nil];
        
        NSString *fileName = self.fileURL.lastPathComponent;
        NSString *baseName = fileName.stringByDeletingPathExtension;

        NSString *title = parameters[@"title"];
        if (!title || [title isEqualToString:fileName] || [title isEqualToString:baseName]) {
            title = [NSString stringWithFormat:NSLocalizedString(@"message.subject", -), fileName];
        }

        [self updatePDFURL:self.fileURL withAuthor:NSFullUserName()];
        [self sendToOutlook:self.fileURL.path withTitle:title andOptions:parameters];
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
