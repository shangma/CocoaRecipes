//
//  AppDelegate.m
//  ViewBasedTableView
//
//  Created by Sagar Natekar on 9/8/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import "AppDelegate.h"
#import "DesktopEntity.h"

@implementation AppDelegate {
    NSMutableArray *_tableContents;
}

- (void) applicationDidFinishLaunching:(NSNotification *)notification
{
    _tableContents = [[NSMutableArray alloc] init];
    //NSString *path = @"/Library/Application Support/Apple/iChat Icons/Flags";
    NSString *path = @"/Library/Application Support/Apple/iChat Icons/";
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    
    NSFileManager *fm = [NSFileManager defaultManager];
//    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
  
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtURL:url
                              includingPropertiesForKeys:nil
                                                 options:0
                                            errorHandler:^BOOL(NSURL *url, NSError *error) {
                                                return YES;
                                            }];
    
    /*
    NSString *file;
    while (file = [dirEnum nextObject])
    {
        NSString *filePath = [path stringByAppendingFormat:@"/%@", file];
        NSDictionary *obj = @{@"image": [[NSImage alloc] initByReferencingFile:filePath],
                              @"name": [file stringByDeletingPathExtension],
                              @"filePath": filePath};
        [_tableContents addObject:obj];
    }
    */
    
    for (NSURL *fileURL in dirEnum) {
        DesktopEntity *entity = [DesktopEntity entityForURL:fileURL];
        [_tableContents addObject:entity];
    }
    [_tableView reloadData];
}

- (IBAction)insertNewRow:(id)sender
{
    NSDictionary *obj = @{@"name": @"TempRow"};
    NSInteger selectedRow = [_tableView selectedRow];
    selectedRow++;
    
    [_tableContents insertObject:obj atIndex:selectedRow];
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:selectedRow] withAnimation:NSTableViewAnimationSlideDown];
    [_tableView scrollRowToVisible:selectedRow];
    [_tableView endUpdates];
}

- (IBAction)removeSelectedRows:(id)sender
{
    NSIndexSet *indexes = [_tableView selectedRowIndexes];
    [_tableContents removeObjectsAtIndexes:indexes];
    [_tableView removeRowsAtIndexes:indexes withAnimation:NSTableViewAnimationSlideDown];
}

- (IBAction)locateInFinder:(id)sender
{
    NSInteger selectedRow = [_tableView rowForView:sender];
    //NSDictionary *obj = _tableContents[selectedRow];
    DesktopEntity *entity = _tableContents[selectedRow];
    //[[NSWorkspace sharedWorkspace] selectFile:obj[@"filePath"] inFileViewerRootedAtPath:nil];
    [[NSWorkspace sharedWorkspace] selectFile:[entity.fileURL path] inFileViewerRootedAtPath:nil];
    
}

#pragma mark TableView datasource and delegate methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_tableContents count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    DesktopEntity *entity = _tableContents[row];
    if ([entity isKindOfClass:[DesktopFolderEntity class]])
    {
        NSTextField *groupCell = [tableView makeViewWithIdentifier:@"GroupCell" owner:self];
        [groupCell setStringValue:entity.name];
        return groupCell;
    }
    if ([entity isKindOfClass:[DesktopImageEntity class]]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"ImageCell" owner:self];
        [cellView.textField setStringValue:[entity.name stringByDeletingPathExtension]];
        [cellView.imageView setImage:((DesktopImageEntity *)entity).image];
        return cellView;
    }
    
    /*
    NSDictionary *flag = _tableContents[row];
    
    NSString *identifier = [tableColumn identifier];
    
    if ([identifier isEqualToString:@"MainCell"])
    {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
        [cellView.imageView setImage:flag[@"image"]];
        [cellView.textField setStringValue:flag[@"name"]];
        return cellView;
    }
    */
    return nil;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    DesktopEntity *entity = _tableContents[row];
    
    if ([entity isKindOfClass:[DesktopFolderEntity class]]) {
        return YES;
    }
    
    return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    DesktopEntity *entity = _tableContents[row];
    
    if ([entity isKindOfClass:[DesktopFolderEntity class]]) {
        return 22;
    }
    
    return [tableView rowHeight];
}

@end
