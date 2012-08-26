//
//  OverlayView.m
//  Shows frame of trimming area
//
//  Created by horimislime on 12/08/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OverlayView.h"

//切り取り枠の縦横サイズ
#define CROP_SIZE 320.0 

@implementation OverlayView

/*!
 * @brief 切り取り枠サイズを返す
 */
-(float)cropSize{
    return CROP_SIZE;
}

/*!
 * @brief 初期化
 */
- (void)drawRect:(CGRect)rect{
    //枠外を黒で塗りつぶし
    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    
    //切り取りエリアの指定
    CGRect cropArea=CGRectMake(self.center.x-CROP_SIZE/2.0, self.center.y-CROP_SIZE/2.0, CROP_SIZE, CROP_SIZE);
    CGRect holeRectIntersection = CGRectIntersection(cropArea, rect);
    
    [[UIColor clearColor] setFill];
    UIRectFill(holeRectIntersection);
    
    //外枠の点線設定
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:cropArea];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    [shapeLayer setLineWidth:2.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:5], nil]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cropArea cornerRadius:0.0];
    [shapeLayer setPath:path.CGPath];
    [[self layer] addSublayer:shapeLayer];
}

@end
