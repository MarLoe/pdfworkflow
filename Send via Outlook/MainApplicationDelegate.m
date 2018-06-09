//
//  MainApplicationDelegate.m
//  Test
//
//  Created by Martin Løbger on 04/06/2018.
//  Copyright © 2018 ML-Consulting. All rights reserved.
//

#import "MainApplicationDelegate.h"

@interface MainApplicationDelegate ()

@end

@implementation MainApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
    // Intercept command line arguments - and do nothing
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
