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

@synthesize  xMoved, yMoved, imageSize, cropSize;


-(id)initWithImage: (UIImage *) image cropSize: (CGFloat) size
{
   [super initWithImage: image];
   self.cropSize  = size;
   self.imageSize = image.size;

   //Fits center of image
   CGPoint currentCenter = self.center;
   CGFloat x             = currentCenter.x - (image.size.width - self.cropSize) / 2.0f;
   CGFloat y             = currentCenter.y - (image.size.height - self.cropSize) / 2.0f;
   self.center = CGPointMake(x, y);

   //Scale to fit to trimming frame
   CGFloat scale = [self initialScale];

   self.transform = CGAffineTransformScale(self.transform, scale, scale);

   return(self);
}

-(IMAGE_ORIENTATION)orientation
{
   if (self.imageSize.width > self.imageSize.height)
   {
      return(LANDSCAPE);
   }
   else
   {
      return(PORTRAIT);
   }
}

/*!
 * @brief Returns the initial scale when image was loaded
 */
-(CGFloat)initialScale
{
   if (self.imageSize.width > self.imageSize.height)
   {
      return(self.cropSize / imageSize.height);
   }
   else
   {
      return(self.cropSize / imageSize.width);
   }
}

/*!
 * @brief Returns current scale of the image
 */
-(CGFloat)scale
{
   if ([self orientation] == LANDSCAPE)
   {
      return(self.superview.frame.size.height / self.imageSize.height);
   }
   else
   {
      return(self.superview.frame.size.width / self.imageSize.width);
   }
}

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
   CGPoint pt = [[touches anyObject] locationInView: self];

   startLocation = pt;
}

/*!
 * @brief Handles dragging events
 */
-(void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event
{
   CGPoint pt    = [[touches anyObject] locationInView: self];
   CGRect  frame = [self frame];

   xMoved         += (pt.x - startLocation.x) * self.scale;
   yMoved         += (pt.y - startLocation.y) * self.scale;
   frame.origin.x += (pt.x - startLocation.x) * self.scale;
   frame.origin.y += (pt.y - startLocation.y) * self.scale;

   [self setFrame: frame];
}

/*!
 * @brief Corrects image coordination if it is out of trimming frame
 */
-(void) correctPosition
{
   CGPoint currentOrigin = self.frame.origin;
   CGSize  currentSize   = [self imageSizeOnScreen];

   CGFloat xOffset = 0.0f, yOffset = 0.0f;

   if (currentOrigin.x > 0.0f)
   {
      xOffset -= currentOrigin.x;
   }
   if (currentOrigin.x + currentSize.width < self.cropSize)
   {
      xOffset += self.cropSize - (currentOrigin.x + currentSize.width);
   }

   if (currentOrigin.y > 0.0f)
   {
      yOffset -= currentOrigin.y;
   }
   if (currentOrigin.y + currentSize.height < self.cropSize)
   {
      yOffset += self.cropSize - (currentOrigin.y + currentSize.height);
   }

   CGContextRef context = UIGraphicsGetCurrentContext();
   [UIView beginAnimations: nil context: context];
   [UIView setAnimationDuration: 0.2];
   [UIView setAnimationDelegate: self];

   CGPoint currentCenter = self.center;
   self.center = CGPointMake(currentCenter.x + xOffset, currentCenter.y + yOffset);

   [UIView commitAnimations];

   xMoved += xOffset;
   yMoved += yOffset;
}

-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
   [self correctPosition];
}

-(CGSize) imageSizeOnScreen
{
   return(CGSizeMake(imageSize.width * self.scale, imageSize.height * self.scale));
}

@end
