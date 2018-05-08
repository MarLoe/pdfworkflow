#!/usr/bin/python
# -*- coding: utf-8 -*-
#
#  tool.py
#  Send via Outlook
#
#  Created by Martin Lobger on 02/05/2018.
#  Copyright © 2018 ML-Consulting. All rights reserved.

import sys
import os.path

import common

def main(argv):
    
    paramTitle, paramOptions, paramFilePath = common.validateArgs(argv)

    common.executeOutlook(paramTitle, paramOptions, paramFilePath)

if __name__ == "__main__":
    main(sys.argv[1:])
