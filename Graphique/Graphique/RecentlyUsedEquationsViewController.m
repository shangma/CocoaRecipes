//
//  RecentlyUsedEquationsViewController.m
//  Graphique
//
//  Created by Sagar Natekar on 8/6/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "RecentlyUsedEquationsViewController.h"
#import "EquationItem.h"
#import "Equation.h"
#import "GroupItem.h"
#import "GraphiqueAppDelegate.h"
#import "EquationEntryViewController.h"
#import "GraphTableViewController.h"

#define EQUATION_ENTRY_MIN_WIDTH 225.0
#define PREFERRED_RECENT_EQUATIONS_MIN_WIDTH 100.0

@interface RecentlyUsedEquationsViewController ()

@end

@implementation RecentlyUsedEquationsViewController

@synthesize managedObjectContext, outlineView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        rootItem = [[GroupItem alloc] init];
        
    }
    
    return self;
}

- (void) remember:(Equation *)equation
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    
    NSString *groupName = [dateFormat stringFromDate:today];
    
    //Create the fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Define the kind of entity to look for
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    //Add a predicate to further specify what we are looking for
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", groupName];
    [fetchRequest setPredicate:predicate];
    
    NSArray *groups = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSManagedObject *groupMO = nil;
    
    if (groups.count > 0) {
        //We found one, use it
        groupMO = [groups objectAtIndex:0];
    }
    else
    {
        //Create a new grp as none exists
        groupMO = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
        
        [groupMO setValue:groupName forKey:@"name"];
    }
    
    NSManagedObject *equationMO = [NSEntityDescription insertNewObjectForEntityForName:@"Equation" inManagedObjectContext:self.managedObjectContext];
    
    //Set the timestamp and the representation
    [equationMO setValue:equation.text forKey:@"representation"];
    [equationMO setValue:[NSDate date] forKey:@"timestamp"];
    [equationMO setValue:groupMO forKey:@"group"];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@", [error userInfo]);
        abort();
    }
    
    //Reload outline
    [rootItem reset];
    [outlineView reloadData];
}

- (void) loadChildrenForItem:(id)item
{
    //If item is not a grp, there is nothing to load
    if (![item isKindOfClass:GroupItem.class]) {
        return;
    }
    
    GroupItem *group = (GroupItem *) item;
    
    //No point reloading if already loaded
    if (group.loaded) {
        return;
    }
    
    //Wipe out the node's children as we're about to reload them
    [group reset];
    
    //If the group is the rootItem, then load all available groups. Else, load the equations for that grp only based on its name
    if (group == rootItem) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSArray *groups = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                   error:nil];
        
        for (NSManagedObject *obj in groups) {
            GroupItem *groupItem = [[GroupItem alloc] init];
            groupItem.name = [obj valueForKey:@"name"];
            [group addChild:groupItem];
        }
    }
    else
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Equation"
                                                  inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Add a predicate to further specify what we are looking for
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group.name=%@",
                                  group.name];
        [fetchRequest setPredicate:predicate];
        NSArray *equations = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                      error:nil];
        for(NSManagedObject *obj in equations) {
            EquationItem *equationItem = [[EquationItem alloc] init];
            equationItem.text = [obj valueForKey:@"representation"];
            [group addChild:equationItem];
        }
    }
    
    group.loaded = YES;
    
    
    
}

#pragma mark SplitView Delegate methods
- (CGFloat) splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    return splitView.frame.size.width - EQUATION_ENTRY_MIN_WIDTH;
}

- (void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize
{
    //Get the new frame of split view
    NSSize size = splitView.bounds.size;
    
    //Get the divider width
    CGFloat dividerWidth = splitView.dividerThickness;
    
    // Get the frames of the recently used equations panel and the equation entry panel
    NSArray *views = splitView.subviews;
    NSRect recentlyUsed = [[views objectAtIndex:0] frame];
    NSRect equationEntry = [[views objectAtIndex:1] frame];
    
    // Set the widths
    // Sizing strategy:
    // 1) equation entry must be a minimum of 225 pixels minus the divider width
    // 2) recently used will stay at its current size, unless it's less than 100 pixels wide
    // 3) If recently used is less than 100 pixels, grow it as much as possible until it reaches 100
    float totalFrameWidth = size.width - dividerWidth;
    
    // Set recently used to the desired size (at least 100 pixels wide), or keep at zero
    // if it was collapsed
    recentlyUsed.size.width = recentlyUsed.size.width == 0? 0: MAX(PREFERRED_RECENT_EQUATIONS_MIN_WIDTH, recentlyUsed.size.width);
    
    // Calculate the size of the equation entry based on the recently used width
    equationEntry.size.width = MAX((EQUATION_ENTRY_MIN_WIDTH - dividerWidth), (totalFrameWidth - recentlyUsed.size.width));
    
    // Now that the equation entry is set, recalculate the recently used
    recentlyUsed.size.width = totalFrameWidth - equationEntry.size.width;
    
    // Set the x location of the equation entry
    equationEntry.origin.x = recentlyUsed.size.width + dividerWidth;
    
    // Set the widths
    [[views objectAtIndex:0] setFrame:recentlyUsed];
    [[views objectAtIndex:1] setFrame:equationEntry];
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex
{
    return subview == self.view;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    return subview == self.view;
}


#pragma mark NSOutlineViewDataSource methods
- (NSInteger) outlineView:(NSOutlineView *)_outlineView numberOfChildrenOfItem:(id)item
{
    [self loadChildrenForItem:(item == nil ? rootItem : item)];
    return (item == nil)? [rootItem numberOfChildren] : [item numberOfChildren];
}

- (BOOL) outlineView:(NSOutlineView *)_outlineView isItemExpandable:(id)item
{
//    return (item == nil)? ([rootItem numberOfChildren] > 0) : ([item numberOfChildren] > 0);
    
    return [self outlineView:_outlineView numberOfChildrenOfItem:item] > 0;
}

- (id)outlineView:(NSOutlineView *)_outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil)
    {
        return [rootItem childAtIndex:index];
    }
    else
    {
        return [(GroupItem *)item childAtIndex:index];
    }
}

- (id)outlineView:(NSOutlineView *)_outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return (item == nil) ? @"" : [item text];
}

#pragma mark NSOutlineViewDelegate methods
- (void) outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSOutlineView *outlineView_ = [notification object];
    
    NSInteger row = [outlineView_ selectedRow];
    
    id item = [outlineView_ itemAtRow:row];
    
    //If an equation was selected, deal with it
    if ([item isKindOfClass:EquationItem.class])
    {
        EquationItem *equationItem = (EquationItem *)item;
        
        Equation *equation = [[Equation alloc] initWithString:equationItem.text];
        
        GraphiqueAppDelegate *delegate = [NSApplication sharedApplication].delegate;
        
        [delegate.equationEntryViewController.textField setStringValue:equation.text];
        [delegate.graphTableViewController draw:equation];
        
        [delegate.equationEntryViewController controlTextDidChange:nil];
    }
}

- (BOOL) outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return NO;
}

@end
