//
//  Canvas.m
//  Kids
//
//  Created by Todd Ditchendorf on 5/10/15.
//  Copyright (c) 2015 Todd Ditchendorf. All rights reserved.
//

#import "Canvas.h"

@implementation Canvas

- (void)dealloc {
    self.draggingView = nil;
    [super dealloc];
}

- (void)drawRect:(CGRect)dirtyRect {
    [[UIColor redColor] setFill];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextFillRect(ctx, self.bounds);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)evt {
    [super touchesEnded:touches withEvent:evt];
    
    CGPoint p = [[touches anyObject] locationInView:self];
    
    UIView *v = [self hitTest:p withEvent:evt];
    NSLog(@"%@, %@", NSStringFromCGPoint(p), v);
    if (v != self) {
        self.draggingView = v;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)evt {
    [super touchesMoved:touches withEvent:evt];
    
    CGPoint p = [[touches anyObject] locationInView:self];

    if (_draggingView) {
        _draggingView.center = p;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)evt {
    [super touchesEnded:touches withEvent:evt];
    
    self.draggingView = nil;
}

@end
