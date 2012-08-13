//
//  ViewController.m
//  Trim-app
//
//  Created by horimislime on 12/08/01.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize draggableImageView;
@synthesize overlayView;

- (IBAction)trimSelected:(id)sender{
    self.overlayView.hidden=NO;
}

- (IBAction)trim:(id)sender{
    float scale=self.draggableImageView.frame.size.width/self.draggableImageView.image.size.width;
    
    
    float imageWidth=self.draggableImageView.image.size.width;
    float imageHeight=self.draggableImageView.image.size.height;
    
    float xOrigin=((imageWidth*scale-320.0f)/2.0f-self.draggableImageView.xMoved)/(scale);
    float yOrigin=((imageHeight*scale-320.0f)/2.0f-self.draggableImageView.yMoved)/(scale);
    float cropSize=320.0f/scale;
    CGRect cropRect=CGRectMake(xOrigin, yOrigin, cropSize, cropSize);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.draggableImageView.image.CGImage, cropRect);
    UIImage *outputImage = [UIImage imageWithCGImage:imageRef];
    NSData *data = UIImageJPEGRepresentation(outputImage, 1);
    [data writeToFile:@"/Users/horimi_soichiro/Desktop/image.jpg" atomically:YES];
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.overlayView.hidden=NO;
    
    UIImage *image=[UIImage imageNamed:@"example.jpg"];
    CGRect frame=self.draggableImageView.frame;
    frame.size.width=image.size.width;
    frame.size.height=image.size.height;
    
    [self.draggableImageView setImage:image];
    [self.draggableImageView setFrame:self.draggableImageView.frame];
    
    float ratio=320.0f/self.draggableImageView.frame.size.height;
    self.draggableImageView.transform=CGAffineTransformScale(self.draggableImageView.transform,ratio,ratio);
    
    self.overlayView.hidden=NO;
    
    return;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
