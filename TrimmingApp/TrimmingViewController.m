//
//  TrimmingViewController.m
//
//
//  Created by horimislime on 12/08/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TrimmingViewController.h"

@interface TrimmingViewController ()

@end

@implementation TrimmingViewController

@synthesize draggableImageView, overlayView, cropAreaView, delegate;


-(void)awakeFromNib
{
   originalImage = [UIImage imageNamed: @"example.png"];
   delegate      = self;
}

/*!
 * @brief Initializer
 */
-(void)viewDidLoad
{
   [super viewDidLoad];

   //Setting up tiled background image
   UIImage *wave         = [UIImage imageNamed: @"trim_background.png"];
   CGSize  imageViewSize = backgroundImageView.bounds.size;

   UIGraphicsBeginImageContext(imageViewSize);

   CGRect imageRect;
   imageRect.origin = CGPointMake(0.0, 0.0);
   imageRect.size   = CGSizeMake(wave.size.width, wave.size.height);

   CGContextRef imageContext = UIGraphicsGetCurrentContext();
   CGContextDrawTiledImage(imageContext, imageRect, wave.CGImage);

   UIImage *finishedImage = UIGraphicsGetImageFromCurrentImageContext();

   UIGraphicsEndImageContext();
   [backgroundImageView setImage: finishedImage];


   if (originalImage != nil)
   {
      //Correcting orientation of picture
      UIGraphicsBeginImageContext(originalImage.size);
      [originalImage drawInRect: CGRectMake(0, 0, originalImage.size.width,
                                            originalImage.size.height)];
      originalImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();

      self.draggableImageView =
         [[DraggableImageView alloc] initWithImage: originalImage cropSize: self.cropAreaView.frame.size.
             width];

      self.draggableImageView.userInteractionEnabled = YES;
      [self.cropAreaView addSubview: self.draggableImageView];
   }
}

/*!
 * @brief Trim
 */
-(IBAction)trim: (id) sender
{
   float  scale     = self.draggableImageView.scale;
   CGSize imageSize = self.draggableImageView.imageSize;

   //Calculating origin to crop
   float xOrigin =
      ((imageSize.width * scale -
        [self.overlayView cropSize]) / 2.0f - self.draggableImageView.xMoved) / scale;
   float yOrigin =
      ((imageSize.height * scale -
        [self.overlayView cropSize]) / 2.0f - self.draggableImageView.yMoved) / scale;
   float      cropSize = [self.overlayView cropSize] / scale;
   CGRect     cropRect = CGRectMake(xOrigin, yOrigin, cropSize, cropSize);

   CGImageRef imageRef = CGImageCreateWithImageInRect(self.draggableImageView.image.CGImage,
                                                      cropRect);
   UIImage    *outputImage = [UIImage imageWithCGImage: imageRef];

   [delegate trimmingController: self finished: outputImage];
}

/*!
 * @brief Expands/reduces size of the image with pinch gesture
 */
-(void)handlePinch: (UIPinchGestureRecognizer *) recognizer
{
   recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale,
                                                      recognizer.scale);
   recognizer.scale = 1;

   if ([recognizer state] == UIGestureRecognizerStateEnded)
   {
      float currentScale = draggableImageView.scale;
      //If image size is smaller than what of trimming frame
      if (currentScale < draggableImageView.initialScale)
      {
         //Animate and scale to fit trimming frame
         CGContextRef context = UIGraphicsGetCurrentContext();
         [UIView beginAnimations: nil context: context];
         [UIView setAnimationDuration: 0.2];
         [UIView setAnimationDelegate: self.draggableImageView];

         recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform,
                                                            1 / currentScale, 1 / currentScale);
         [self.draggableImageView correctPosition];

         [UIView commitAnimations];
      }
   }
}

/*!
 * @brief Delegate method which is fired when trimming is finished
 */
-(void) trimmingController: (TrimmingViewController *) sender finished: (UIImage *) image
{
   //TODO:Check if the UIImage is png or not
   NSData *data = UIImagePNGRepresentation(image);

   //Change here as your environment
   [data writeToFile: @"/Users/horimislime/Desktop/out.png" atomically: YES];
}

-(void)dealloc
{
   [super dealloc];
}

@end
