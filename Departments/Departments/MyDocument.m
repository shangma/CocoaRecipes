//
//  MyDocument.m
//  Departments
//
//  Created by Sagar Natekar on 9/26/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "MyDocument.h"
#import "DepartmentViewController.h"
#import "EmployeeViewController.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
        
        viewControllers = [[NSMutableArray alloc] init];
        
        ManagingViewController *vc;
        vc = [[DepartmentViewController alloc] init];
        [vc setManagedObjectContext:self.managedObjectContext];
        [viewControllers addObject:vc];
        
        vc = [[EmployeeViewController alloc] init];
        [vc setManagedObjectContext:self.managedObjectContext];
        [viewControllers addObject:vc];
        
    }
    return self;
}

- (void)displayViewController:(ManagingViewController *)vc
{
    //Try to end editing
    NSWindow *w = [box window];
    BOOL ended = [w makeFirstResponder:w];
    if (!ended) {
        NSBeep();
        return;
    }
    
    //Put the view in the box
    NSView *v = [vc view];
    
    //Compute the new window frame, according to size of individual views inside the box
    NSSize currentSize = [[box contentView] frame].size;
    NSSize newSize = [v frame].size;
    float deltaWidth = newSize.width - currentSize.width;
    float deltaHeight = newSize.height - currentSize.height;
    NSRect windowFrame = [w frame];
    windowFrame.size.height += deltaHeight;
    windowFrame.origin.y -= deltaHeight;
    windowFrame.size.width += deltaWidth;
    
    [box setContentView:nil];
    [w setFrame:windowFrame display:YES animate:YES];
    [box setContentView:v];
    
    //Put the view controller in the responder chain
    [v setNextResponder:vc];
    [vc setNextResponder:box];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    NSMenu *menu = [popUp menu];
    NSUInteger i, itemCount;
    itemCount = [viewControllers count];
    
    for (i=0; i<itemCount; i++) {
        NSViewController *vc = [viewControllers objectAtIndex:i];
        NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:[vc title] action:@selector(changeViewController:) keyEquivalent:@""];
        [mi setTag:i];
        [menu addItem:mi];
    }
    
    [self displayViewController:[viewControllers objectAtIndex:0]];
    [popUp selectItemAtIndex:0];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)changeViewController:(id)sender
{
    NSUInteger i = [sender tag];
    ManagingViewController *vc = [viewControllers objectAtIndex:i];
    [self displayViewController:vc];
}
@end
