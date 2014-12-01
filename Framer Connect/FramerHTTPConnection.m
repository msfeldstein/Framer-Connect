//
//  FramerHTTPConnection.m
//  Framer Connect
//
//  Created by Michael Feldstein on 12/1/14.
//  Copyright (c) 2014 Extra Strength. All rights reserved.
//

#import "FramerHTTPConnection.h"
#import <CocoaHTTPServer/HTTPDataResponse.h>

@implementation FramerHTTPConnection

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    NSLog(@"Path %@", path);
    NSDictionary* json = @{@"name":@"mike"};
    NSData* data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    HTTPDataResponse* response = [[HTTPDataResponse alloc] initWithData:data];
    return response;
}

@end
