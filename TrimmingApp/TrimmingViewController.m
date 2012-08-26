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

@synthesize draggableImageView,overlayView,cropAreaView,image,delegate;

CGImageRef imageRef;
UIImage *outputImage;
NSData *data;
UIBarButtonItem *saveButton;
CGFloat lastScale=1.0f;

- (void)awakeFromNib{
    image=[UIImage imageNamed:@"example.png"];
    delegate=self;
}   

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //Setting up tiled background image
    UIImage *wave = [UIImage imageNamed:@"trim_background.png"];
	CGSize imageViewSize = backgroundImageView.bounds.size;
	
	UIGraphicsBeginImageContext(imageViewSize);
    
	CGRect imageRect;
	imageRect.origin = CGPointMake(0.0, 0.0);
	imageRect.size = CGSizeMake(wave.size.width, wave.size.height);
	
	CGContextRef imageContext = UIGraphicsGetCurrentContext();
	CGContextDrawTiledImage(imageContext, imageRect, wave.CGImage);
    
	UIImage *finishedImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    [backgroundImageView setImage:finishedImage];
    

    if(image!=nil){
        
        //Correcting orientation of picture
        UIGraphicsBeginImageContext(image.size);  
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];  
        image = UIGraphicsGetImageFromCurrentImageContext();  
        UIGraphicsEndImageContext();
        
        self.draggableImageView=[[DraggableImageView alloc] initWithImage:image cropSize:self.cropAreaView.frame.size.width];
        
        self.draggableImageView.userInteractionEnabled=YES;
        [self.cropAreaView addSubview:self.draggableImageView];
    }
}

/*!
 * @brief Crop
 */
- (IBAction)trim:(id)sender {
    
    float scale=self.draggableImageView.scale;
    CGSize imageSize=self.draggableImageView.imageSize;
    
    //Calculating origin to crop
    float xOrigin=((imageSize.width*scale-[self.overlayView cropSize])/2.0f-self.draggableImageView.xMoved)/scale;
    float yOrigin=((imageSize.height*scale-[self.overlayView cropSize])/2.0f-self.draggableImageView.yMoved)/scale;
    float cropSize=[self.overlayView cropSize]/scale;
    CGRect cropRect=CGRectMake(xOrigin, yOrigin, cropSize, cropSize);
    
     imageRef = CGImageCreateWithImageInRect(self.draggableImageView.image.CGImage, cropRect);
     outputImage = [UIImage imageWithCGImage:imageRef];

    [delegate trimmingController:self finished:outputImage];
}

/*!
 * @brief Expands/reduces size of the image with pinch gesture
 */
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    lastScale+=recognizer.scale-1.0;
    
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
    
    if([recognizer state]==UIGestureRecognizerStateEnded){
        
        float scale=cropAreaView.frame.size.width/draggableImageView.cropSize;
        if(scale<1.0f){
            //Animate and scale to fit trimming frame
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:nil context:context];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationDelegate:self.draggableImageView];
            
            recognizer.view.transform=CGAffineTransformScale(recognizer.view.transform, 1/scale, 1/scale);
            [self.draggableImageView correctPosition];
            
            [UIView commitAnimations];
        }
    }
}

/*!
 * @brief Called when trim is finished
 */
-(void) trimmingController:(TrimmingViewController *)sender finished:(UIImage *)image {
    //TODO:Check if the UIImage is png or not
    NSData *data=UIImagePNGRepresentation(image);
    [data writeToFile:@"/Users/horimislime/Desktop/out.png" atomically:YES];
}

-(void)dealloc{
    [super dealloc];
}

@end
