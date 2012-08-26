//
//  TrimmingViewController.h
//  candy
//
//  Created by horimislime on 12/08/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableImageView.h"
#import "OverlayView.h"


@class TrimmingViewController;

@protocol TrimmingViewControllerDelegate<NSObject>

-(void) trimmingController: (TrimmingViewController *) sender finished: (UIImage *) image;

@end

@interface TrimmingViewController : UIViewController<UIGestureRecognizerDelegate,
                                                     TrimmingViewControllerDelegate> {
   DraggableImageView   *draggableImageView;
   IBOutlet OverlayView *overlayView;
   IBOutlet UIView      *cropAreaView;
   IBOutlet UIImageView *backgroundImageView;
   UIImage              *originalImage;
}

@property (nonatomic, retain) DraggableImageView                            *draggableImageView;
@property (nonatomic, retain) OverlayView                                   *overlayView;
@property (nonatomic, retain) UIView                                        *cropAreaView;
@property (readwrite, nonatomic, assign) id<TrimmingViewControllerDelegate> delegate;

-(IBAction)handlePinch: (UIPinchGestureRecognizer *) recognizer;
-(IBAction)trim: (id) sender;

@end
