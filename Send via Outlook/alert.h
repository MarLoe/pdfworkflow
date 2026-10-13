//
//  alert.h
//  Send via Outlook
//
//  Created by Martin Løbger on 13/10/2026.
//  Copyright © 2026 ML-Consulting. All rights reserved.
//
#pragma once

NSModalResponse show_info(NSString* title, NSString* message);

NSModalResponse show_warn(NSString* title, NSString* message);

NSModalResponse show_error(NSString* title, NSString* errorMessage);

NSModalResponse show_alert(NSString* title, NSString* message, NSAlertStyle alertStyle);
