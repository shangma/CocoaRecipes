//
//  GraphiqueAppDelegate.h
//  Graphique
//
//  Created by Sagar Natekar on 8/5/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

@class EquationEntryViewController;
@class GraphTableViewController;
@class RecentlyUsedEquationsViewController;
@class PreferencesController;

@interface GraphiqueAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSSplitView *horizontalSplitView;
@property (weak) IBOutlet NSSplitView *verticalSplitView;
@property (strong) EquationEntryViewController *equationEntryViewController;
@property (strong) GraphTableViewController *graphTableViewController;
@property (strong) RecentlyUsedEquationsViewController *recentlyUsedEquationsViewController;
@property (strong) PreferencesController *preferencesController;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void) changeGraphLineColor:(id) sender;
- (IBAction)showPreferencesPanel:(id)sender;
- (IBAction)exportAs:(id)sender;

@end
