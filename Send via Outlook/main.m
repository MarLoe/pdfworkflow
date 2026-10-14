//
//  main.m
//  Send via Outlook
//
//  Created by Martin Løbger on 14/05/2018.
//  Copyright © 2018 ML-Consulting. All rights reserved.
//

#import "MainApplication.h"
#import "MainApplicationDelegate.h"


int main(int argc, const char* argv[])
{
    @autoreleasepool {
        MainApplication *app = [MainApplication sharedApplication];
        MainApplicationDelegate *delegate = [[MainApplicationDelegate alloc] init];
        app.delegate = delegate;
        [app run];
    }
    
    return 0;
}
