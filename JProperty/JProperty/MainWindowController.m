//
//  MainWindowController.m
//  JProperty
//
//  Created by alexiuce  on 2017/6/15.
//  Copyright © 2017年 io.github.alexiuce. All rights reserved.
//

#import "MainWindowController.h"
#import "AppDelegate.h"


@interface MainWindowController ()

@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    AppDelegate *ad = [NSApplication sharedApplication].delegate;
    ad.mainWindow = self.window;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
