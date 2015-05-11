//
//  ViewController.m
//  Kids
//
//  Created by Todd Ditchendorf on 5/10/15.
//  Copyright (c) 2015 Todd Ditchendorf. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController ()

@end

@implementation CanvasViewController

- (void)dealloc {
    self.canvas = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSAssert(_canvas, nil);
    
    NSArray *imgNames = @[@"Chase", @"Marshall", @"Rocky", @"Zuma", @"Rubble", @"Sky"];
    
    NSUInteger i = 0;
    for (NSString *imgName in imgNames) {
        UIImage *img = [UIImage imageNamed:imgName];
        UIView *iv = [[[UIImageView alloc] initWithImage:img] autorelease];
        iv.userInteractionEnabled = YES;
        CGRect r = iv.frame;
        r.origin.x += i * 80.0;
        r.size = CGSizeMake(100.0, 100.0);
        iv.frame = r;
        
        [_canvas addSubview:iv];
        ++i;
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
