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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:NSWindowWillCloseNotification object:nil];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
#pragma mark - 关闭窗口
- (void)closeWindow{
    /** 关闭窗口时退出应用 */
    [[NSApplication sharedApplication] terminate:self];
}

@end
