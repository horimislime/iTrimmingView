//
//  OverlayView.m
//  Trim-app
//
//  Created by horimislime on 12/08/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

@synthesize cropCenter,cropAreaSize;



- (void)drawRect:(CGRect)rect{
    //枠外を黒で塗りつぶし
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    
    CGRect cropArea=CGRectMake(0.0f, 60.0f, self.frame.size.width, self.frame.size.width);
    CGRect holeRectIntersection = CGRectIntersection(cropArea, rect);
    
    [[UIColor clearColor] setFill];
    UIRectFill(holeRectIntersection);
    
    //外枠の点線設定
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:cropArea];
    [shapeLayer setPosition:CGPointMake(160.0f,220.0f)];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    [shapeLayer setLineWidth:2.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
    [NSArray arrayWithObjects:[NSNumber numberWithInt:10], 
    [NSNumber numberWithInt:5], nil]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cropArea cornerRadius:0.0];
    [shapeLayer setPath:path.CGPath];
    [[self layer] addSublayer:shapeLayer];
}

- (void)createCropAreaAround:(CGPoint)center withSze:(float)size{
    
}
@end
