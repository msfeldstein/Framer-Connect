//
//  AppDelegate.m
//  Framer Connect
//
//  Created by Michael Feldstein on 11/30/14.
//  Copyright (c) 2014 Extra Strength. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
    NSNetService* _service;
}
@property NSStatusItem* statusItem;
@property IBOutlet NSMenu* statusMenu;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:@"StatusIcon"];
    self.statusItem.menu = self.statusMenu;
    _service = [[NSNetService alloc] initWithDomain:@"" type:@"_framerconnect._tcp." name:@"Framer Connect Service" port:8000];
    [_service publish];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)quit:(id)sender {
    [NSApp terminate:nil];
}

@end
