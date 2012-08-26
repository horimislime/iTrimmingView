//
//  DraggableImageView.m
//  Trim-app
//  
//
//  Created by horimislime on 12/08/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DraggableImageView.h"


@implementation DraggableImageView

@synthesize  xMoved,yMoved,imageSize,cropSize,initialScale;


- (id)initWithImage:(UIImage *)image cropSize:(CGFloat)size{
    
    self=[super initWithImage:image];
    
    self.cropSize=size;
    self.imageSize=image.size;
    CGPoint currentCenter=self.center;
    CGFloat x=currentCenter.x-(image.size.width-self.cropSize)/2.0f;
    CGFloat y=currentCenter.y-(image.size.height-self.cropSize)/2.0f;
    
    self.center=CGPointMake(x, y);
    
    CGFloat scale=[self scaleToFit];
    
    self.transform=CGAffineTransformScale(self.transform, scale, scale);
    self.initialScale=scale;
    
    return self;
}

- (IMAGE_ORIENTATION)orientation{
    if(self.imageSize.width>self.imageSize.height){
        return LANDSCAPE;
        
    }else{
        return PORTRAIT;
    }
}

- (CGFloat)scaleToFit{
    if(self.imageSize.width>self.imageSize.height){
        return self.cropSize/[self imageSizeOnScreen].height;
        
    }else{
        return self.cropSize/[self imageSizeOnScreen].width;
    }
}

- (CGFloat)scale{
    return self.frame.size.width/self.imageSize.width;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    
    xMoved+=(pt.x - startLocation.x)*self.scale;
    yMoved+=(pt.y - startLocation.y)*self.scale;
    frame.origin.x += (pt.x - startLocation.x)*self.scale;
    frame.origin.y += (pt.y - startLocation.y)*self.scale;
    
    [self setFrame: frame];
}

- (void) correctPosition {
    CGPoint currentOrigin = self.frame.origin;
    CGSize currentSize=[self imageSizeOnScreen];
    
    CGFloat xOffset=0,yOffset=0;
    if(currentOrigin.x>0.0f) {
        xOffset-=currentOrigin.x;
    }
    if(currentOrigin.x+currentSize.width<self.cropSize){
        xOffset+=self.cropSize-(currentOrigin.x+currentSize.width);
    }
    
    if(currentOrigin.y>0.0f){
        yOffset-=currentOrigin.y;
    }
    if(currentOrigin.y+currentSize.height<self.cropSize){
        yOffset+=self.cropSize-(currentOrigin.y+currentSize.height);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    
    CGPoint currentCenter=self.center;
    self.center=CGPointMake(currentCenter.x+xOffset,currentCenter.y+yOffset);
    
    [UIView commitAnimations];
    
    xMoved+=xOffset;
    yMoved+=yOffset;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self correctPosition];
}

- (CGSize) imageSizeOnScreen{
    return CGSizeMake(imageSize.width*self.scale, imageSize.height*self.scale);
}

@end
