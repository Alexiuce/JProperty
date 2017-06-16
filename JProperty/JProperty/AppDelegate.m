//
//  AppDelegate.m
//  JProperty
//
//  Created by alexiuce  on 2017/3/2.
//  Copyright © 2017年 io.github.alexiuce. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSWindow *mainWindow;


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
   
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
   
    return !(flag || ([self.mainWindow makeKeyAndOrderFront:self],0));
}

- (NSWindow *)mainWindow{
    if (_mainWindow == nil) {
        for (NSWindow *main in NSApp.windows) {
            if ([NSStringFromClass([main class]) isEqualToString:@"NSWindow"]) {
                _mainWindow = main;
                break;
            }
        }
    }
    return _mainWindow;
}

@end
