//
//  WindowController.m
//  JProperty
//
//  Created by alexiuce  on 2017/3/6.
//  Copyright © 2017年 io.github.alexiuce. All rights reserved.
//

#import "WindowController.h"

@interface WindowController ()
@property (strong, nonatomic) NSStatusItem *statusBar;
@property (assign, nonatomic) BOOL selectedBar;
@end

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    _statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSImage *barImage = [NSImage imageNamed:@"jsonItem"];
    _statusBar.image= barImage;
    _statusBar.target = self;
    _statusBar.action = @selector(customHandleWindow);
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
/** 窗口处理逻辑 */
- (void)customHandleWindow{
    _selectedBar = !_selectedBar;
    if (_selectedBar) {[self close];return;}
    [self showWindow:nil];
}
@end
