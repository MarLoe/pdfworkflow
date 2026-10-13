//
//  main.m
//  Send via Outlook
//
//  Created by Martin Løbger on 14/05/2018.
//  Copyright © 2018 ML-Consulting. All rights reserved.
//

@import Foundation;
@import AppKit; // NSWorkspace
@import os.log;

//#include <cups/cups.h>   // link against libcups.tbd

//static NSDictionary<NSString *, NSString *> *ParseCUPSOptions(NSString *string)
//{
//    cups_option_t *options = NULL;
//    int count = cupsParseOptions(string.UTF8String, 0, &options);
//
//    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:count];
//    for (int i = 0; i < count; i++) {
//        NSString *key   = [NSString stringWithUTF8String:options[i].name];
//        NSString *value = [NSString stringWithUTF8String:options[i].value ?: ""];
//        if (key && value) {
//            result[key] = value;
//        }
//    }
//    cupsFreeOptions(count, options);
//    return result;
//}
//
int main(int argc, const char* argv[])
{
    if (argc <= 3)
    {
        
        printf("The number of parameters are incorrect.\nUsage: tool title options pdffile");
        return 1;
    }
    
    NSString* paramTitle = [NSString stringWithUTF8String:argv[1]];
    NSString* paramOptions = [NSString stringWithUTF8String:argv[2]];
    NSString* paramFilePath = [NSString stringWithUTF8String:argv[3]];
    
    os_log(OS_LOG_DEFAULT, "SEND VIA OUTLOOK:\n\tTitle: %{public}@\n\tFilepath: %{public}@\n\tOptions: %{public}@", paramTitle, paramFilePath, paramOptions);
//    if (paramOptions.length > 0) {
//        NSDictionary<NSString *, NSString *> *options = ParseCUPSOptions(paramOptions);
//        [options enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
//            os_log(OS_LOG_DEFAULT, "%{public}@ = %{public}@", key, value);
//        }];
//    }

    
////    NSURL *appURL = [NSURL fileURLWithPath:@"/Users/ml/Library/PDF Services/Send via Outlook.pdfworkflow"];
//    NSURL *appURL = [NSURL fileURLWithPath:@"/Users/ml/Library/PDF Services/Send via Outlook.pdfworkflow/Contents/MacOS/Send via Outlook"];
////    NSURL *appURL = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:@"com.apple.TextEdit"];
//
//    NSWorkspaceOpenConfiguration *config = [NSWorkspaceOpenConfiguration configuration];
//    config.arguments = @[paramTitle, paramOptions, paramFilePath];
//    config.createsNewApplicationInstance = YES; // optional: arguments are ignored if the app is already running
//
//    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
//    __block NSRunningApplication *launchedApp = nil;
//    __block NSError *launchError = nil;
//
//    [[NSWorkspace sharedWorkspace] openApplicationAtURL:appURL
//                                          configuration:config
//                                      completionHandler:^(NSRunningApplication *app, NSError *error) {
//        launchedApp = app;
//        launchError = error;
//        dispatch_semaphore_signal(sem);
//    }];
//    
//
//    dispatch_semaphore_wait(sem, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC)); // with timeout
//
//    if (launchError) {
//        os_log(OS_LOG_DEFAULT, "Launch failed: %{public}@", launchError);
//    }

//    NSTask *task = [[NSTask alloc] init];
//    task.executableURL = [NSURL fileURLWithPath:@"/Users/ml/Library/PDF Services/Send via Outlook.pdfworkflow/Contents/MacOS/Send via Outlook"];
////    task.executableURL = [NSURL fileURLWithPath:@"/Users/ml/Library/PDF Services/Send via Outlook.app"];
//    task.arguments = @[paramTitle, paramOptions, paramFilePath];
//
//    NSError *error = nil;
//    if (![task launchAndReturnError:&error]) {
//        os_log(OS_LOG_DEFAULT, "Launch failed: %{public}@", error);
//        return 2;
//    }
//    
//    [task waitUntilExit];

    
    
    
    
    
    NSURL *pdf = [NSURL fileURLWithPath:paramFilePath];
//    NSURL *helper = [NSURL fileURLWithPath:@"/Applications/Send via Outlook Helper.app"];
    NSURL *helper = [NSURL fileURLWithPath:@"/Users/ml/Library/PDF Services/Helpers/Send via Outlook - helper.app"];
//    NSURL *helper = [NSURL fileURLWithPath:@"/Users/ml/Library/PDF Services/Send via Outlook.pdfworkflow/Contents/MacOS/Send via Outlook"];

    NSWorkspaceOpenConfiguration *config = [NSWorkspaceOpenConfiguration configuration];
    config.arguments = @[paramTitle, paramOptions, paramFilePath];   // optional: pass the title along

    dispatch_semaphore_t done = dispatch_semaphore_create(0);
    [[NSWorkspace sharedWorkspace] openURLs:@[pdf]
                       withApplicationAtURL:helper
                              configuration:config
                          completionHandler:^(NSRunningApplication *app, NSError *error) {
        if (error) {
            os_log_error(OS_LOG_DEFAULT, "Hand-off failed: %{public}@", error);
        }
        dispatch_semaphore_signal(done);
    }];
    dispatch_semaphore_wait(done, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    
    
    return 0;
}
