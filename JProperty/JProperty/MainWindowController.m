//
//  MainWindowController.m
//  JProperty
//
//  Created by alexiuce  on 2017/6/15.
//  Copyright © 2017年 io.github.alexiuce. All rights reserved.
//

#import "MainWindowController.h"


@interface MainWindowController ()
@property (nonatomic, strong) NSStatusItem *status;

@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.status = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.status.image = [NSImage imageNamed:@"statusImage"];
    self.status.target = self;
    self.status.action = @selector(reopenWindow);
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)reopenWindow{
    [self.window isVisible]? nil : [self.window makeKeyAndOrderFront:self];
}


@end
