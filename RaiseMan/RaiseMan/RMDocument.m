//
//  RMDocument.m
//  RaiseMan
//
//  Created by Sagar Natekar on 7/21/13.
//  Copyright (c) 2013 xyz. All rights reserved.
//

#import "RMDocument.h"
#import "Person.h"
#import "PreferenceController.h"

//RMDocumentKVOContext enables this class to differentiate between its KVO messages and those intended for a superclass
static void *RMDocumentKVOContext;

@implementation RMDocument

@synthesize tableView;
@synthesize employeeController;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        employees = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleColorChange:) name:BNRColorChangedNotification object:nil];
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) handleColorChange:(NSNotification *) notif
{
    NSColor *color = [[notif userInfo] objectForKey:@"color"];
    [tableView setBackgroundColor:color];
    
}

- (void) setEmployees:(NSMutableArray *)a
{
    for (Person *person in employees) {
        [self stopObservingPerson:person];
    }
    employees = a;
    for (Person *person in employees) {
        [self startObservingPerson:person];
    }
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"RMDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    [tableView setBackgroundColor:[PreferenceController preferenceTableBgColor]];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    //End editing
    [[tableView window] endEditingFor:nil];
    
    //Create an NSData object from employees array
    return [NSKeyedArchiver archivedDataWithRootObject:employees];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSLog(@"About to read data of type %@", typeName);
    NSMutableArray *newArray = nil;
    @try {
        newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@", exception);
        if (outError) {
            NSDictionary *d = [NSDictionary dictionaryWithObject:@"The data is corrupted" forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
        }
        
        return NO;
    }
    @finally {
        [self setEmployees:newArray];
        return YES;
    }
}

- (void) insertObject:(Person *)p inEmployeesAtIndex:(NSUInteger)index
{
    NSLog(@"Adding %@ to %@", p, employees);
    
    //Add the inverse of this operation to Undo stack - Since this is a document based app, it automatically gets an undomanager
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Add Person"];
    }
    
    //Add the Person to the array
    [self startObservingPerson:p];
    [employees insertObject:p atIndex:index];
}

- (void) removeObjectFromEmployeesAtIndex:(NSUInteger)index
{
    Person *p = [employees objectAtIndex:index];
    NSLog(@"removing %@ from %@", p, employees);
    
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:p inEmployeesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Remove Person"];
    }
    
    [self stopObservingPerson:p];
    [employees removeObjectAtIndex:index];
}

- (void) startObservingPerson:(Person *) person
{
    [person addObserver:self forKeyPath:@"personName" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
    [person addObserver:self forKeyPath:@"expectedRaise" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
}

- (void) stopObservingPerson:(Person *) person
{
    [person removeObserver:self forKeyPath:@"personName" context:&RMDocumentKVOContext];
    [person removeObserver:self forKeyPath:@"expectedRaise" context:&RMDocumentKVOContext];
    
}

- (void) changeKeyPath:(NSString *) keyPath ofObject:(id)obj toValue:(id) newValue
{
    //setValue:forKeyPath: will cause the KVO method to be called, which takes care of undo stuff
    [obj setValue:newValue forKeyPath:keyPath];
}

//This method is called whenever an object is edited by either the user or the changeKeyPath:ofObject:toValue method. 
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context != &RMDocumentKVOContext) {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    NSUndoManager *undo = [self undoManager];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    
    //NSNull objects are used to represent nil in dict
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
    
    NSLog(@"OldValue = %@", oldValue);
    
    //Put a call to changeKeyPath:ofObject:toValue: on the undo stack with old value for changed key.
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
    
    [undo setActionName:@"Edit"];
}

- (IBAction)createEmployee:(id)sender
{
    NSWindow *w = [tableView window];
    
    //Try to end any editing that is taking place
    BOOL editingEnded = [w makeFirstResponder:w];
    
    if (!editingEnded) {
        NSLog(@"Unable to end editing");
        return;
    }
    
    NSUndoManager *undo = [self undoManager];
    
    //Has an edit already occurred in this event ?
    if ([undo groupingLevel] > 0) {
        //Close the last group
        [undo endUndoGrouping];
        //Open a new group
        [undo beginUndoGrouping];
    }
    
    //Create the object
    Person *p = [employeeController newObject];
    
    //Add it to the content array of 'employeeController'
    [employeeController addObject:p];
    
    //Re-sort
    [employeeController rearrangeObjects];
    
    //Get the sorted array
    NSArray *a = [employeeController arrangedObjects];
    
    //Find the obj just added
    NSUInteger row = [a indexOfObjectIdenticalTo:p];
    NSLog(@"starting edit of %@ in row %lu", p, row);
    
    //Begin the edit in the first column
    [tableView editColumn:0 row:row withEvent:nil select:YES];
}

- (IBAction)removeEmployee:(id)sender
{
    NSArray *selectedPeople = [employeeController selectedObjects];
    NSAlert *alert = [NSAlert alertWithMessageText:@"Do you really want to remove these people?" defaultButton:@"Remove" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"%ld people will be removed.", (unsigned long)[selectedPeople count]];
    
    [alert beginSheetModalForWindow:[tableView window] modalDelegate:self didEndSelector:@selector(alertEnded:code:context:) contextInfo:NULL];
}

- (void) alertEnded:(NSAlert *) alert
               code:(NSInteger) choice
            context:(void *)v
{
    if (choice == NSAlertDefaultReturn) {
        [employeeController remove:nil];
    }
}
@end
