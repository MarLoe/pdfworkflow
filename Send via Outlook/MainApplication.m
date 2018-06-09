//
//  MainApplication.m
//  Send via Outlook
//
//  Created by Martin Løbger on 06/06/2018.
//  Copyright © 2018 ML-Consulting. All rights reserved.
//

#import "MainApplication.h"

@implementation MainApplication

- (void)sendEvent:(NSEvent *)event
{
    if (event.type == NSEventTypeKeyDown)
    {
        NSString *inputKey = [event.charactersIgnoringModifiers lowercaseString];
        if ((event.modifierFlags & NSEventModifierFlagDeviceIndependentFlagsMask) == NSEventModifierFlagCommand ||
            (event.modifierFlags & NSEventModifierFlagDeviceIndependentFlagsMask) == (NSEventModifierFlagCommand | NSEventModifierFlagCapsLock))
        {
            // Text Input
            if ([inputKey isEqualToString:@"x"])
            {
                if ([self sendAction:@selector(cut:) to:nil from:self])
                    return;
            }
            if ([inputKey isEqualToString:@"c"])
            {
                if ([self sendAction:@selector(copy:) to:nil from:self])
                    return;
            }
            if ([inputKey isEqualToString:@"v"])
            {
                if ([self sendAction:@selector(paste:) to:nil from:self])
                    return;
            }
            if ([inputKey isEqualToString:@"z"])
            {
                if ([self sendAction:@selector(undo) to:nil from:self])
                    return;
            }
            if ([inputKey isEqualToString:@"a"])
            {
                if ([self sendAction:@selector(selectAll:) to:nil from:self])
                    return;
            }
            
            // Window
            if ([inputKey isEqualToString:@"w"] || [inputKey isEqualToString:@"q"])
            {
                if ([self sendAction:@selector(close:) to:self.keyWindow from:self])
                    return;
            }
        }
        else if ((event.modifierFlags & NSEventModifierFlagDeviceIndependentFlagsMask) == (NSEventModifierFlagCommand | NSEventModifierFlagShift) ||
                 (event.modifierFlags & NSEventModifierFlagDeviceIndependentFlagsMask) == (NSEventModifierFlagCommand | NSEventModifierFlagShift | NSEventModifierFlagCapsLock))
        {
            if ([inputKey isEqualToString:@"z"])
            {
                if ([self sendAction:NSSelectorFromString(@"redo:") to:nil from:self])
                    return;
            }
        }
    }
    [super sendEvent:event];
}

@end
