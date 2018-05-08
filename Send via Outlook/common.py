#!/usr/bin/python
# -*- coding: utf-8 -*-
#
#  common.py
#  Send via Outlook
#
#  Created by Martin Lobger on 02/05/2018.
#  Copyright © 2018 ML-Consulting. All rights reserved.

import sys
import os.path

from localizable import NSLocalizedStringFromTableInBundleWithIdentifier

OSASCRIPT = "/usr/bin/osascript"

def scriptPath(script):
    return os.path.dirname(os.path.realpath(__file__)) + "/Scripts/{}.applescript".format(script)

def alert(text, message):
    os.system('"{}" "{}" "{}" "{}"'.format(OSASCRIPT, scriptPath("Alert"), text, message))

def validateArgs(argv):
    if len(argv) < 3:
        alert(NSLocalizedStringFromTableInBundleWithIdentifier("alert.title"), NSLocalizedStringFromTableInBundleWithIdentifier("alert.message.parameters"))
        sys.exit(1)

    paramTitle = argv[0]
    paramOptions = argv[1]
    paramFilePath = os.path.abspath(argv[2]) # Outlook can only handle absolute file paths

    if not os.path.isfile(paramFilePath):
        alert(NSLocalizedStringFromTableInBundleWithIdentifier("alert.title"), NSLocalizedStringFromTableInBundleWithIdentifier("alert.message.filenotfound").format(paramFilePath))
        sys.exit(2)

    return paramTitle, paramOptions, paramFilePath

def executeOutlook(title, options, file):
    os.system('"{}" "{}" "{}" "{}"'.format(OSASCRIPT, scriptPath("Send"), title, file))

