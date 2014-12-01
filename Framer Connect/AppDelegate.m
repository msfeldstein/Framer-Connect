//
//  AppDelegate.m
//  Framer Connect
//
//  Created by Michael Feldstein on 11/30/14.
//  Copyright (c) 2014 Extra Strength. All rights reserved.
//

#import "AppDelegate.h"
#import <stdio.h>

typedef struct
{
    // Where to add window information
    __unsafe_unretained NSMutableArray * outputArray;
    // Tracks the index of the window when first inserted
    // so that we can always request that the windows be drawn in order.
    int order;
} WindowListApplierData;

NSString *kAppNameKey = @"applicationName";	// Application Name & PID
NSString *kWindowOriginKey = @"windowOrigin";	// Window Origin as a string
NSString *kWindowSizeKey = @"windowSize";		// Window Size as a string
NSString *kWindowIDKey = @"windowID";			// Window ID
NSString *kWindowLevelKey = @"windowLevel";	// Window Level
NSString *kWindowOrderKey = @"windowOrder";	// The overall front-to-back ordering of the windows as returned by the window
NSString *kWindowTitleKey = @"windowTitle";

void WindowListApplierFunction(const void *inputDictionary, void *context);
void WindowListApplierFunction(const void *inputDictionary, void *context)
{
    NSDictionary *entry = (__bridge NSDictionary*)inputDictionary;
    WindowListApplierData *data = (WindowListApplierData*)context;
    
    // The flags that we pass to CGWindowListCopyWindowInfo will automatically filter out most undesirable windows.
    // However, it is possible that we will get back a window that we cannot read from, so we'll filter those out manually.
    int sharingState = [[entry objectForKey:(id)kCGWindowSharingState] intValue];
    if(sharingState != kCGWindowSharingNone)
    {
        NSMutableDictionary *outputEntry = [NSMutableDictionary dictionary];
        
        // Grab the application name, but since it's optional we need to check before we can use it.
        NSString *applicationName = [entry objectForKey:(id)kCGWindowOwnerName];
        if(applicationName != NULL)
        {
            [outputEntry setObject:applicationName forKey:kAppNameKey];
        }
        id title = [entry objectForKey:(id)kCGWindowName];
        if (title)
            [outputEntry setObject:title forKey:kWindowTitleKey];
        
        data->order++;
        
        [data->outputArray addObject:outputEntry];
    }
}

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
    NSMutableArray * prunedWindowList = [NSMutableArray array];
    WindowListApplierData data = {prunedWindowList, 0};
    CFArrayApplyFunction(windowList, CFRangeMake(0, CFArrayGetCount(windowList)), &WindowListApplierFunction, &data);
    CFRelease(windowList);
    NSMutableArray* openProjects = [NSMutableArray array];
    for (NSDictionary* dict in prunedWindowList) {
        NSString* title = dict[kWindowTitleKey];
        if ([dict[kAppNameKey] rangeOfString:@"Framer Studio"].location != NSNotFound && title) {
            if ([title rangeOfString:@".framer"].location != NSNotFound)
                [openProjects addObject:dict[kWindowTitleKey]];
        }
    }
    NSLog(@"Open Projects %@", openProjects);

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
