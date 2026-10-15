//
//  MainApplicationDelegate+PDF.m
//  Send via Outlook
//
//  Created by Martin Løbger on 15/10/2026.
//  Copyright © 2026 ML-Consulting. All rights reserved.
//

@import PDFKit;
@import os.log;
#import "MainApplicationDelegate.h"

@implementation MainApplicationDelegate (PDF)

- (Boolean)updatePDFURL:(NSURL*)pdfURL withAuthor:(NSString*)author
{
    PDFDocument *document = [[PDFDocument alloc] initWithURL:pdfURL];
    if (document == nil) {
        os_log_error(OS_LOG_DEFAULT, "SVO: Could not open PDF: %{public}@", pdfURL);
        return false;
    }

    NSMutableDictionary *attributes = [document.documentAttributes mutableCopy] ?: [NSMutableDictionary dictionary];

    NSString *existingAuthor = attributes[PDFDocumentAuthorAttribute];
    if ([existingAuthor isKindOfClass:NSString.class] && existingAuthor.length > 0) {
        os_log_debug(OS_LOG_DEFAULT, "SVO: PDF already has author: %{public}@", existingAuthor);
        return false;
    }

    attributes[PDFDocumentAuthorAttribute] = author;
    document.documentAttributes = attributes;

    if (![document writeToURL:pdfURL]) {
        os_log_error(OS_LOG_DEFAULT, "SVO: Could not write PDF: %{public}@", pdfURL);
        return false;
    }
    
    return true;
}

@end
