//
//  Canvas.h
//  Kids
//
//  Created by Todd Ditchendorf on 5/10/15.
//  Copyright (c) 2015 Todd Ditchendorf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Canvas : UIView

@property (nonatomic, retain) CALayer *draggingView;
@property (nonatomic, assign) CGSize dragOffset;
@end
