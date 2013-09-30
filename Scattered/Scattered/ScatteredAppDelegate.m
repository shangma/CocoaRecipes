//
//  ScatteredAppDelegate.m
//  Scattered
//
//  Created by Sagar Natekar on 9/29/13.
//  Copyright (c) 2013 sagar. All rights reserved.
//

#import "ScatteredAppDelegate.h"

@interface ScatteredAppDelegate ()

- (void) addImagesFromFolderURL:(NSURL *) url;
- (NSImage *) thumbImageFromImage:(NSImage *) image;
- (void) presentImage:(NSImage *) image;
- (void) setText:(NSString *) text;

@end

@implementation ScatteredAppDelegate

- (id)init
{
    if (self = [super init]) {
        processingQueue = [[NSOperationQueue alloc] init];
        [processingQueue setMaxConcurrentOperationCount:4];
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    srandom((unsigned)time(NULL));
    
    //Set view to be layer-hosting
    view.layer = [CALayer layer];
    view.wantsLayer = YES;
    
    CALayer *textContainer = [CALayer layer];
    textContainer.anchorPoint = CGPointZero;
    textContainer.position = CGPointMake(10, 10);
    textContainer.zPosition = 100;
    textContainer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
    textContainer.borderColor = CGColorGetConstantColor(kCGColorWhite);
    textContainer.borderWidth = 2;
    textContainer.cornerRadius = 15;
    textContainer.shadowOpacity = 0.5f;
    [view.layer addSublayer:textContainer];
    
    textLayer = [CATextLayer layer];
    textLayer.anchorPoint = CGPointZero;
    textLayer.position = CGPointMake(10, 6);
    textLayer.zPosition = 100;
    textLayer.fontSize = 24;
    textLayer.foregroundColor = CGColorGetConstantColor(kCGColorWhite);
    [textContainer addSublayer:textLayer];
    
    [self setText:@"Loading..."];
    
    [self addImagesFromFolderURL:[NSURL fileURLWithPath:@"/Library/Desktop Pictures"]];
}

- (void)setText:(NSString *)text
{
    NSFont *font = [NSFont systemFontOfSize:textLayer.fontSize];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    NSSize size = [text sizeWithAttributes:attrs];
    
    size.width = ceilf(size.width);
    size.height = ceilf(size.height);
    textLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    textLayer.superlayer.bounds = CGRectMake(0, 0, size.width+16, size.height+20);
    textLayer.string = text;
}

- (NSImage *)thumbImageFromImage:(NSImage *)image
{
    const CGFloat targetHeight = 200.0f;
    NSSize imageSize = [image size];
    NSSize smallerSize = NSMakeSize(targetHeight*imageSize.width/imageSize.height, targetHeight);
    NSImage *smallerImage = [[NSImage alloc] initWithSize:smallerSize];
    [smallerImage lockFocus];
    [image drawInRect:NSMakeRect(0, 0, smallerSize.width, smallerSize.height)
             fromRect:NSZeroRect
            operation:NSCompositeCopy
             fraction:1.0];
    [smallerImage unlockFocus];
    
    return smallerImage;
    
}

- (void)addImagesFromFolderURL:(NSURL *)folderUrl
{
    [processingQueue addOperationWithBlock:^{
        
        NSTimeInterval t0 = [NSDate timeIntervalSinceReferenceDate];
        
        NSFileManager *mgr = [NSFileManager defaultManager];
        NSDirectoryEnumerator *dirEnum = [mgr enumeratorAtURL:folderUrl
                                   includingPropertiesForKeys:nil
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                 errorHandler:nil];
        for (NSURL *url in dirEnum)
        {
            NSNumber *isDir = nil;
            [url getResourceValue:&isDir
                           forKey:NSURLIsDirectoryKey
                            error:nil];
            if ([isDir boolValue]) {
                continue; //skip directories
            }
            
            [processingQueue addOperationWithBlock:^{
            
                NSLog(@"-- processing %@", [url lastPathComponent]);
                NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
                if (!image) {
                    return;
                }
                
                NSImage *thumbImage = [self thumbImageFromImage:image];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self presentImage:thumbImage];
                    [self setText:[NSString stringWithFormat:@"%0.1fs", [NSDate timeIntervalSinceReferenceDate] - t0]];
                }];
          }];
        }
    }];
}

- (void)presentImage:(NSImage *)image
{
    CGRect superLayerBounds = view.layer.bounds;
    
    NSPoint center = NSMakePoint(CGRectGetMidX(superLayerBounds), CGRectGetMidY(superLayerBounds));
    
    NSRect imageBounds = NSMakeRect(0, 0, image.size.width, image.size.height);
    
    CGPoint randomPoint = CGPointMake(CGRectGetMaxX(superLayerBounds) * (double)random() / (double) RAND_MAX, CGRectGetMaxY(superLayerBounds) * (double)random() / (double) RAND_MAX);
    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *posAnim = [CABasicAnimation animation];
    posAnim.fromValue = [NSValue valueWithPoint:center];
    posAnim.duration = 1.5;
    posAnim.timingFunction = tf;
    
    CABasicAnimation *bdsAnim = [CABasicAnimation animation];
    bdsAnim.fromValue = [NSValue valueWithRect:NSZeroRect];
    bdsAnim.duration = 1.5;
    bdsAnim.timingFunction = tf;
    
    CALayer *layer = [CALayer layer];
    layer.contents = image;
    layer.actions = [NSDictionary dictionaryWithObjectsAndKeys:posAnim, @"position", bdsAnim, @"bounds", nil];
    
    [CATransaction begin];
    [view.layer addSublayer:layer];
    layer.position = randomPoint;
    layer.bounds = NSRectToCGRect(imageBounds);
    [CATransaction commit];
}

@end
