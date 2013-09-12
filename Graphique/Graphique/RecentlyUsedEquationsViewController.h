//
//  RecentlyUsedEquationsViewController.h
//  Graphique
//
//  Created by Sagar Natekar on 8/6/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

@class GroupItem;
@class Equation;

@interface RecentlyUsedEquationsViewController : NSViewController <NSOutlineViewDataSource, NSSplitViewDelegate, NSOutlineViewDelegate>
{
    @private
    GroupItem *rootItem;
    NSManagedObjectContext *managedObjectContext;
    
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IBOutlet NSOutlineView *outlineView;

- (void) remember:(Equation *) equation;
- (void) loadChildrenForItem:(id) item;

@end
