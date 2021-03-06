//
//  DraggableImageView.h
//
//  Created by horimislime on 12/08/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
   PORTRAIT,
   LANDSCAPE
}IMAGE_ORIENTATION;

@interface DraggableImageView : UIImageView {
   CGPoint startLocation;
   float   xMoved, yMoved;
   CGSize  imageSize;
   CGFloat cropSize;
}

@property (nonatomic, assign) float   xMoved, yMoved;
@property (nonatomic, assign) CGFloat cropSize;
@property (nonatomic, assign) CGSize  imageSize;

-(id)               initWithImage: (UIImage *) image cropSize: (CGFloat) cropSize;
-(CGFloat)          scale;
-(CGFloat)          initialScale;
-(void)             correctPosition;
-(IMAGE_ORIENTATION)orientation;
-(CGSize)           imageSizeOnScreen;
@end
