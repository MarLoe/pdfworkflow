#!/usr/bin/python
# -*- coding: utf-8 -*-
#
#  localizable.py
#  Send via Outlook
#
#  Created by Martin Lobger on 08/05/2018.
#  Copyright © 2018 ML-Consulting. All rights reserved.

import os

def NSLocalizedStringFromTableInBundleWithIdentifier(key, table = None, bundleIdentifier = None):
    
    from Foundation import NSUserDefaults, NSBundle

    # Since we are running in the "python" application, we cannot rely on localizations.
    # We have to roll our own, starting by getting preferred availble languages.
    if not hasattr(NSLocalizedStringFromTableInBundleWithIdentifier, "AppleLanguages"):
        standardUserDefaults = NSUserDefaults.standardUserDefaults()
        globalPreferences = standardUserDefaults.persistentDomainForName_(".GlobalPreferences")
        NSLocalizedStringFromTableInBundleWithIdentifier.AppleLanguages = globalPreferences["AppleLanguages"]

    if not hasattr(NSLocalizedStringFromTableInBundleWithIdentifier, "bundles"):
        NSLocalizedStringFromTableInBundleWithIdentifier.bundles = { }

    # Let's cache the the bundles we encounter
    if not NSLocalizedStringFromTableInBundleWithIdentifier.bundles.has_key(bundleIdentifier):
        if not bundleIdentifier == None:
            bundle = NSBundle.bundleWithIdentifier_(bundleIdentifier)
        else:
            # Find the bundle we (might) be in
            filePath = os.path.dirname(os.path.realpath(__file__))
            bundle = NSBundle.bundleWithPath_(filePath)
        if bundle == None:
            return key
        NSLocalizedStringFromTableInBundleWithIdentifier.bundles[bundleIdentifier] = bundle
    bundle = NSLocalizedStringFromTableInBundleWithIdentifier.bundles[bundleIdentifier]

    for country_code in NSLocalizedStringFromTableInBundleWithIdentifier.AppleLanguages:
        country_code = country_code.split("-")[0]
        translatedText = bundle.localizedStringForKey_value_table_(key, "***_NOT_FOUND_***", "{}.lproj/{}".format(country_code, table))
        if not translatedText == "***_NOT_FOUND_***":
            return translatedText
    
    return bundle.localizedStringForKey_value_table_(key, key, table)



