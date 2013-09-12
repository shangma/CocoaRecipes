//
//  GraphTableViewController.m
//  Graphique
//
//  Created by Sagar Natekar on 8/6/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "GraphTableViewController.h"
#import "GraphView.h"

@interface GraphTableViewController ()

@end

@implementation GraphTableViewController

@synthesize values;
@synthesize graphTableView;
@synthesize interval;
@synthesize graphView;
@synthesize tabView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        values = [NSMutableArray arrayWithCapacity:0];
        interval = 1.0;
    }
    
    return self;
}

 - (void) awakeFromNib
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Determine which tab to select based on the user defaults
    NSInteger selectedTab = [userDefaults boolForKey:@"InitialViewIsGraph"] ? 0 : 1;
    
    // Select the proper tab
    [tabView selectTabViewItemAtIndex:selectedTab];
    
}
- (void) draw:(Equation *)equation
{
    //Clear the cache
    [values removeAllObjects];
    
    //Calculate the values
    for (float x = -50.0; x<=50.0; x+=interval)
    {
        float y = [equation evaluateForX:x];
        [values addObject:[NSValue valueWithPoint:CGPointMake(x, y)]];
    }
    
    [self.graphTableView reloadData];
    
    [self.graphView setNeedsDisplay:YES];
}

- (NSBitmapImageRep *) exportAsImage
{
    NSSize mysize = graphView.bounds.size;
    
    NSBitmapImageRep *bir = [graphView bitmapImageRepForCachingDisplayInRect:graphView.bounds];
    
    [bir setSize:mysize];
    
    [graphView cacheDisplayInRect:graphView.bounds toBitmapImageRep:bir];
    
    return bir;
    
}

#pragma mark NSTableViewDataSource methods
- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return values.count;
}

- (id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    CGPoint point = [[values objectAtIndex:row] pointValue];
    float value = [[tableColumn identifier] isEqualToString:@"X"] ? point.x : point.y;
    return [NSString stringWithFormat:@"%0.2f", value];
}

@end
