//
//  DraggableImageView.h
//  Trim-app
//
//  Created by horimislime on 12/08/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggableImageView : UIImageView{
    CGPoint startLocation;
    float xMoved,yMoved;
}

@property(nonatomic, assign) float xMoved,yMoved;

@end
