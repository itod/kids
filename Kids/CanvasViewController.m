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

- (instancetype)initWithScene:(NSDictionary *)scene {
    NSAssert(scene, nil);
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.scene = scene;
    }
    return self;
}

- (void)dealloc {
    self.canvas = nil;
    self.scene = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSAssert(_canvas, nil);
    NSAssert(_scene, nil);
    
    NSUInteger i = 0;
    for (id figure in _scene[@"figures"]) {
        NSString *imgName = figure[@"imageName"];
        
        UIImage *img = [UIImage imageNamed:imgName];
        UIView *iv = [[[UIImageView alloc] initWithImage:img] autorelease];
        iv.tag = i;
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
