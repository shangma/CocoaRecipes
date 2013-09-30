//
//  iPingAppDelegate.m
//  iPing
//
//  Created by Sagar Natekar on 9/30/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "iPingAppDelegate.h"

@implementation iPingAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)startStopPing:(id)sender
{
    if (task) {
        [task interrupt];
    }
    else
    {
        task = [[NSTask alloc] init];
        [task setLaunchPath:@"/sbin/ping"];
        NSArray *args = [NSArray arrayWithObjects:@"-c10",[hostField stringValue], nil];
        [task setArguments:args];
        
        pipe = [[NSPipe alloc] init];
        [task setStandardOutput:pipe];
        
        NSFileHandle *fh = [pipe fileHandleForReading];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self];
        [nc addObserver:self
               selector:@selector(dataReady:)
                   name:NSFileHandleReadCompletionNotification
                 object:fh];
        
        [nc addObserver:self
               selector:@selector(taskTerminated:)
                   name:NSTaskDidTerminateNotification
                 object:task];
        
        [task launch];
        
        [fh readInBackgroundAndNotify];
    }
}

- (void) appendData:(NSData *)d
{
    NSString *s = [[NSString alloc] initWithData:d
                                        encoding:NSUTF8StringEncoding];
    
    NSTextStorage *ts = [outputView textStorage];
    [ts replaceCharactersInRange:NSMakeRange([ts length], 0) withString:s];
    
}

- (void) dataReady:(NSNotification *) n
{
    NSData *d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
    
    NSLog(@"dataReady:%ld bytes", [d length]);
    
    if ([d length]) {
        [self appendData:d];
    }
    
    //If task is running, start reading again
    if (task) {
        [[pipe fileHandleForReading] readInBackgroundAndNotify];
    }
}

- (void) taskTerminated:(NSNotification *) note
{
    NSLog(@"taskTerminated:");
    task = nil;
    [startButton setState:0];
}


@end
