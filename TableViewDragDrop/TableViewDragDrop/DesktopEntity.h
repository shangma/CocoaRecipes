//
//  DesktopEntity.h
//  TableViewDragDrop
//
//  Created by Sagar Natekar on 9/11/13.
//  Copyright (c) 2013 Sagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesktopEntity : NSObject <NSPasteboardWriting, NSPasteboardReading>

@property (nonatomic, strong) NSURL *fileURL;
@property (readonly, strong) NSString *name;

- (id) initWithFileURL:(NSURL *) fileURL;
+ (DesktopEntity *) entityForURL:(NSURL *) url;

@end

@interface DesktopImageEntity : DesktopEntity

@property (nonatomic, strong) NSImage *image;

@end

@interface DesktopFolderEntity : DesktopEntity

@end
