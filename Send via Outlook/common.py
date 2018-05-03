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

from localizable import NSLocalizedString

OSASCRIPT = "/usr/bin/osascript"

def validateArgs(argv):
    if len(argv) < 3:
        lines = [
                 ' <<EOF',
                 'set alertText to "{}"'.format(NSLocalizedString("alert.title")),
                 'set alertMessage to "{}"'.format(NSLocalizedString("alert.message.parameters")),
                 'display alert alertText message alertMessage as critical buttons {"OK"} default button "OK" -- cancel button "Cancel"',
                 'EOF'
                 ]
        osaScript = "\n".join(lines)
        os.system(OSASCRIPT + osaScript)
        sys.exit(1)

    paramTitle = argv[0]
    paramOptions = argv[1]
    paramFilePath = os.path.abspath(argv[2]) # Outlook can only handle absolute file paths

    if not os.path.isfile(paramFilePath):
        lines = [
                 ' <<EOF',
                 'set alertText to "{}"'.format(NSLocalizedString("alert.title")),
                 'set alertMessage to "{}"'.format(NSLocalizedString("alert.message.filenotfound").format(paramFilePath)),
                 'display alert alertText message alertMessage as critical buttons {"OK"} default button "OK" -- cancel button "Cancel"',
                 'EOF'
                 ]
        osaScript = "\n".join(lines)
        os.system(OSASCRIPT + osaScript)
        sys.exit(2)

    return paramTitle, paramOptions, paramFilePath

def executeOutlook(title, options, file):
    lines = [
             ' <<EOF',
             'tell application "Microsoft Outlook"',
             '    activate',
             '    set subjectText to "{}"'.format(title),
             '    set fileName to "{}" as POSIX file --convert to posix file'.format(file),
             '    set theMessage to make new outgoing message with properties {subject:subjectText}',
             '    tell theMessage -- tell theMessage (not theContent) to add the attachment',
             '        make new attachment with properties {file:fileName}',
             '    end tell',
             '    open theMessage -- for further editing',
             'end tell',
             'EOF'
             ]
    osaScript = "\n".join(lines)
    os.system(OSASCRIPT + osaScript)

