//
//  AppDelegate.m
//  JProperty
//
//  Created by alexiuce  on 2017/3/2.
//  Copyright © 2017年 io.github.alexiuce. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()




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
@end
