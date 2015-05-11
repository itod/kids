//
//  ViewController.m
//  Kids
//
//  Created by Todd Ditchendorf on 5/10/15.
//  Copyright (c) 2015 Todd Ditchendorf. All rights reserved.
//

#import "CanvasViewController.h"
#import "Canvas.h"

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
            
            CALayer *v = nil;
            
            NSString *imgName = figure[@"imageName"];
            if (imgName) {
                UIImage *img = [UIImage imageNamed:imgName];
                TDAssert(img);
                
                v = [CALayer layer];
                v.contents = (id)[img CGImage];
            } else {
                TDAssert(figure[@"size"]);
                
                CGSize size = CGSizeFromString(figure[@"size"]);
                CGRect frame = CGRectMake(0.0, 0.0, size.width, size.height);
                v = [CALayer layer];
                v.frame = frame;
            }
            
            [v setValue:@(i) forKey:@"tag"];
            
            // FRAME
            {
                CGFloat w = 100.0, h = 100.0;
                CGRect canvasRect = CGRectInset(_canvas.bounds, w, h);
                
                CGRect r = v.frame;
                r.origin.x = round(drand48() * canvasRect.size.width);
                r.origin.y = round(drand48() * canvasRect.size.height);
                
                r.size = CGSizeMake(w, h);
                v.frame = r;
            }
            
            [v removeAllAnimations];
            v.delegate = self;

            UIColor *backgroundColor = TDHexaColor(figure[@"backgroundColor"]);
            UIColor *borderColor = TDHexaColor(figure[@"borderColor"]);
            
            v.backgroundColor = [backgroundColor CGColor];
            v.borderColor = [borderColor CGColor];
            v.borderWidth = [figure[@"borderWidth"] doubleValue];
            v.cornerRadius = [figure[@"cornerRadius"] doubleValue];

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

@end
