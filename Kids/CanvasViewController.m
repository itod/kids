//
//  ViewController.m
//  Kids
//
//  Created by Todd Ditchendorf on 5/10/15.
//  Copyright (c) 2015 Todd Ditchendorf. All rights reserved.
//

#import "CanvasViewController.h"
#import "Canvas.h"

#define FIGURE_WIDTH 120.0
#define FIGURE_HEIGHT 120.0

#define FONT_SIZE 24.0
#define TEXT_HEIGHT 30.0

UIColor *TDHexaColor(NSString *str) {
    unsigned x = 0;
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanHexInt:&x];

    NSUInteger red   = (0xFF000000 & x) >> 24;
    NSUInteger green = (0x00FF0000 & x) >> 16;
    NSUInteger blue  = (0x0000FF00 & x) >>  8;
    NSUInteger alpha = (0x000000FF & x) >>  0;
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}

@interface CanvasViewController ()

@end

@implementation CanvasViewController

- (void)dealloc {
    self.canvas = nil;
    self.scene = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    TDAssert(_canvas);
    TDAssert(_scene);
    
    CGRect bounds = _canvas.bounds;
    bounds.size.height -= 44.0;
    
    // TARGETS
    {
        NSUInteger i = 0;
        for (id target in _scene[@"targets"]) {
            //NSString *name = target[@"name"];
            
            CALayer *v = nil;
            
            NSString *imgName = target[@"imageName"];
            if (imgName) {
                UIImage *img = [UIImage imageNamed:imgName];
                TDAssert(img);
                
                v = [CALayer layer];
                v.contents = img;
            } else {
                TDAssert(target[@"location"]);
                TDAssert(target[@"size"]);

                CGSize size = CGSizeFromString(target[@"size"]);

                NSString *locStr = target[@"location"];
                CGFloat x = 0.0, y = 0.0;
                
                if ([locStr isEqualToString:@"TopLeft"]) {
                    x = CGRectGetMinX(bounds);
                    y = CGRectGetMinY(bounds);
                } else if ([locStr isEqualToString:@"MidLeft"]) {
                    x = CGRectGetMinX(bounds);
                    y = CGRectGetMidY(bounds) - size.height*0.5;
                } else if ([locStr isEqualToString:@"BottomLeft"]) {
                    x = CGRectGetMinX(bounds);
                    y = CGRectGetMaxY(bounds) - size.height;
                } else if ([locStr isEqualToString:@"TopRight"]) {
                    x = CGRectGetMaxX(bounds) - size.width;
                    y = CGRectGetMinY(bounds);
                } else if ([locStr isEqualToString:@"MidRight"]) {
                    x = CGRectGetMaxX(bounds) - size.width;
                    y = CGRectGetMidY(bounds) - size.height*0.5;
                } else if ([locStr isEqualToString:@"BottomRight"]) {
                    x = CGRectGetMaxX(bounds) - size.width;
                    y = CGRectGetMaxY(bounds) - size.height;
                } else {
                    CGPoint locPt = CGPointFromString(locStr);
                    x = locPt.x;
                    y = locPt.y;
                }
                
                CGRect frame = CGRectMake(round(x), round(y), size.width, size.height);
                v = [CALayer layer];
                v.frame = frame;
            }
            
            [v setValue:@(i) forKey:@"tag"];
            
            UIColor *backgroundColor = TDHexaColor(target[@"backgroundColor"]);
            UIColor *borderColor = TDHexaColor(target[@"borderColor"]);

            v.backgroundColor = [backgroundColor CGColor];
            v.borderColor = [borderColor CGColor];
            v.borderWidth = [target[@"borderWidth"] doubleValue];
            v.cornerRadius = [target[@"cornerRadius"] doubleValue];
            
            [self.view.layer insertSublayer:v below:_canvas.layer];
            
            ++i;
        }
    }

    // FIGURES
    {
        NSUInteger i = 0;
        for (id figure in _scene[@"figures"]) {
            
            CALayer *v = [CALayer layer];
            [v removeAllAnimations];
            [v setValue:@(i) forKey:@"tag"];
            v.delegate = self;
            v.masksToBounds = NO;
            v.contentsGravity = kCAGravityCenter;

            CGSize size = CGSizeMake(FIGURE_WIDTH, FIGURE_HEIGHT);

            NSString *name = figure[@"name"];
            if (name) {
                CATextLayer *tv = [CATextLayer layer];
                [tv removeAllAnimations];
                [tv setValue:@(-1) forKey:@"tag"];
                [tv setValue:@"name" forKey:@"id"];
                tv.delegate = self;
                tv.masksToBounds = NO;
                
                tv.string = name;
                tv.fontSize = 26.0;
                tv.foregroundColor = [[UIColor blackColor] CGColor];
                tv.alignmentMode = kCAAlignmentCenter;
                
                tv.frame = CGRectMake(0.0, 0.0, size.width, TEXT_HEIGHT);

                [v addSublayer:tv];
            }
            
            NSString *imgName = figure[@"imageName"];
            if (imgName) {
                UIImage *img = [UIImage imageNamed:imgName];
                TDAssert(img);
                
                CALayer *iv = [CALayer layer];
                iv.delegate = self;
                [iv setValue:@(-1) forKey:@"tag"];
                [iv setValue:@"image" forKey:@"id"];

                iv.contents = (id)[img CGImage];
                iv.frame = CGRectMake(0.0, 0.0, size.width - TEXT_HEIGHT, size.height - TEXT_HEIGHT);
                [v addSublayer:iv];
            } else {
                TDAssert(figure[@"size"]);
                
                size = CGSizeFromString(figure[@"size"]);
            }
            
            // FRAME
            {
                CGRect canvasRect = CGRectInset(_canvas.bounds, size.width, size.height);
                
                CGRect r = CGRectMake(round(drand48() * canvasRect.size.width),
                                      round(drand48() * canvasRect.size.height),
                                      size.width, size.height);
                v.frame = r;
            }
            
            UIColor *backgroundColor = TDHexaColor(figure[@"backgroundColor"]);
            UIColor *borderColor = TDHexaColor(figure[@"borderColor"]);
            
            v.backgroundColor = [backgroundColor CGColor];
            v.borderColor = [borderColor CGColor];
            v.borderWidth = [figure[@"borderWidth"] doubleValue];
            v.cornerRadius = [figure[@"cornerRadius"] doubleValue];

//            v.borderColor = [[UIColor blackColor] CGColor];
//            v.borderWidth = 10.0;
//            v.cornerRadius = 10.0;

            [_canvas.layer addSublayer:v];
            ++i;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -
#pragma mark CALayerDelegate

- (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)evt {
   return [NSNull null];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    CGRect bounds = layer.bounds;
    CALayer *tv = nil;
    CALayer *iv = nil;
    
    for (CALayer *child in layer.sublayers) {
        NSString *identifier = [child valueForKey:@"id"];
        if ([identifier isEqualToString:@"name"]) {
            tv = child;
        } else if ([identifier isEqualToString:@"image"]) {
            iv = child;
        } else {
            TDAssert(0);
        }
    }
    
    if (tv) {
        tv.position = CGPointMake(CGRectGetMidX(bounds), round(CGRectGetMaxY(bounds)-TEXT_HEIGHT*0.5));
    }
    
    if (iv) {
        iv.position = CGPointMake(round(CGRectGetMidX(bounds)),
                                  round(CGRectGetMinY(bounds)+(bounds.size.width - TEXT_HEIGHT)*0.5));
    }
}

//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//    NSLog(@"%@", layer);
//    CGContextSetFillColorWithColor(ctx, [[UIColor purpleColor] CGColor]);
//    CGContextFillRect(ctx, layer.frame);
//}

@end
