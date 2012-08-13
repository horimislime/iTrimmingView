//
//  DraggableImageView.m
//  Trim-app
//
//  Created by horimislime on 12/08/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DraggableImageView.h"

@implementation DraggableImageView

@synthesize  xMoved,yMoved;

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    
    xMoved+=pt.x - startLocation.x;
    yMoved+=pt.y - startLocation.y;
    frame.origin.x += pt.x - startLocation.x;
    frame.origin.y += pt.y - startLocation.y;
    [self setFrame: frame];
}
@end
