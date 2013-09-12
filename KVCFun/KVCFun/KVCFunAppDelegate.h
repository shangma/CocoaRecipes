//
//  KVCFunAppDelegate.h
//  KVCFun
//
//  Created by Sagar Natekar on 7/20/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KVCFunAppDelegate : NSObject <NSApplicationDelegate>
{
    int fido;
}

@property (assign) IBOutlet NSWindow *window;

- (int) fido;
- (void) setFido:(int)x;

@end
