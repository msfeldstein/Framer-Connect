//
//  AppDelegate.m
//  Framer Connect
//
//  Created by Michael Feldstein on 11/30/14.
//  Copyright (c) 2014 Extra Strength. All rights reserved.
//

#import "AppDelegate.h"
#import "QRCodeGenerator.h"

@interface AppDelegate () {
    NSNetService* _service;
}
@property NSStatusItem* statusItem;
@property IBOutlet NSMenu* statusMenu;
@property IBOutlet NSWindow* qrWindow;
@property IBOutlet NSImageView* qrView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:@"StatusIcon"];
    self.statusItem.menu = self.statusMenu;
    _service = [[NSNetService alloc] initWithDomain:@"" type:@"_framerconnect._tcp." name:@"Framer Connect Service" port:8000];
    [_service publish];
    
    self.qrView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    self.qrView.image = [QRCodeGenerator qrImageForString:[self getIPAddress] imageSize:self.qrView.bounds.size.width];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)showQR:(id)sender {
    [self.qrWindow makeKeyAndOrderFront:nil];
}

- (IBAction)quit:(id)sender {
    [NSApp terminate:nil];
}

-(NSString *)getIPAddress
{
    for (NSString* address in [[NSHost currentHost] addresses]) {
        if ([address componentsSeparatedByString:@"."].count == 4) {
            if (![address isEqualToString:@"127.0.0.1"]) {
                return address;
            }
        }
    }
    return nil;
}

@end
