//
//  OverlayView.h
//  Trim-app
//
//  Created by horimislime on 12/08/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface OverlayView : UIView{
    CGRect clipArea;
    CGPoint startLocation;
    
    float cropAreaSize;
    CGPoint cropCenter;
}
@property(nonatomic, assign) CGPoint cropCenter;
@property(nonatomic, assign) float cropAreaSize;

@end
