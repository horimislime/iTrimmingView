//
//  ViewController.h
//  Trim-app
//
//  Created by horimislime on 12/08/01.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableImageView.h"
#import "OverlayView.h"

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>{
    IBOutlet DraggableImageView *draggableImageView;
    IBOutlet OverlayView *overlayView;
    IBOutlet UIView *cropAreaView;
}

@property (nonatomic, retain) DraggableImageView *draggableImageView;
@property (nonatomic, retain) OverlayView *overlayView;


- (IBAction)trim:(id)sender;
- (IBAction)showPicker:(id)sender;
- (IBAction)trimSelected:(id)sender;

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
@end
