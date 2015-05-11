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
    
    // TARGETS
    {
        NSUInteger i = 0;
        for (id target in _scene[@"targets"]) {
            //NSString *name = target[@"name"];
            
            UIView *v = nil;
            
            NSString *imgName = target[@"imageName"];
            if (imgName) {
                UIImage *img = [UIImage imageNamed:imgName];
                TDAssert(img);
                
                v = [[[UIImageView alloc] initWithImage:img] autorelease];
            } else {
                TDAssert(target[@"frame"]);
                
                CGRect frame = CGRectFromString(target[@"frame"]);
                v = [[[UIView alloc] initWithFrame:frame] autorelease];
            }
            
            v.tag = i;
            
            UIColor *fillColor = TDHexaColor(target[@"fillColor"]);
            TDAssert(fillColor);
            
            v.backgroundColor = fillColor;
            [self.view insertSubview:v belowSubview:_canvas];
            
            ++i;
        }
    }

    // FIGURES
    {
        NSUInteger i = 0;
        for (id figure in _scene[@"figures"]) {
            
            UIView *v = nil;
            
            NSString *imgName = figure[@"imageName"];
            if (imgName) {
                UIImage *img = [UIImage imageNamed:imgName];
                TDAssert(img);
                
                v = [[[UIImageView alloc] initWithImage:img] autorelease];
            } else {
                TDAssert(figure[@"size"]);
                
                CGSize size = CGSizeFromString(figure[@"size"]);
                v = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)] autorelease];
            }
            
            v.tag = i;
            v.userInteractionEnabled = YES;
            
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
            
            [_canvas addSubview:v];
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

@end
