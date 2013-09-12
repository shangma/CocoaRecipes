//
//  GraphiqueAppDelegate.m
//  Graphique
//
//  Created by Sagar Natekar on 8/5/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "GraphiqueAppDelegate.h"
#import "EquationEntryViewController.h"
#import "GraphTableViewController.h"
#import "RecentlyUsedEquationsViewController.h"
#import "GraphView.h"
#import "PreferencesController.h"

@implementation GraphiqueAppDelegate

@synthesize horizontalSplitView;
@synthesize verticalSplitView;
@synthesize equationEntryViewController;
@synthesize graphTableViewController;
@synthesize recentlyUsedEquationsViewController;
@synthesize preferencesController;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

+ (void) initialize
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSFont *equationFont = [NSFont systemFontOfSize:18.0];
    NSData *fontData = [NSArchiver archivedDataWithRootObject:equationFont];
    
    NSColor *lineColor = [NSColor blackColor];
    NSData *colorData = [NSArchiver archivedDataWithRootObject:lineColor];
    
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:fontData,@"equationFont",colorData,@"lineColor", nil];
    [userDefaults registerDefaults:appDefaults];
    
    [[NSFontManager sharedFontManager] setAction:@selector(changeEquationFont:)];
    
    [NSColorPanel setPickerMask:NSColorPanelCrayonModeMask];    
    
}

- (void) changeEquationFont:(id) sender
{
    // Get the user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Get the user's font selection and convert from NSData to NSFont
    NSData *fontData = [userDefaults dataForKey:@"equationFont"];
    NSFont *equationFont = (NSFont *)[NSUnarchiver unarchiveObjectWithData:fontData];
    
    NSFont *newFont = [sender convertFont:equationFont];
    
    fontData = [NSArchiver archivedDataWithRootObject:newFont];
    [userDefaults setObject:fontData forKey:@"equationFont"];
    
    // Tell the equation entry field to update to the new font
    [self.equationEntryViewController controlTextDidChange:nil];
    
}

- (void) changeGraphLineColor:(id) sender
{
    // Set the selected color in the user defaults
    NSData *colorData = [NSArchiver archivedDataWithRootObject:[(NSColorPanel *)sender
                                                                color]];
    
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"lineColor"];
    
    [self.graphTableViewController.graphView setNeedsDisplay:YES];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.equationEntryViewController = [[EquationEntryViewController alloc] initWithNibName:@"EquationEntryViewController" bundle:nil];
    
    [self.verticalSplitView replaceSubview:[[self.verticalSplitView subviews] objectAtIndex:1]  with:equationEntryViewController.view];
    
    self.graphTableViewController = [[GraphTableViewController alloc] initWithNibName:@"GraphTableViewController" bundle:nil];

    [self.horizontalSplitView replaceSubview:[[self.horizontalSplitView subviews] objectAtIndex:1] with:graphTableViewController.view];
    
    self.recentlyUsedEquationsViewController = [[RecentlyUsedEquationsViewController
                                                 alloc]
        initWithNibName:@"RecentlyUsedEquationsViewController" bundle:nil];
    recentlyUsedEquationsViewController.managedObjectContext = self.managedObjectContext;
    
    [self.verticalSplitView replaceSubview:[[self.verticalSplitView subviews]
                                            objectAtIndex:0]
        with:recentlyUsedEquationsViewController.view];
    
    self.verticalSplitView.delegate = recentlyUsedEquationsViewController;
    
    [[NSColorPanel sharedColorPanel] setTarget:self];
    [[NSColorPanel sharedColorPanel] setAction:@selector(changeGraphLineColor:)];
}

- (IBAction)showPreferencesPanel:(id)sender
{
    if (preferencesController == nil) {
        preferencesController = [[PreferencesController alloc] init];
    }
    
    [preferencesController showWindow:self];
    
}

- (IBAction)exportAs:(id)sender
{
    //Obtain image representation
    NSBitmapImageRep *imageRep = [graphTableViewController exportAsImage];
    
    //Create PNG
    NSData *data = [imageRep representationUsingType:NSPNGFileType properties:nil];
    
    //Create Save...As dialog
    NSSavePanel *saveDlg = [NSSavePanel savePanel];
    [saveDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"png", nil]];
    
    //Open the dialog and save if user selected OK
    NSInteger result = [saveDlg runModal];
    if (result == NSOKButton) {
        [data writeToURL:saveDlg.URL atomically:YES];
    }
}

- (NSManagedObjectModel *) managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSString* dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES) lastObject];
    NSURL *storeURL = [NSURL fileURLWithPath: [dir stringByAppendingPathComponent:
                                               @"Graphique.sqlite"]];
    
    NSError *error = nil;
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

- (NSManagedObjectContext *) managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
    
    
}

@end
