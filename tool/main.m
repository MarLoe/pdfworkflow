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


static void StoreTyped(NSMutableDictionary *result, NSString *key, NSString *value) {
    if ([key hasSuffix:@"..n."]) {
        result[[key substringToIndex:key.length - 4]] = @(value.longLongValue);
    } else if ([key hasSuffix:@"..b."]) {
        result[[key substringToIndex:key.length - 4]] =
            @([value caseInsensitiveCompare:@"True"] == NSOrderedSame);
    } else {
        result[key] = [value copy];
    }
}

NSDictionary<NSString *, id> *ParsePrintOptions(NSString *string) {
    cups_option_t *options = NULL;
    int count = cupsParseOptions(string.UTF8String, 0, &options);

    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count; i++) {
        StoreTyped(result, @(options[i].name), @(options[i].value));
    }
    cupsFreeOptions(count, options);
    return result;
}


int main(int argc, const char* argv[])
{
    if (argc <= 3)
    {
        printf("The number of parameters are incorrect.\nUsage: tool title options pdffile");
        os_log_error(OS_LOG_DEFAULT, "The number of parameters are incorrect.\nUsage: tool title options pdffile");
        return 1;
    }
    
    NSDictionary *parameters = @{
        @"title":   @(argv[1]),
        @"options": ParsePrintOptions(@(argv[2])),
    };

    NSURL *pdfWorkflowApp = [[NSURL fileURLWithPath:@(argv[0])] URLByAppendingPathComponent:@"../../.."].URLByStandardizingPath;
    
    // Ensure we are situated in the pdf workflow package
    NSBundle *bundle = [NSBundle bundleWithURL:pdfWorkflowApp];
    if (!bundle.executableURL) {
        // bundle not found - let's try the options
        NSString *pmOutputFilename = parameters[@"options"][@"com.apple.print.PrintSettings.PMOutputFilename"];
        bundle = [NSBundle bundleWithURL:[NSURL URLWithString:pmOutputFilename]];
        if (!bundle.executableURL) {
            printf("Cannot find original pdf workflow");
            os_log_error(OS_LOG_DEFAULT, "Cannot find original pdf workflow");
            return 2;
        }
    }

    
    NSString *name = [[pdfWorkflowApp.lastPathComponent stringByDeletingPathExtension] stringByAppendingPathExtension:@"app"];
    NSURL *destURL = [[NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES] URLByAppendingPathComponent:name isDirectory:YES];

    NSError *error = nil;
    
    // copy fails if the destination already exists
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm removeItemAtURL:destURL error:&error]) {
        os_log_error(OS_LOG_DEFAULT, "Remove failed %{public}@", error);
    }

    if (![fm copyItemAtURL:bundle.bundleURL toURL:destURL error:&error]) {
        printf("Copy failed %s\n", error.description.UTF8String);
        os_log_error(OS_LOG_DEFAULT, "Copy failed %{public}@", error);
        return 3;
    }

    NSURL *pdfURL = [NSURL fileURLWithPath:@(argv[3])];
    os_log_debug(OS_LOG_DEFAULT, "SVO: Filepath: %{public}@", pdfURL);

    NSURL *paramsURL = [pdfURL URLByAppendingPathExtension:@"plist"];

    error = nil;
    if (![parameters writeToURL:paramsURL error:&error]) {
        printf("Writing parameters failed %s\n", error.description.UTF8String);
        os_log_error(OS_LOG_DEFAULT, "Writing parameters failed %{public}@", error);
        return 4;
    }

    NSWorkspaceOpenConfiguration *config = [NSWorkspaceOpenConfiguration configuration];
    config.createsNewApplicationInstance = YES;

    dispatch_semaphore_t done = dispatch_semaphore_create(0);

    __block NSError *openError = nil;
    [[NSWorkspace sharedWorkspace] openURLs:@[pdfURL]
                       withApplicationAtURL:destURL
                              configuration:config
                          completionHandler:^(NSRunningApplication *app, NSError *error) {
        openError = error;
        dispatch_semaphore_signal(done);
    }];

    dispatch_semaphore_wait(done, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
    
    if (openError) {
        os_log_error(OS_LOG_DEFAULT, "SVO: Hand-off failed: %{public}@", openError);
        return 5;
    }

    return 0;
}
