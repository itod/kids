//
//  ViewController.h
//  Kids
//
//  Created by Todd Ditchendorf on 5/10/15.
//  Copyright (c) 2015 Todd Ditchendorf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Canvas;

@interface CanvasViewController : UIViewController

- (instancetype)initWithScene:(NSDictionary *)scene;

@property (nonatomic, retain) IBOutlet Canvas *canvas;
@property (nonatomic, retain) NSDictionary *scene;
@end

