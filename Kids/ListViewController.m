//
//  ListViewController.m
//  Kids
//
//  Created by Todd Ditchendorf on 5/10/15.
//  Copyright (c) 2015 Todd Ditchendorf. All rights reserved.
//

#import "ListViewController.h"
#import "CanvasViewController.h"

#define SCENE_CELL_ID @"Scene"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)dealloc {
    self.scenes = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Home", nil);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Scenes" ofType:@"plist"];
    id plist = [NSDictionary dictionaryWithContentsOfFile:path];
    TDAssert([plist count]);
    
    NSArray *scenes = plist[@"scenes"];
    TDAssert([scenes count]);
    
    self.scenes = scenes;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSInteger row = [sender tag];

    if ([SCENE_CELL_ID isEqualToString:[sender reuseIdentifier]]) {
        CanvasViewController *cvc = segue.destinationViewController;
        id scene = _scenes[row];
        cvc.scene = scene;
    } else {
        TDAssert(0);
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [_scenes count];
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SCENE_CELL_ID forIndexPath:path];
    TDAssert(cell);
    
    cell.tag = path.row;
    
    id scene = _scenes[path.row];
    TDAssert(scene);
    
    NSString *name = scene[@"name"];
    TDAssert([name length]);
    
    cell.textLabel.text = name;
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

@end
