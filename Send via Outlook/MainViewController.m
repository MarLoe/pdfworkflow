//
//  MainViewController.m
//  Test
//
//  Created by Martin Løbger on 04/06/2018.
//  Copyright © 2018 ML-Consulting. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.

}


- (void)viewWillAppear
{
    // Make sure our window is always on top
    self.view.window.level = NSFloatingWindowLevel;
    self.view.window.title = @"Martin";
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
