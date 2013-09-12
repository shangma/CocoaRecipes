//
//  KVCFunAppDelegate.m
//  KVCFun
//
//  Created by Sagar Natekar on 7/20/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "KVCFunAppDelegate.h"

@implementation KVCFunAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (id) init
{
    if (self = [super init])
    {
        //KVC
        [self setValue:[NSNumber numberWithInt:5] forKey:@"fido"];
        NSNumber *n = [self valueForKey:@"fido"];
        NSLog(@"Fido = %@", n);
    }
    
    return self;
}

- (int)fido
{
    NSLog(@"-fido is returning %d", fido);
    return fido;
}

- (void) setFido:(int)x
{
    NSLog(@"-setFido: is called with %d", x);
    fido = x;
}

- (IBAction)incrementFido:(id)sender {
    
    [self willChangeValueForKey:@"fido"];
    fido++;
    NSLog(@"Fido is now %d", fido);
    [self didChangeValueForKey:@"fido"];
}

@end
