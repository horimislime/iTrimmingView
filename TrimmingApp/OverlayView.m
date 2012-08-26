//
//  OverlayView.m
//  Shows frame of trimming area
//
//  Created by horimislime on 12/08/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OverlayView.h"

//Trimming frame size
#define CROP_SIZE    320.0

@implementation OverlayView


-(float)cropSize
{
   return(CROP_SIZE);
}

-(void)drawRect: (CGRect) rect
{
   //Fills with black color outside of trimming flame
   [[UIColor blackColor] setFill];
   UIRectFill(rect);

   //Defines bounds of the frame
   CGRect cropArea = CGRectMake(self.center.x - CROP_SIZE / 2.0,
                                self.center.y - CROP_SIZE / 2.0, CROP_SIZE, CROP_SIZE);
   CGRect holeRectIntersection = CGRectIntersection(cropArea, rect);

   [[UIColor clearColor] setFill];
   UIRectFill(holeRectIntersection);

   //Settings for line of trimming frame
   CAShapeLayer *shapeLayer = [CAShapeLayer layer];
   [shapeLayer setBounds: cropArea];
   [shapeLayer setPosition: self.center];
   [shapeLayer setFillColor: [[UIColor clearColor] CGColor]];
   [shapeLayer setStrokeColor: [[UIColor whiteColor] CGColor]];
   [shapeLayer setLineWidth: 2.0f];
   [shapeLayer setLineJoin: kCALineJoinRound];
   [shapeLayer setLineDashPattern:
    [NSArray arrayWithObjects: [NSNumber numberWithInt: 10], [NSNumber numberWithInt: 5], nil]];
   UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: cropArea cornerRadius: 0.0];
   [shapeLayer setPath: path.CGPath];
   [[self layer] addSublayer: shapeLayer];
}

@end
